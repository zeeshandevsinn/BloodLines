import 'package:bloodlines/View/Account/Data/accountBindings.dart';
import 'package:bloodlines/View/Account/View/account.dart';
import 'package:bloodlines/View/Chat/controller/chatBindings.dart';
import 'package:bloodlines/View/Chat/view/chatScreen.dart';
import 'package:bloodlines/View/Chat/view/chooseFriends.dart';
import 'package:bloodlines/View/Chat/view/imageList.dart';
import 'package:bloodlines/View/Chat/view/inbox.dart';
import 'package:bloodlines/View/Classified/Data/classifiedBinding.dart';
import 'package:bloodlines/View/Classified/View/classifiedDetails/productDetail.dart';
import 'package:bloodlines/View/Classified/View/classifiedMapLocation.dart';
import 'package:bloodlines/View/Classified/View/myClassified.dart';
import 'package:bloodlines/View/Classified/View/newClassifiedAd.dart';
import 'package:bloodlines/View/Dashboard/search.dart';
import 'package:bloodlines/View/Forum/View/createFeed.dart';
import 'package:bloodlines/View/Forum/View/forumDetails.dart';
import 'package:bloodlines/View/Forum/View/forumRespond.dart';
import 'package:bloodlines/View/Forum/View/forumTags.dart';
import 'package:bloodlines/View/Forum/View/taggedView.dart';
import 'package:bloodlines/View/Groups/View/addGroup.dart';
import 'package:bloodlines/View/Groups/View/groupDetails/groupDetails.dart';
import 'package:bloodlines/View/Groups/View/groupDetails/members.dart';
import 'package:bloodlines/View/Groups/View/selectGroupType.dart';
import 'package:bloodlines/View/Pedigree/View/addSireOrDam.dart';
import 'package:bloodlines/View/Pedigree/View/pedigreeSearch.dart';
import 'package:bloodlines/View/Shop/View/addAddress.dart';
import 'package:bloodlines/View/Shop/View/addressList.dart';
import 'package:bloodlines/View/Shop/View/cardListClass.dart';
import 'package:bloodlines/View/Shop/View/orderDetailView.dart';
import 'package:bloodlines/View/Shop/View/orderHistory.dart';
import 'package:bloodlines/View/blockedList.dart';
import 'package:bloodlines/View/generalClass.dart';
import 'package:bloodlines/View/newsFeed/view/event/view/allEvents.dart';
import 'package:bloodlines/View/newsFeed/view/event/view/eventInviteList.dart';
import 'package:bloodlines/View/newsFeed/view/event/view/eventMapLocation.dart';
import 'package:bloodlines/View/newsFeed/view/event/view/myEvents.dart';
import 'package:bloodlines/View/newsFeed/view/post/carouselSliderDetails.dart';
import 'package:bloodlines/View/newsFeed/view/post/feelingsActivity.dart';
import 'package:bloodlines/View/newsFeed/view/post/newPost.dart';
import 'package:bloodlines/View/newsFeed/view/post/postMapLocation.dart';
import 'package:bloodlines/View/Timeline/View/friendTimeline.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/Pedigree/Data/pedigreeBinding.dart';
import 'package:bloodlines/View/Pedigree/View/addNewPedigree.dart';
import 'package:bloodlines/View/Pedigree/View/pedigreeTree.dart';
import 'package:bloodlines/View/Shop/Data/shopBinding.dart';
import 'package:bloodlines/View/Shop/View/cartPage.dart';
import 'package:bloodlines/View/Shop/View/orderConfirmation.dart';
import 'package:bloodlines/View/Shop/View/paymentMethod.dart';
import 'package:bloodlines/View/Shop/View/shopDetails.dart';
import 'package:bloodlines/View/Shop/View/shopGrid.dart';
import 'package:bloodlines/View/Timeline/View/follow.dart';
import 'package:bloodlines/View/Timeline/View/timeline.dart';
import 'package:bloodlines/View/Dashboard/dashboard.dart';
import 'package:bloodlines/View/newsFeed/view/event/view/addEvents.dart';
import 'package:bloodlines/View/newsFeed/view/event/view/eventClass.dart';
import 'package:bloodlines/View/Dashboard/notifications.dart';
import 'package:bloodlines/View/newsFeed/view/post/tagFriendList.dart';
import 'package:bloodlines/View/newsFeed/view/post/tagPedigreeList.dart';
import 'package:bloodlines/View/newsFeed/view/post/taggedFriendList.dart';
import 'package:bloodlines/audioPlayerClass.dart';
import 'package:bloodlines/photoView.dart';
import 'package:bloodlines/videoPlayerClass.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/mapLocation.dart';
import 'package:bloodlines/Credentials/controller/credentialBinding.dart';
import 'package:bloodlines/Credentials/view/completeProfile.dart';
import 'package:bloodlines/Credentials/view/login.dart';
import 'package:bloodlines/Credentials/view/signup.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(name: _Paths.videoPlayerClass, page: () => VideoPlayerClass()),
    GetPage(name: _Paths.audioPlayerClass, page: () => AudioPlayerClass()),

    ///Credentials
    GetPage(
      name: _Paths.login,
      page: () => Login(),
      binding: CredentialBinding(),
    ),
    GetPage(
      name: _Paths.completeProfile,
      page: () => CompleteProfile(),
      binding: CredentialBinding(),
    ),
    GetPage(
      name: _Paths.mapLocation,
      page: () => MapLocation(),
    ),
    GetPage(
      name: _Paths.blockedList,
      page: () => BlockedList(),
    ),
    GetPage(
      name: _Paths.eventMapLocation,
      page: () => EventMapLocation(),
    ),
    GetPage(
      name: _Paths.generalClass,
      page: () => GeneralClass(),
    ),

    GetPage(
      name: _Paths.signUp,
      page: () => SignUp(),
      binding: CredentialBinding()
    ),

    ///Dashboard

    GetPage(
        name: _Paths.dashboard,
        page: () => Dashboard(),
        bindings: [ FeedBinding(),ShopBinding()]),

    GetPage(name: _Paths.searchClass, page: () => SearchClass(),binding: ClassifiedBinding()),
    // GetPage(name: _Paths.cameraFilters, page: () => CameraFilterClass()),
    GetPage(name: _Paths.photo, page: () => Photo()),
    GetPage(name: _Paths.newPost, page: () => NewPost()),
    GetPage(name: _Paths.followers, page: () => Followers()),
    GetPage(name: _Paths.friendFollowers, page: () => FriendFollowers()),
    GetPage(
        name: _Paths.carouselSliderDetails,
        page: () => CarouselSliderDetails()),
    GetPage(
        name: _Paths.timeline,
        page: () => Timeline()),
    GetPage(
        name: _Paths.friendTimeline,
        page: () => FriendTimeline()),
    GetPage(name: _Paths.postMapLocation, page: () => PostMapLocation()),
    GetPage(name: _Paths.imageListView, page: () => ImageListView()),
    GetPage(name: _Paths.tagFriend, page: () => TagFriend()),
    GetPage(name: _Paths.feelingsActivity, page: () => FeelingsActivity()),
    GetPage(name: _Paths.taggedFriendListScreen, page: () => TaggedFriendListScreen()),

    ///Pedigree
    GetPage(
        name: _Paths.addNewPedigree,
        page: () => AddNewPedigree(),
        binding: PedigreeBinding()),
    GetPage(name: _Paths.pedigreeTree, page: () => PedigreeTree()),
    // GetPage(name: _Paths.addSireOrDam, page: () => AddSireOrDam()),
    GetPage(name: _Paths.pedigreeSearch, page: () => PedigreeSearch()),
    GetPage(name: _Paths.tagPostPedigree, page: () => TagPostPedigree()),

    ///Event
    GetPage(name: _Paths.eventClass, page: () => EventClass()),
    GetPage(name: _Paths.myEvents, page: () => MyEvents()),
    GetPage(name: _Paths.eventInviteList, page: () => EventInviteList()),
    GetPage(name: _Paths.allEvents, page: () => AllEvents()),
    GetPage(name: _Paths.addEvent, page: () => AddEvent()),

    ///Forum
    GetPage(name: _Paths.forumDetails, page: () => ForumDetails()),
    GetPage(name: _Paths.forumRespond, page: () => ForumRespond()),
    GetPage(name: _Paths.createTopic, page: () => CreateTopic()),
    GetPage(name: _Paths.forumTagPeople, page: () => ForumTagPeople()),
    GetPage(name: _Paths.forumTagPedigree, page: () => ForumTagPedigree()),
    GetPage(name: _Paths.taggedView, page: () => TaggedView()),
    ///Shop
    GetPage(name: _Paths.productDetail, page: () => ProductDetail(),binding: ChatBinding()),
    GetPage(name: _Paths.notificationClass, page: () => NotificationClass()),

    ///Group
    GetPage(name: _Paths.groupDetails, page: () => GroupDetails()),
    GetPage(name: _Paths.selectGroupType, page: () => SelectGroupType()),
    GetPage(
        name: _Paths.addGroup, page: () => AddGroup()),
    GetPage(name: _Paths.membersClass, page: () => MembersClass()),

    ///Chat
    GetPage(
        name: _Paths.chatScreen,
        page: () => ChatScreen(),
        binding: ChatBinding()),
    GetPage(name: _Paths.inbox, page: () => Inbox(), binding: ChatBinding()),
    GetPage(name: _Paths.chooseFriends, page: () => ChooseFriends()),

    ///Classified
    GetPage(
        name: _Paths.newClassifiedAd,
        page: () => NewClassifiedAd(),
        binding: ClassifiedBinding()),
    GetPage(
      name: _Paths.classifiedMapLocation,
      page: () => ClassifiedMapLocation(),
    ),
    GetPage(
      name: _Paths.myClassified,
      page: () => MyClassified(),
    ),

    ///Account
    GetPage(
        name: _Paths.account,
        page: () => Account(),
        binding: AccountBindings()),

    ///Shop
    GetPage(
        name: _Paths.paymentMethod,
        page: () => PaymentMethod(),
        binding: ShopBinding()),
    GetPage(name: _Paths.cardList, page: () => CardListClass()),
    GetPage(name: _Paths.shopGrid, page: () => ShopGrid()),
    GetPage(name: _Paths.shopDetail, page: () => ShopDetail()),
    GetPage(name: _Paths.cartPage, page: () => CartPage()),
    GetPage(name: _Paths.addAddress, page: () => AddAddress()),
    GetPage(name: _Paths.addressList, page: () => AddressList(),binding: ShopBinding()),
    GetPage(name: _Paths.orderHistory, page: () => OrderHistory(),binding: ShopBinding()),
    GetPage(name: _Paths.addressMapLocation, page: () => AddressMapLocation()),
    GetPage(name: _Paths.orderDetailView, page: () => OrderDetailView()),
    GetPage(name: _Paths.orderConfirmation, page: () => OrderConfirmation()),

  ];
}
