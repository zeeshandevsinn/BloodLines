// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:bloodlines/Components/CustomMultipart.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/customWidget.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/SingletonPattern/singletonUser.dart';
import 'package:bloodlines/View/Forum/Data/forumData.dart';
import 'package:bloodlines/View/Forum/Model/forumDetailsModel.dart';
import 'package:bloodlines/View/Forum/Model/forumModel.dart';
import 'package:bloodlines/View/Forum/Model/topicModel.dart';
import 'package:bloodlines/View/Groups/Model/groupModel.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:bloodlines/View/Timeline/Model/followModel.dart';
import 'package:bloodlines/View/model/blockedListModel.dart';
import 'package:bloodlines/View/newsFeed/data/newsFeedPostServices.dart';
import 'package:bloodlines/View/newsFeed/model/commentModel.dart';
import 'package:bloodlines/View/newsFeed/model/eventInvitedList.dart';
import 'package:bloodlines/View/newsFeed/model/eventsModel.dart';
import 'package:bloodlines/View/newsFeed/model/feelingModel.dart';
import 'package:bloodlines/View/newsFeed/model/postMedia.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/View/newsFeed/model/searchedUserList.dart';
import 'package:bloodlines/View/newsFeed/view/post/newPost.dart';
import 'package:bloodlines/userModel.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:http_parser/http_parser.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart' as form;
import 'package:rich_text_view/rich_text_view.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FeedBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedController>(() => FeedController());
  }
}

class FeedController extends GetxController {
  RxInt tabIndex = 0.obs;
  RxInt searchFilters = 0.obs;
  String searchValue = "post";
  final searchTextController = TextEditingController();
  final groupName = TextEditingController();
  final groupDescription = TextEditingController();
  final charges = TextEditingController();
  final List<String> groupTerms = [];
  FollowModel? followers;
  FollowModel? followings;
  int? currentGroupId;
  FollowModel? friendFollowings;
  TaggedUserModel? taggedUserModel;
  FollowModel? friendFollowers;
  GroupsModel? allGroups;
  GroupsModel? createdGroups;
  GroupJoinedModel? joinedGroups;
  ForumDetailsData? model;
  GroupData? groupData;
  Posts? groupPosts;
  RequestModel? requestModel;
  List<UserModel> eventSelectList = [];
  List<UserModel> groupInviteSelectList = [];
  List<int> groupSelectList = [];
  TabController? followerController;
  TabController? friendFollowerController;
  int? parentCommentID;
  int? commentId;
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  EventsData? eventsData;
  int? commentIndex;
  int? commentReplyIndex;
  late RichTextController richTextController;
  FocusNode commentFocusNode = FocusNode();
  ForumModel? forumModel;
  ForumDetailsModel? forumDetailsModel;
  TopicModel? topicModel;
  RxBool unSeenMessages = false.obs;
  RxString groupType = "Subscription Group".obs;
  RxString commentNetworkImage = "".obs;

  final CustomPopupMenuController customPopupMenuController =
      CustomPopupMenuController();
  PostModel? postModelData;
  Rx<CommentModel?> commentModel = Rxn<CommentModel>();
  late List<ItemModel> menuItems = [
    ItemModel('Camera', Icons.camera_alt),
    ItemModel('Gallery', Icons.image),
  ];
  List<form.MultipartFile> media = [];

  RxBool isInviteAll = false.obs;
  RxBool commentUpdate = false.obs;
  RxBool imageUpdate = false.obs;
  RxBool commentField = false.obs;
  RxBool fieldUpdate = false.obs;
  String? replierName;
  XFile? imageFile;
  String? eventLatitude;
  String? eventLongitude;
  late RichTextController postTextController;
  RxInt backgroundColor = DynamicColors.primaryColorLight.value.obs;
  List<form.MultipartFile> fileList = [];
  List<String> deletedFileIds = [];
  List<String> mentionedCommentUsersIds = [];
  List<form.MultipartFile> audioList = [];
  List<PostMedia> tempList = [];
  List<PostMedia> removableMediaList = [];
  List<Mention> mentionList = [];
  List<int> groupUserIDs = [];
  List<int> friendIds = [];
  List<String> mentionedUsersIds = [];
  List<int> friendRemoveIds = [];
  List<int> taggedUserList = [];
  List<int> taggedPedigreeList = [];
  GroupsInvitationModel? groupInvitationList;
  List<UserModel> usersList = [];
  List<UserModel> taggedUsersList = [];
  EventInvitedList? eventInviteList;
  GroupInvitedList? groupInvitedList;

  ///Forums
  List<int> forumTaggedUserList = [];
  RxList<UserModel> forumTaggedUser = <UserModel>[].obs;
  RxBool isForumUpdate = false.obs;

  RxList<PedigreeSearchData> forumTaggedPedigree = <PedigreeSearchData>[].obs;
  List<PedigreeSearchData> forumTaggedPedigreeList = [];
  List<int> forumPedigreeList = [];

  Posts? postsData;
  Posts? followingPostsData;
  Posts? eventPostsData;
  Posts? myPostsData;
  Posts? friendPostsData;
  EventsModel? events;
  EventsModel? createdEvents;
  EventsModel? attendingEvents;
  bool postLoader = false;
  bool newsFeedWait = false;
  RxList<UserModel> taggedUser = <UserModel>[].obs;
  RxList<PedigreeSearchData> taggedPedigree = <PedigreeSearchData>[].obs;
  Rx<SearchClassUsersList?> searchedUsersList = Rxn<SearchClassUsersList>();
  Rx<UserModel?> friendProfile = Rxn<UserModel>();
  BlockedListModel? blockedList;
  Rx<UserModel?> myProfile = Rxn<UserModel>();

  RxString mentioning = "".obs;
  RxInt eventTabIndex = 0.obs;
  RxString audience = "public".obs;
  TextEditingController forumTitle = TextEditingController();
  TextEditingController forumContent = TextEditingController();
  TextEditingController responseController = TextEditingController();
  TextEditingController commentResponseController = TextEditingController();
  TextEditingController forumDescription = TextEditingController();
  TextEditingController eventName = TextEditingController();
  TextEditingController eventDescription = TextEditingController();
  Rx<TextEditingController> eventDate = TextEditingController().obs;
  Rx<TextEditingController> eventTime = TextEditingController().obs;
  TextEditingController eventLocation = TextEditingController();
  XFile? files;
  NewsFeedPostServices newsFeedPostServices = NewsFeedPostServices();
  List<Permission> permissionsNeeded = [Permission.camera, Permission.storage];

  Function? call;
  dynamic pickImageError;
  @override
  void onInit() {
    getUser();
    getTaggedList();
    getNewsFeed();
    getUsersList();
    getForums();
    getAllGroup();
    getCreatedGroup();
    getJoinedGroups();
    getUnseenMessages();

    super.onInit();
  }

  ///Forum
  getForums() async {
    forumModel = await ForumData().getForums();
    update();
  }

  getTopicDetails(int id, {fromComment = false}) async {
    forumDetailsModel = null;
    forumDetailsModel = await ForumData().getTopicDetails(id);
    if (fromComment == true) {
      model = forumDetailsModel!.data;
    }
    update();
  }

  getAllTopic(int id) async {
    topicModel = null;
    topicModel = await ForumData().getAllTopics(id);
    update();
  }

  getUnseenMessages() async {
    unSeenMessages.value = await ForumData().getUnseenMessages();
    print(unSeenMessages.value);
  }

  createTopic(int id, {bool isUpdate = false, int? topicId}) async {
    final response = await ForumData().createTopic(
        id: id,
        title: forumTitle.text,
        content: forumContent.text,
        media: files == null
            ? null
            : form.MultipartFile.fromFileSync(files!.path,
                filename: "Image.${files!.path.split(".").last}",
                contentType: MediaType("image", files!.path.split(".").last)),
        isUpdate: isUpdate,
        topicId: topicId);
    if (response.statusCode == 200) {
      forumTitle.clear();
      forumContent.clear();
      files = null;
      forumDescription.clear();
      Get.back();
      if (isUpdate == false) {
        getAllTopic(id);
      } else {
        getAllTopic(topicId!);
      }
      getForums();
    }
  }

  deleteTopic(int id, int topicId) async {
    final response = await ForumData().deleteTopic(
      id: id,
    );
    if (response.statusCode == 200) {
      getAllTopic(topicId);
      getForums();
    }
  }

  deleteResponse(int id, topicId) async {
    final response = await ForumData().deleteResponse(id: id);
    if (response.statusCode == 200) {
      getTopicDetails(topicId);
      getForums();
    }
  }

  deleteAccount() async {
    final response = await newsFeedPostServices.deleteAccount();
    if (response.statusCode == 200) {
      Api.singleton.sp.erase();
      BotToast.showText(text: "Account deleted successfully");
      Get.offAllNamed(Routes.login);
    }
  }

  profileStatus(String status) async {
    final response = await newsFeedPostServices.profileStatus(status:status);
    if (response.statusCode == 200) {
      getUser(isUpdate:true);
    }
  }

  deleteResponseComment(int id, topicId) async {
    final response = await ForumData().deleteResponse(id: id);
    if (response.statusCode == 200) {
      getTopicDetails(topicId);
    }
  }

  createResponse(int id, {int? responseId}) async {
    final response = await ForumData().createResponse(
        topicId: id,
        responseId: responseId,
        content: responseController.text,
        peoples: forumTaggedUserList,
        pedigrees: forumPedigreeList);
    if (response.statusCode == 200) {
      Get.back();
      responseController.clear();
      forumTaggedPedigreeList.clear();
      forumPedigreeList.clear();
      forumTaggedUserList.clear();

      forumTaggedUser.clear();
      getTopicDetails(id);
      // getAllTopic(topicId);
    }
  }

  createComment(int id, int topicId, {int? commentId}) async {
    final response = await ForumData().createComment(
        responseId: id,
        content: commentResponseController.text,
        commentId: commentId);
    if (response.statusCode == 200) {
      Get.back();
      getTopicDetails(topicId, fromComment: true);
      commentResponseController.clear();
    }
  }

  ///Forum

  getSearchedData({bool isProgressShow = false}) async {
    form.FormData data = form.FormData.fromMap(
      {
        "search_text": searchTextController.text,
        "search_type": searchValue //searchValue,
      },
    );
    final response = await Api.singleton
        .post(data, 'search', isProgressShow: isProgressShow);
    if (response.statusCode == 200) {
      searchedUsersList.value = SearchClassUsersList.fromJson(
          response.data["data"],
          searchValue: searchValue);
      update();
    }
  }

  responseLike(int id, String reaction, index, int topicId) async {
    form.FormData data = form.FormData.fromMap(
      {
        "response_id": id,
        "reaction": reaction //searchValue,
      },
    );
    final response = await Api.singleton.post(data, 'response/like');
    if (response.statusCode == 200) {
      forumDetailsModel!.data!.responses![index].isLike!.value =
          response.data["data"]["is_like"];
      forumDetailsModel!.data!.responses![index].totalLikes!.value =
          response.data["data"]["likes_count"];
      if (forumModel != null) {
        getAllTopic(topicId);
      }
      update();
    }
  }

  getUsersList() async {
    List<UserModel> users = await newsFeedPostServices.getAllUsers();
    for (var element in users) {
      if (element.profile != null) {
        usersList.add(element);
      }
    }
    mentionList.addAll(usersList.map((u) => Mention(
        id: u.id.toString(),
        imageURL: u.profile!.profileImage!,
        subtitle: '',
        title: u.profile?.fullname ?? "")));
  }

  getUserProfile(id) async {
    friendProfile.value = await newsFeedPostServices.getUserProfile(id);
    update();
  }

  getBlockedList() async {
    blockedList = await newsFeedPostServices.getBlockedList();
    update();
  }

  blockUnblockUser({
    required String userId,
    required String status,
  })async{
    final response = await newsFeedPostServices.blockUnblockUser(userId:userId,status:status);
    if(response.statusCode == 200){
      if(status == "block"){
        Get.back();
        friendProfile = Rxn<UserModel>();

      }else{
        getBlockedList();
      }
      BotToast.showText(text: "User has been ${status == 'block'?'blocked':'unblocked'}");
    }
  }

  Future<UserModel> getAnyUserProfile(id,{fromChat = false}) async {
    final user = await newsFeedPostServices.getUserProfile(id,fromChat:fromChat);
    return user;
  }

  getUser({bool isUpdate = false}) async {
    final response = await Api.singleton.get(
      'profile',
    );
    if (response.statusCode == 200) {
      UserModel user = UserModel.fromJson(response.data["data"]);

      myProfile.value = user;
      SingletonUser.singletonClass.setUser(user);
      Api.singleton.sp.write("user", json.encode(user.toJson()));
      if(isUpdate == true){
        update();
      }
    }
  }

  addMedia(String? type, File file, {thumb}) {
    if (type == "video") {
      fileList.add(multiPartingVideo(file, type: type));
    } else if (type == "audio") {
      fileList.add(multiPartingAudioNoObx(file, type: type));
    } else {
      fileList.add(multiPartingImageNoObx(file, type: type));
    }
  }

  Future<XFile?> testCompressAndGetFile(File file) async {
    final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        "${(await getTemporaryDirectory()).path}image${DateTime.now().microsecondsSinceEpoch}.${file.path.split(".").last}",
        quality: 88,
        minHeight: 720,
        minWidth: 1080);
    return result;
  }

  createPost(
      {String type = "feed",
      int? postID,
      bool isUpdate = false,
      List<String> deleteMediaId = const [],
      FeelingClass? feelingClass,
      GroupData? groupData}) async {
    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].id == null) {
        addMedia(tempList[i].mediaType, File(tempList[i].media!),
            thumb: tempList[i].thumbnail);
      }
    }
    if (deleteMediaId.isNotEmpty) {
      newsFeedPostServices.removeMedia(id: deleteMediaId, postId: postID);
    }
    print(taggedPedigreeList);
    final response = await newsFeedPostServices.postNewPost(
        postId: postID,
        isUpdate: isUpdate,
        pedigreeTags: taggedPedigreeList,
        post: postTextController.text,
        location:
            postLocation.value != null ? postLocation.value!.address! : "",
        latitude: postLocation.value != null
            ? postLocation.value!.latitude.toString()
            : "",
        longitude: postLocation.value != null
            ? postLocation.value!.longitude.toString()
            : "",
        fileList: fileList,
        backgroundColor: backgroundColor.value,
        activityType: feelingClass != null ? feelingClass.type! : "",
        type: groupData != null ? "group" : type,
        activity: feelingClass != null ? feelingClass.name! : "",
        tags: taggedUserList,
        audience: audience.value,
        groupID: groupData?.id);
    Get.back();
    getNewsFeed();
    if (groupData != null) {
      if (currentGroupId == groupData.id) {
        getGroupPosts(groupData.id);
      }
    }
    tempList.clear();
    postTextController.clear();
    fileList.clear();
    deletedFileIds.clear();
    mentionedUsersIds.clear();
    taggedUser.clear();
    taggedUserList.clear();
    taggedPedigreeList.clear();
    audience.value = "public";
    postLocation = Rxn<PostLocation>();
    backgroundColor.value = DynamicColors.primaryColorLight.value;
    print(response);
  }

  void deletePost({
    int? postId,
  }) async {
    final response = await newsFeedPostServices.deletePost(postId: postId);
    if (response.statusCode == 200) {
      BotToast.showText(text: "Post has been deleted");
      getNewsFeed();
      Get.back();
    }
  }

  void reportPost({
    int? commentPostId,
    int? postId,
    String? responseType,
    String? type,
  }) async {
    final response = await newsFeedPostServices.reportPost(id: postId,responseType:responseType,
        type:type,);
    if (response.statusCode == 200) {
      BotToast.showText(text: "${type.toString().capitalizeFirst} has been reported");
      if(type == "post"){
        getNewsFeed();
        if(commentPostId!=null){
          getGroupPosts(commentPostId);
        }
      }else if(type == "comment" && responseType == "post"){
        getPostComments(postId: commentPostId);
      }else if(type == "response" && responseType == "response"){
        getTopicDetails(commentPostId!);
      }else if(type == "comment" && responseType == "response"){
        getTopicDetails(commentPostId!);
      }else if(type == "topic" ){
        getTopicDetails(postId!);
        getAllTopic(commentPostId!);
      }else if(type == "event" ){
        getAllEvents();
        getSingleEvents(postId!);

      }else if(type == "group" ){
        getAllGroup();
        getGroupDetails(postId!);

      }else if(type == "user" ){
        getUserProfile(postId!);

      }
      if(type != "comment" && responseType != "post"){
        Get.back();
      }
    }
  }

  getNewsFeed({fullUrl, String type = "all"}) async {
    if (type == "all") {
      if (fullUrl == null) {
        postsData = await newsFeedPostServices.getNewsFeed(
            fullUrl: fullUrl, type: type);
      } else {
        Posts posts = await newsFeedPostServices.getNewsFeed(
            fullUrl: fullUrl, type: type);
        postsData!.postModel!.addAll(posts.postModel!);
        postsData!.nextPageUrl = posts.nextPageUrl;
        postsData!.prevPageUrl = posts.prevPageUrl;
      }
      update();
      for (int i = 0; i < postsData!.postModel!.length; i++) {
        for (int j = 0; j < postsData!.postModel![i].media!.length; j++) {
          if (postsData!.postModel![i].media!.isNotEmpty &&
              postsData!.postModel![i].media![j].mediaType == "video") {
            DefaultCacheManager()
                .getSingleFile(postsData!.postModel![i].media![j].media!);
          }
        }
      }
    } else if (type == "following") {
      if (fullUrl == null) {
        followingPostsData = await newsFeedPostServices.getNewsFeed(
            fullUrl: fullUrl, type: type);
      } else {
        Posts posts = await newsFeedPostServices.getNewsFeed(
            fullUrl: fullUrl, type: type);
        followingPostsData!.postModel!.addAll(posts.postModel!);
        followingPostsData!.nextPageUrl = posts.nextPageUrl;
        followingPostsData!.prevPageUrl = posts.prevPageUrl;
      }
      update();
      for (int i = 0; i < followingPostsData!.postModel!.length; i++) {
        for (int j = 0;
            j < followingPostsData!.postModel![i].media!.length;
            j++) {
          if (followingPostsData!.postModel![i].media!.isNotEmpty &&
              followingPostsData!.postModel![i].media![j].mediaType ==
                  "video") {
            DefaultCacheManager().getSingleFile(
                followingPostsData!.postModel![i].media![j].media!);
          }
        }
      }
    } else {
      if (fullUrl == null) {
        eventPostsData = await newsFeedPostServices.getNewsFeed(
            fullUrl: fullUrl, type: type);
      } else {
        Posts posts = await newsFeedPostServices.getNewsFeed(
            fullUrl: fullUrl, type: type);
        eventPostsData!.postModel!.addAll(posts.postModel!);
        eventPostsData!.nextPageUrl = posts.nextPageUrl;
        eventPostsData!.prevPageUrl = posts.prevPageUrl;
      }
      update();
      for (int i = 0; i < eventPostsData!.postModel!.length; i++) {
        for (int j = 0; j < eventPostsData!.postModel![i].media!.length; j++) {
          if (eventPostsData!.postModel![i].media!.isNotEmpty &&
              eventPostsData!.postModel![i].media![j].mediaType == "video") {
            DefaultCacheManager()
                .getSingleFile(eventPostsData!.postModel![i].media![j].media!);
          }
        }
      }
    }
  }

  getUsersFeed(int id, {fullUrl}) async {
    if (id == Api.singleton.sp.read("id")) {
      if (fullUrl == null) {
        myPostsData =
            await newsFeedPostServices.getMyFeed(id, fullUrl: fullUrl);
      } else {
        Posts posts =
            await newsFeedPostServices.getMyFeed(id, fullUrl: fullUrl);
        myPostsData!.postModel!.addAll(posts.postModel!);
        myPostsData!.nextPageUrl = posts.nextPageUrl;
        myPostsData!.prevPageUrl = posts.prevPageUrl;
      }
      update();
      for (int i = 0; i < myPostsData!.postModel!.length; i++) {
        for (int j = 0; j < myPostsData!.postModel![i].media!.length; j++) {
          if (myPostsData!.postModel![i].media!.isNotEmpty &&
              myPostsData!.postModel![i].media![j].mediaType == "video") {
            DefaultCacheManager()
                .getSingleFile(myPostsData!.postModel![i].media![j].media!);
          }
        }
      }
    } else {
      if (fullUrl == null) {
        friendPostsData =
            await newsFeedPostServices.getFeed(id, fullUrl: fullUrl);
      } else {
        Posts posts = await newsFeedPostServices.getFeed(id, fullUrl: fullUrl);
        friendPostsData!.postModel!.addAll(posts.postModel!);
        friendPostsData!.nextPageUrl = posts.nextPageUrl;
        friendPostsData!.prevPageUrl = posts.prevPageUrl;
      }
      update();
      for (int i = 0; i < friendPostsData!.postModel!.length; i++) {
        for (int j = 0; j < friendPostsData!.postModel![i].media!.length; j++) {
          if (friendPostsData!.postModel![i].media!.isNotEmpty &&
              friendPostsData!.postModel![i].media![j].mediaType == "video") {
            DefaultCacheManager()
                .getSingleFile(friendPostsData!.postModel![i].media![j].media!);
          }
        }
      }
    }
  }

  getInvitationList() async {
    groupInvitationList = await newsFeedPostServices.getInvitationList();
    update();
  }

  getAllEvents({fullUrl}) async {
    if (fullUrl == null) {
      events = await newsFeedPostServices.getAllEvents(
          fullUrl: fullUrl, url: "events/all");
    } else {
      await newsFeedPostServices.getAllEvents(fullUrl: fullUrl);
    }
    update();
  }

  getSingleEvents(int id) async {
    eventsData = await newsFeedPostServices.getSingleEvents(id);
    update();
  }

  getInviteList(int id) async {
    eventInviteList =
        await newsFeedPostServices.getEventInviteList(eventId: id);
    update();
  }

  getCreated({fullUrl}) async {
    if (fullUrl == null) {
      createdEvents = await newsFeedPostServices.getAllEvents(
          fullUrl: fullUrl, url: "events/created");
    } else {
      await newsFeedPostServices.getAllEvents(fullUrl: fullUrl);
    }
    update();
  }

  getAttending({fullUrl}) async {
    if (fullUrl == null) {
      attendingEvents = await newsFeedPostServices.getAllEvents(
          fullUrl: fullUrl, url: 'events/attending');
    } else {
      await newsFeedPostServices.getAllEvents(fullUrl: fullUrl);
    }
    update();
  }

  onReplyTap(replier) {
    commentField.value = false;
    replierName = replier;
    richTextController.text += "$replier  ";

    richTextController.selection = TextSelection.fromPosition(
        TextPosition(offset: richTextController.text.length));
    commentFocusNode.requestFocus();
    update();
  }

  void interestedOrGoing({
    String eventId = "",
    String status = "",
    bool fromDetails = false,
    String? eventStatus,
    String? type,
    bool fromFeeds = false,
    required int index,
  }) async {
    final response = await newsFeedPostServices.interestedOrGoing(
      eventId: eventId,
      status: eventStatus == null
          ? status
          : eventStatus == "interested" || eventStatus == "going"
              ? "not going"
              : status,
    );
    if (response.statusCode == 200) {
      if (fromFeeds == true) {
        if (type == "all") {
          postsData!.postModel![index].eventsPost!.eventStatus!.value =
              EventsData.fromJson(response.data["data"]).eventStatus!.value;
          postsData!.postModel![index].eventsPost!.eventMembers =
              EventsData.fromJson(response.data["data"]).eventMembers;
          postsData!.postModel![index].eventsPost!.membersGoing =
              EventsData.fromJson(response.data["data"]).membersGoing;
        } else if (type == "following") {
          followingPostsData!.postModel![index].eventsPost!.eventStatus!.value =
              EventsData.fromJson(response.data["data"]).eventStatus!.value;
          followingPostsData!.postModel![index].eventsPost!.eventMembers =
              EventsData.fromJson(response.data["data"]).eventMembers;
          followingPostsData!.postModel![index].eventsPost!.membersGoing =
              EventsData.fromJson(response.data["data"]).membersGoing;
        } else {
          eventPostsData!.postModel![index].eventsPost!.eventStatus!.value =
              EventsData.fromJson(response.data["data"]).eventStatus!.value;
          eventPostsData!.postModel![index].eventsPost!.eventMembers =
              EventsData.fromJson(response.data["data"]).eventMembers;
          eventPostsData!.postModel![index].eventsPost!.membersGoing =
              EventsData.fromJson(response.data["data"]).membersGoing;
        }
      } else {
        if (fromDetails == false) {
          events!.data![index].eventStatus!.value =
              EventsData.fromJson(response.data["data"]).eventStatus!.value;
          events!.data![index].eventMembers =
              EventsData.fromJson(response.data["data"]).eventMembers;
          events!.data![index].membersGoing =
              EventsData.fromJson(response.data["data"]).membersGoing;
        } else {
          eventsData!.eventStatus!.value =
              EventsData.fromJson(response.data["data"]).eventStatus!.value;
          eventsData!.eventMembers =
              EventsData.fromJson(response.data["data"]).eventMembers;
          eventsData!.membersGoing =
              EventsData.fromJson(response.data["data"]).membersGoing;
        }

        getAttending();
      }
      BotToast.showText(text: "Status updated");
      update();
    }
  }

  void commentLikeDislike({
    String commentID = "",
    String reaction = "",
    required int index,
    int? replyIndex,
  }) async {
    final response = await newsFeedPostServices.commentLikeDislike(
      commentID: commentID,
      reaction: reaction,
    );
    if (response.statusCode == 200) {
      if (replyIndex == null) {
        commentModel.value!.results!.data![index].totalLikes!.value =
            CommentData.fromJson(response.data["data"]).totalLikes!.value;
        commentModel.value!.results!.data![index].likes!.value =
            CommentData.fromJson(response.data["data"]).likes!.value;
        commentModel.value!.results!.data![index].isLike!.value =
            CommentData.fromJson(response.data["data"]).isLike!.value;
        update();
      } else {
        commentModel.value!.results!.data![index].reply![replyIndex].totalLikes!
            .value = response.data["data"]["total_likes"];
          commentModel.value!.results!.data![index].reply![replyIndex].likes!
              .value = CommentData.fromJson(response.data["data"]).likes!.value;

        commentModel.value!.results!.data![index].reply![replyIndex].isLike!
            .value = CommentData.fromJson(response.data["data"]).isLike!.value;

      }
    }
  }

  void addComment({
    int? postId,
  }) async {
    form.MultipartFile? fileCommentList;
    if (imageFile != null) {
      fileCommentList = form.MultipartFile.fromFileSync(imageFile!.path,
          filename: "Image.${imageFile!.path.split(".").last}",
          contentType: MediaType("image", imageFile!.path.split(".").last));
    }
    final response = await newsFeedPostServices.addComment(
        postID: postId.toString(),
        userIDs: mentionedCommentUsersIds,
        comment: richTextController.text,
        media: fileCommentList,
        parentCommentId: parentCommentID);
    if (response.statusCode == 200) {
      getPostComments(postId: postId);
      parentCommentID = null;
      richTextController.clear();
      imageFile = null;
      fieldUpdate(false);
      FocusManager.instance.primaryFocus?.unfocus();
      if (postsData != null) {
        int index =
            postsData!.postModel!.indexWhere((element) => element.id == postId);
        if (index != -1) {
          postsData!.postModel![index].commentsCount!.value =
              postsData!.postModel![index].commentsCount!.value + 1;
        }
      }
    } else {
      // deletedPostDelete(response, postId.toString());
    }
    update();
  }

  bool commentDelete = false;
  void updateComment(int postId) async {
    if (commentDelete == true) {
      final check = await deleteMediaComment();
      print(check);
    }
    form.MultipartFile? fileCommentList;
    if (imageFile != null) {
      fileCommentList = form.MultipartFile.fromFileSync(imageFile!.path,
          filename: "Image.${imageFile!.path.split(".").last}",
          contentType: MediaType("image", imageFile!.path.split(".").last));
    }
    final response = await newsFeedPostServices.updateComment(
      commentId: commentId,
      comment: richTextController.text,
      media: fileCommentList,
    );
    if (response.statusCode == 200) {
      commentDelete = false;

      getPostComments(postId: postId);
      BotToast.showText(text: "Comment Updated Successfully");
      commentClear();
      commentNetworkImage.value = "";
      fieldUpdate(true);
      fieldUpdate(false);
    }
  }

  Future<form.Response> deleteMediaComment({id}) async {
    return await newsFeedPostServices.deleteMediaComment(
      commentId: id ?? commentId,
    );
  }

  void deleteComment(int postId) async {
    Get.back();
    final response = await newsFeedPostServices.deleteComment(
      commentId: commentId,
    );
    if (response.statusCode == 200) {
      getPostComments(postId: postId);
      commentUpdate.value = !commentUpdate.value;
      commentClear();
      BotToast.showText(text: "Comment deleted");

      int postIndex =
          postsData!.postModel!.indexWhere((element) => element.id == postId);
      postsData!.postModel![postIndex].commentsCount!.value =
          postsData!.postModel![postIndex].commentsCount!.value - 1;
      update();
    }
  }

  commentClear() {
    parentCommentID = null;
    commentId = null;
    commentIndex = null;
    commentReplyIndex = null;
    richTextController.clear();
    commentModel = Rxn<CommentModel>();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void sharePost(
      {String type = "feed",
      int? parentID,
      int? groupId,
      bool isUpdate = false,
      int? postId}) async {
    final response = await newsFeedPostServices.sharePost(
        parentId: parentID,
        audience: audience.value,
        userIDs: mentionedUsersIds,
        postId: postId,
        groupID: groupId,
        isUpdate: isUpdate,
        type: type,
        postText: postTextController.text);
    if (response.statusCode == 200) {
      postTextController.clear();
      fileList.clear();
      media.clear();
      tempList.clear();
      getNewsFeed();

      Get.back();
    } else {
      // deletedPostDelete(response, postId.toString());
    }
  }

  void likeDislike({
    String postID = "",
    String reaction = "",
    String? deeds = "",
    int? i,
    bool fromDetails = false,
    bool fromGallery = false,
    bool fromSave = false,
    bool fromTimeline = false,
    bool fromFriendTimeline = false,
    bool fromGroup = false,
  }) async {
    final response = await newsFeedPostServices.likeDislike(
      postID: postID,
      reaction: reaction,
    );
    if (response.statusCode == 200) {
      if (fromTimeline == true) {
        int index = myProfile.value!.posts!
            .indexWhere((element) => element.id.toString() == postID);
        if (index != -1) {
          myProfile.value!.posts![index].post!.totalLikes!.value =
              PostModel.fromJson(response.data["data"]).totalLikes!.value;
          myProfile.value!.posts![index].post!.isLike!.value =
              PostModel.fromJson(response.data["data"]).isLike!.value;
        }
      } else if (fromFriendTimeline == true) {
        int index = friendProfile.value!.posts!
            .indexWhere((element) => element.id.toString() == postID);
        if (index != -1) {
          friendProfile.value!.posts![index].post!.totalLikes!.value =
              PostModel.fromJson(response.data["data"]).totalLikes!.value;
          friendProfile.value!.posts![index].post!.isLike!.value =
              PostModel.fromJson(response.data["data"]).isLike!.value;
        }
      } else if (fromDetails == true) {
        postModelData!.totalLikes!.value =
            PostModel.fromJson(response.data["data"]).totalLikes!.value;
        postModelData!.isLike!.value =
            PostModel.fromJson(response.data["data"]).isLike!.value;
        update();
      } else {
        int index = postsData!.postModel!
            .indexWhere((element) => element.id.toString() == postID);
        postsData!.postModel![index].totalLikes!.value =
            PostModel.fromJson(response.data["data"]).totalLikes!.value;
        postsData!.postModel![index].isLike!.value =
            PostModel.fromJson(response.data["data"]).isLike!.value;
      }
    } else {
      // deletedPostDelete(response, postID.toString());
    }
  }

  getPostComments({
    int? postId,
    String? fullUrl,
  }) async {
    final comment =
        await newsFeedPostServices.getPostComments(postId!, fullUrl: fullUrl);
    commentModel.value = comment;
    update();
  }

  invitePeople({
    required int eventId,
    required List<int> members,
  }) async {
    final response = await newsFeedPostServices.invitePeople(
        eventId: eventId, members: members);
    if (response.statusCode == 200) {
      getInviteList(eventId);
      BotToast.showText(text: "Invited Successfully");
      isInviteAll.value = false;
      Get.back();
    }
  }

  void deleteEvent(int id) async {
    final response = await newsFeedPostServices.deleteEvent(
      id: id,
    );
    if (response.statusCode == 200) {
      getAllEvents();
      getCreated();
    }
  }

  void sendFollowRequest(int id) async {
    final response = await newsFeedPostServices.sendFollowRequest(
      id: id,
    );
    if (response.statusCode == 200) {
      getUserProfile(id);
      getFollowing();
      getFollowers();
      getUser();
    }
  }

  void cancelFollowRequest(int id) async {
    final response = await newsFeedPostServices.cancelFollowRequest(
      id: id,
    );
    if (response.statusCode == 200) {
      getUserProfile(id);
      getUser();
    }
  }

  void removeFollower(int id) async {
    final response = await newsFeedPostServices.removeFollower(
      id: id,
    );
    if (response.statusCode == 200) {
      getFollowers(id: id);
      getUserProfile(id);
      getUser();
    }
  }

  void removeFollowing(int id, {bool myFollowers = false}) async {
    final response = await newsFeedPostServices.removeFollowing(
      id: id,
    );
    if (response.statusCode == 200) {
      getFollowing(id: myFollowers == true ? null : id);
      getFollowers(id: myFollowers == true ? null : id);
      getUserProfile(id);
      getUser();
    }
  }

  void acceptOrRejectRequest(int id,String status) async {
    final response = await newsFeedPostServices.acceptOrRejectRequest(
        id: id, status: status);
    if (response.statusCode == 200) {
      getFollowRequests();
      BotToast.showText(text:"Request has been ${status}");
    }
  }

  void groupAcceptOrRejectRequest(int id, String status) async {
    final response = await newsFeedPostServices.groupAcceptOrRejectRequest(
        groupId: id, status: status);
    if (response.statusCode == 200) {
      if (status != "join") {
        getInvitationList();
        getJoinedGroups();
        getAllGroup();
      } else {
        getGroupDetails(id);
        getJoinedGroups();
        getAllGroup();
      }
    }
  }

  void getFollowing({int? id}) async {
    if (id == null || id == Api.singleton.sp.read("id")) {
      followings =
          await newsFeedPostServices.getFollowing(Api.singleton.sp.read("id"));
    } else {
      friendFollowings = await newsFeedPostServices.getFollowing(id);
    }
    update();
  }

  void getTaggedList() async {
    taggedUserModel = await newsFeedPostServices.getTaggedList();

    update();
  }

  void getFollowers({int? id}) async {
    if (id == null || id == Api.singleton.sp.read("id")) {
      followers =
          await newsFeedPostServices.getFollowers(Api.singleton.sp.read("id"));
      print(followers);
      // final follow =
      //     await newsFeedPostServices.getFollowers(Api.singleton.sp.read("id"));
      // followers!.data!.addAll(follow.data!);
    } else {
      friendFollowers = await newsFeedPostServices.getFollowers(id);
    }
    Future.delayed(Duration(milliseconds: 300), () {
      update();
    });
  }

  void getFollowRequests({int? id}) async {
    requestModel = await newsFeedPostServices.getFollowRequests();
    update();
  }

  ///Event
  void createEvent({int? id}) async {
    final response = await newsFeedPostServices.createEvent(
      id: id,
      eventCover: files == null
          ? null
          : form.MultipartFile.fromFileSync(files!.path,
              filename: "Image.${files!.path.split(".").last}",
              contentType: MediaType("image", files!.path.split(".").last)),
      description: eventDescription.text,
      eventName: eventName.text,
      location: eventLocation.text,
      latitude: eventLatitude,
      members: eventSelectList.isEmpty
          ? []
          : eventSelectList.map((e) => e.id!).toList(),
      longitude: eventLongitude,
      eventTime: eventTime.value.text,
      eventDate: eventDate.value.text,
    );
    if (response.statusCode == 200) {
      BotToast.showText(
          text: "Event has been ${id == null ? 'created' : 'updated'}");
      Get.back();
      if (id != null) {
        getAllEvents();
        getSingleEvents(id);
      }
      getCreated();
      getNewsFeed(type: "all");
      getNewsFeed(type: "following");
      getNewsFeed(type: "event");

      eventDescription.clear();
      eventName.clear();
      eventLocation.clear();
      eventLatitude = null;
      eventLongitude = null;
      files = null;
      eventDate.value.clear();
      eventTime.value.clear();
    }
  }

  ///Group
  void createGroup({int? id, bool isUpdate = false}) async {
    final response = await newsFeedPostServices.createGroup(
        id: id,
        groupName: groupName.text,
        groupCover: files == null
            ? null
            : form.MultipartFile.fromFileSync(files!.path,
                filename: "Image.${files!.path.split(".").last}",
                contentType: MediaType("image", files!.path.split(".").last)),
        description: groupDescription.text,
        members: groupSelectList,
        terms: groupTerms,
        type: groupType.value,
        charges: charges.text);
    if (response.statusCode == 200) {
      files = null;
      groupName.clear();
      groupDescription.clear();
      groupSelectList.clear();
      charges.clear();
      groupSelectList.clear();
      groupType.value = "Subscription Group";

      BotToast.showText(
          text: "Group has been ${id == null ? 'created' : 'updated'}");
      Get.back();
      Get.back();
      if (id != null) {
        getGroupDetails(id);
        getGroupPosts(id);
      }
      getAllGroup();
      getCreatedGroup();
      getJoinedGroups();
    }
  }

  getAllGroup({fullUrl}) async {
    allGroups = await newsFeedPostServices.getAllGroup(fullUrl: fullUrl);
    update();
  }

  Future<GroupJoinedModel?> getJoinedGroups({fullUrl}) async {
    joinedGroups = await newsFeedPostServices.getJoinedGroups(fullUrl: fullUrl);
    update();
    return joinedGroups;
  }

  getCreatedGroup({fullUrl}) async {
    createdGroups =
        await newsFeedPostServices.getCreatedGroup(fullUrl: fullUrl);
    update();
  }

  getGroupDetails(id) async {
    groupData = await newsFeedPostServices.getGroupDetails(id);
    update();
  }

  getGroupPosts(id) async {
    groupPosts = await newsFeedPostServices.getGroupPosts(id);
    update();
  }

  getGroupInviteList(id) async {
    groupInvitedList = await newsFeedPostServices.getGroupInviteList(id);
    update();
  }

  inviteToGroup(id, List<int> members) async {
    final response = await newsFeedPostServices.inviteUsersGroup(
        groupID: id, members: members);
    if (response.statusCode == 200) {
      BotToast.showText(text: "Invited Successfully");
      Get.back();
    }
  }

  leaveGroup(id) async {
    final response = await newsFeedPostServices.leaveGroup(
      groupID: id,
    );
    if (response.statusCode == 200) {
      BotToast.showText(text: "Left Group Successfully");
      Get.offNamedUntil(
          Routes.dashboard, ModalRoute.withName(Routes.dashboard));
      Get.back();
      getJoinedGroups();
      getAllGroup();
      getCreatedGroup();
    }
  }

  deleteGroup(id) async {
    final response = await newsFeedPostServices.deleteGroup(
      groupID: id,
    );
    if (response.statusCode == 200) {
      BotToast.showText(text: "Group Deleted Successfully");
      Get.offNamedUntil(
          Routes.dashboard, ModalRoute.withName(Routes.dashboard));
      Get.back();
      getJoinedGroups();
      getAllGroup();
      getCreatedGroup();
    }
  }
}
