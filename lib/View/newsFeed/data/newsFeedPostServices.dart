import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/View/Groups/Model/groupModel.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:bloodlines/View/Timeline/Model/followModel.dart';
import 'package:bloodlines/View/model/blockedListModel.dart';
import 'package:bloodlines/View/newsFeed/model/commentModel.dart';
import 'package:bloodlines/View/newsFeed/model/eventInvitedList.dart';
import 'package:bloodlines/View/newsFeed/model/eventsModel.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/userModel.dart';
import 'package:dio/dio.dart';

class NewsFeedPostServices {
  Future<Response> postNewPost({
    List<int> tags = const [],
    List<int> pedigreeTags = const [],
    String location = "",
    String latitude = "",
    String longitude = "",
    String audience = "",
    String type = "",
    String activity = "",
    String activityType = "",
    String post = "",
    List<String> userIDs = const [],
    bool isUpdate = false,
    int backgroundColor = 0,
    int? postId,
    bool video = false,
    int? userId,
    int? groupID,
    List<MultipartFile> fileList = const [],
    List<MultipartFile> audioList = const [],
  }) async {
    Map<String, dynamic> map = {
      "background_color":
          backgroundColor == DynamicColors.primaryColorLight.value
              ? 0
              : backgroundColor,
      "content": post,
      "audience": audience,
      "type": type,
      // if (isUpdate == true) "post_id": postId,
    };

    if (fileList.isNotEmpty) {
      map["media[]"] = fileList;
    }
    if (tags.isNotEmpty) {
      map["people[]"] = tags;
    }
    if (pedigreeTags.isNotEmpty) {
      map["pedigree[]"] = pedigreeTags;
    }
    if (activity.isNotEmpty) {
      map["post_activity"] = activity.toLowerCase();
      map["post_activity_type"] = activityType.toLowerCase();
    } else {
      if (postId != null) {
        map["post_activity"] = null;
        map["post_activity_type"] = null;
      }
    }

    if (groupID != null) {
      map["group_id"] = groupID;
      // map["user_id"] = userId;
    }
    if (location.isNotEmpty) {
      map["location"] = location;
      map["latitude"] = latitude;
      map["longitude"] = longitude;
    } else {
      if (postId != null) {
        map["location"] = null;
        map["latitude"] = null;
        map["longitude"] = null;
      }
    }

    // if (tags.isNotEmpty) {
    //   if (tags.length == 1) {
    //     map["tag_friend[]"] = tags;
    //   } else {
    //     map["tag_friend"] = tags;
    //   }
    // }
    FormData formData = FormData.fromMap(map);
    // formData.files.add(value)
    print(formData);

    Response response = await Api.singleton.post(
        formData, isUpdate == false ? 'post/create' : 'post/edit?id=$postId',
        multiPart: true);
    return response;
  }

  Future<Response> invitePeople({
    int? eventId,
    List<int> members = const [],
  }) async {
    var map = {
      "event_id": eventId,
      "member[]": members,
    };

    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'event/invite-people', isProgressShow: false);
    return response;
  }

  Future<Response> deletePost({
    int? postId,
  }) async {
    var map = {
      "post_id": postId,
    };

    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'post/delete', isProgressShow: false);
    return response;
  }

  Future<Response> deleteAccount({
    int? postId,
  }) async {
    Response response = await Api.singleton
        .post({}, 'account-delete', isProgressShow: false);
    return response;
  }


  Future<Response> profileStatus({
    String? status,
  }) async {
    Response response = await Api.singleton
        .post({"status":status}, 'profile-status', isProgressShow: false);
    return response;
  }


  Future<Response> reportPost({
    int? id,
    String? responseType,
    String? type,
  }) async {
    var map = {
      "id": id,
     if(responseType != null) "comment_of": responseType,
      "type": type,
    };

    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'report', isProgressShow: false);
    return response;
  }

  Future<Response> removeMedia({List<String>? id, int? postId}) async {
    var map = {
      "media_id[]": id,
    };

    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'post/media/remove?id=$postId', isProgressShow: false);
    return response;
  }

  Future<Response> likeDislike({
    String postID = "",
    String reaction = "",
  }) async {
    var map = {
      "post_id": postID,
      "reaction": reaction,
    };

    FormData formData = FormData.fromMap(map);

    Response response =
        await Api.singleton.post(formData, 'post/like', isProgressShow: true);
    return response;
  }

  Future<Response> blockUnblockUser({
   required String userId,
   required String status,
  }) async {
    var map = {
      "user_id": userId,
      "status": status,
    };

    FormData formData = FormData.fromMap(map);

    Response response =
        await Api.singleton.post(formData, 'block-user', isProgressShow: false);
    return response;
  }

  Future<CommentModel> getPostComments(int postId, {fullUrl}) async {
    Response response = await Api.singleton
        .get('post/comments', fullUrl: fullUrl, queryParameters: {
      "id": postId,
    });
    if (response.statusCode == 200) {
      return CommentModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<UserModel> getUserProfile(int id, {fullUrl,fromChat = false}) async {
    Response response = await Api.singleton
        .get('view-profile', fullUrl: fullUrl, queryParameters: {
      "id": id,
     if(fromChat == false) "owner_id": id,
     if(fromChat == false) "interactive_user_id": id,
    });
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }


  Future<BlockedListModel> getBlockedList({fullUrl}) async {
    Response response = await Api.singleton
        .get('block-list', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      return BlockedListModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<PedigreeModel> getPedigrees({url, fullUrl}) async {
    Response response = await Api.singleton.get(
      url ?? 'pedigree-list',
      fullUrl: fullUrl,
    );
    if (response.statusCode == 200) {
      return PedigreeModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<SinglePedigreeModel> getSinglePedigree(int id, {fullUrl}) async {
    Response response = await Api.singleton
        .get('pedigree', fullUrl: fullUrl, queryParameters: {"id": id});
    if (response.statusCode == 200) {
      return SinglePedigreeModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<FollowModel> getFollowing(int id, {fullUrl}) async {
    Response response = await Api.singleton
        .get('following-list', fullUrl: fullUrl, queryParameters: {"id": id});
    if (response.statusCode == 200) {
      return FollowModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<GroupsModel> getAllGroup({fullUrl}) async {
    Response response = await Api.singleton.get('groups/all', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      return GroupsModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<GroupJoinedModel> getJoinedGroups({fullUrl}) async {
    Response response =
        await Api.singleton.get('groups/joined', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      return GroupJoinedModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<GroupsModel> getCreatedGroup({fullUrl}) async {
    Response response =
        await Api.singleton.get('groups/created', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      return GroupsModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<GroupData> getGroupDetails(id) async {
    Response response = await Api.singleton.get(
      'group/$id',
    );
    if (response.statusCode == 200) {
      return GroupData.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<Posts> getGroupPosts(id) async {
    Response response = await Api.singleton.get(
      'group-post/$id',
    );
    if (response.statusCode == 200) {
      return Posts.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<FollowModel> getFollowers(int id, {fullUrl}) async {
    Response response = await Api.singleton
        .get('followers-list', fullUrl: fullUrl, queryParameters: {"id": id});
    if (response.statusCode == 200) {
      return FollowModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<TaggedUserModel> getTaggedList({fullUrl}) async {
    Response response = await Api.singleton.get('user-tag-list');
    if (response.statusCode == 200) {
      return TaggedUserModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<RequestModel> getFollowRequests({fullUrl}) async {
    Response response =
        await Api.singleton.get('follow-request', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      return RequestModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    Response response = await Api.singleton.get('user-list');
    if (response.statusCode == 200) {
      return List<UserModel>.from(
          response.data["data"]!.map((x) => UserModel.fromJson(x)));
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<List<UserModel>> getTaggedUsers() async {
    Response response = await Api.singleton.get('user-tag-list');
    if (response.statusCode == 200) {
      return List<UserModel>.from(
          response.data["data"]!.map((x) => UserModel.fromJson(x)));
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<GroupInvitedList> getGroupInviteList(id) async {
    var map = {
      "group_id": id,
    };

    FormData formData = FormData.fromMap(map);
    Response response = await Api.singleton
        .post(formData, 'group/invite-list', isProgressShow: true);
    if (response.statusCode == 200) {
      return GroupInvitedList.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<EventsModel> getAllEvents({url, fullUrl}) async {
    Response response =
        await Api.singleton.get(url ?? 'events/created', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      return EventsModel.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }


  Future<EventsData> getSingleEvents(int id) async {
    Response response =
        await Api.singleton.get('event/$id',);
    if (response.statusCode == 200) {
      return EventsData.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<Response> commentLikeDislike({
    String commentID = "",
    String reaction = "",
  }) async {
    var map = {
      "comment_id": commentID,
      "reaction": reaction,
    };

    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'comment/like', isProgressShow: true);
    return response;
  }

  Future<Response> addComment({
    String postID = "",
    int? parentCommentId,
    String? comment,
    List<String> userIDs = const [],
    MultipartFile? media,
  }) async {
    var map = {
      "post_id": postID,
      "parent_comment_id": parentCommentId,
      // if (userIDs.isNotEmpty)
      //   if (userIDs.length == 1) "user_ids[]": userIDs else "user_ids": userIDs,
      if (media != null) "media": media,
      if (comment!.isNotEmpty) "comment": comment,
    };

    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'post/comment', isProgressShow: false);
    return response;
  }

  Future<Response> interestedOrGoing({
    String eventId = "",
    String status = "",
  }) async {
    var map = {
      "event_id": eventId,
      "status": status,
    };

    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'event/accept/invitation', isProgressShow: true);
    return response;
  }

  Future<Response> sharePost({
    int? parentId,
    int? groupID,
    int? postId,
    List<String> userIDs = const [],
    String? postText,
    String? type,
    String? audience,
    bool isUpdate = false,
  }) async {
    var map = {
      "parent_post_id": parentId,
      "content": postText,
      "type": type,
      "audience": audience,
      if (isUpdate == true) "post_id": postId,
    };
    if (groupID != null) {
      map["group_id"] = groupID;
      // map["user_id"] = userId;
    }
    if (userIDs.isNotEmpty) {
      if (userIDs.length == 1) {
        map["user_ids[]"] = userIDs;
      } else {
        map["user_ids"] = userIDs;
      }
    }
    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response = await Api.singleton.post(
        formData, isUpdate == false ? 'post/share' : 'posts/update-post',
        multiPart: true);
    return response;
  }

  Future<Response> createPedigree({
    required String ownerName,
    required String beforeName,
    required String dogName,
    required String afterName,
    int? damName,
    int? sireName,
    String? dogSex,
    int? sourceId,
    int? updateId,
    String? source,
    String? dogColor,
    String? dogWeight,
    String? description,
    String? birthday,
    List<MultipartFile>? media,
  }) async {
    var map = {
      "owner_name": ownerName,
      if(beforeName.isNotEmpty)"before_name_title": beforeName,
      "dog_name": dogName,
      if(afterName.isNotEmpty)"after_name_title": afterName,
      "sex": dogSex,
      if(updateId != null)"id":updateId,
      "dob": birthday,
      "color": dogColor,
      "weight": dogWeight,
      "brief": description,
      "dam_id": damName,
      "sire_id": sireName,
      "photos[]": media,
      if (sourceId != null && sourceId != 0) "source_id": sourceId,
      if (source != null && sourceId != 0) "source": source,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData,updateId != null?'pedigree/update': 'pedigree/create', isProgressShow: false);
    return response;
  }

  Future<Response> updateComment({
    int? commentId,
    String? comment,
    MultipartFile? media,
  }) async {
    var map = {
      "comment_id": commentId,
      if (media != null) "media": media,
      "comment": comment,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'post/comment/edit', isProgressShow: false);
    return response;
  }

  Future<Response> deleteMediaComment({
    int? commentId,
  }) async {
    var map = {
      "comment_id": commentId,
      "type": "post",
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'comment/media/remove', isProgressShow: true);
    print(response);
    return response;
  }

  Future<Response> deletePedigreeImages({
    List<String>? pedigreeList,
    required int id,
  }) async {
    var map = {
      "photo_id[]": pedigreeList,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'pedigree/photo/delete?id=$id', isProgressShow: true);
    print(response);
    return response;
  }


  Future<Response> deletePedigree({
    required int id,
  }) async {
    var map = {
      "id": id,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'pedigree/delete');
    return response;
  }


  Future<Response> deleteClassifiedImages({
    List<String>? classifiedList,
    // required int id,
  }) async {
    var map = {
      "cover_id[]": classifiedList,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'classified/remove/cover', isProgressShow: true);
    print(response);
    return response;
  }

  Future<EventInvitedList> getEventInviteList({
    int? eventId,
  }) async {
    var map = {
      "event_id": eventId,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'event/invite-list', isProgressShow: true);
    return EventInvitedList.fromJson(response.data);
  }

  Future<Posts> getNewsFeed({fullUrl,type = "all"}) async {
    Response response =
        await Api.singleton.get('post/news-feed', fullUrl: fullUrl,queryParameters: {
          "type":type
        });
    if (response.statusCode == 200) {
      return Posts.fromJson(response.data["data"]);
      // return PostModel.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<Posts> getFeed(int id, {fullUrl}) async {
    Response response = await Api.singleton
        .get('view-posts', fullUrl: fullUrl, queryParameters: {"id": id});
    if (response.statusCode == 200) {
      return Posts.fromJson(response.data);
      // return PostModel.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<Posts> getMyFeed(int id, {fullUrl}) async {
    Response response = await Api.singleton.get('my-posts', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      return Posts.fromJson(response.data);
      // return PostModel.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<GroupsInvitationModel> getInvitationList() async {
    Response response = await Api.singleton.get('group/invitations');
    if (response.statusCode == 200) {
      return GroupsInvitationModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<Response> inviteUsersGroup(
      {int? groupID, List<int> members = const []}) async {
    var map = {
      "group_id": groupID,
      if (members.isNotEmpty) "member[]": members,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'group/add-members', isProgressShow: false);
    return response;
  }

  Future<Response> leaveGroup(
      {int? groupID, List<int> members = const []}) async {
    var map = {
      "group_id": groupID,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'leave-group', isProgressShow: false);
    return response;
  }

  Future<Response> deleteGroup(
      {int? groupID, List<int> members = const []}) async {
    var map = {
      "id": groupID,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'group/delete', isProgressShow: false);
    return response;
  }

  Future<Response> deleteComment({
    int? commentId,
  }) async {
    var map = {
      "comment_id": commentId,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'post/comment/delete', isProgressShow: true);
    return response;
  }

  Future<Response> createGroup({
    MultipartFile? groupCover,
    String? groupName,
    int? id,
    List<int> members = const [],
    String? description,
    List<String> terms = const [],
    String? type,
    String charges = "",
  }) async {
    var map = {
      if (groupCover != null) "photo": groupCover,
      "name": groupName,
      // if (id != null) "group_id": id,
      if (members.isNotEmpty) "member[]": members,
      "description": description,
      if (terms.isNotEmpty) "terms": terms,
      if (charges.isNotEmpty) "charges": charges,
      "type": type == "Free Group" ? "free" : "subscription",
    };

    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response = await Api.singleton.post(
        formData, id == null ? 'group/create' : 'group/edit?id=$id',
        multiPart: true);
    return response;
  }

  Future<Response> createEvent({
    MultipartFile? eventCover,
    String? eventName,
    int? id,
    List<int> members = const [],
    String? description,
    String? location,
    String? eventTime,
    String? latitude,
    String? longitude,
    String? eventDate,
  }) async {
    var map = {
      if (eventCover != null) "cover": eventCover,
      "title": eventName,
      if (id != null) "id": id,
      if (members.isNotEmpty) "member[]": members,
      "description": description,
      "location": location,
      "event_time": eventTime,
      "latitude": latitude,
      "longitude": longitude,
      "event_date": eventDate,
    };

    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response = await Api.singleton.post(
        formData, id == null ? 'event/create' : 'event/edit',
        multiPart: true);
    return response;
  }

  Future<Response> deleteEvent({
    int? id,
  }) async {
    var map = {
      "event_id": id,
    };
    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response = await Api.singleton
        .post(formData, 'event/delete', isProgressShow: true);
    return response;
  }

  Future<Response> sendFollowRequest({
    int? id,
  }) async {
    var map = {
      "receiver_id": id,
      "owner_id": id,
    };
    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response = await Api.singleton
        .post(formData, 'send-request', isProgressShow: true);
    return response;
  }

  Future<Response> cancelFollowRequest({
    int? id,
  }) async {
    var map = {
      "receiver_id": id,
    };
    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response = await Api.singleton
        .post(formData, 'cancle-request', isProgressShow: true);
    return response;
  }

  Future<Response> removeFollower({
    int? id,
  }) async {
    var map = {
      "follower_id": id,
    };
    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response = await Api.singleton.post(
      formData,
      'remove/follower',
    );
    return response;
  }

  Future<Response> removeFollowing({
    int? id,
  }) async {
    var map = {
      "following_id": id,
    };
    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response = await Api.singleton.post(
      formData,
      'remove/following',
    );
    return response;
  }

  Future<Response> acceptOrRejectRequest({int? id, String? status}) async {
    var map = {
      "sender_id": id,
      "owner_id": id,
      "status": status,
    };
    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response = await Api.singleton.post(
      formData,
      'accept-or-reject-request',
    );
    return response;
  }

  Future<Response> groupAcceptOrRejectRequest({
    int? groupId,
    String? status,
    String? cardName,
    String? cardNumber,
    String? expireMonth,
    String? expireYear,
    String? cvc,
  }) async {
    var map = {
      "group_id": groupId,
      "status": status,
      "name_on_card": cardName,
      "card_number": cardNumber,
      "exp_month": expireMonth,
      "exp_year": expireYear,
      "cvc": cvc,
    };
    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response = await Api.singleton.post(
      formData,
      'group/accept/invitation',
    );
    return response;
  }
}
