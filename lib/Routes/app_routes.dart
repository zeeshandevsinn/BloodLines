part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const videoPlayerClass = _Paths.videoPlayerClass;
  static const audioPlayerClass = _Paths.audioPlayerClass;
  static const generalClass = _Paths.generalClass;

  ///Credentials
  static const login = _Paths.login;
  static const signUp = _Paths.signUp;
  static const completeProfile = _Paths.completeProfile;
  static const mapLocation = _Paths.mapLocation;

  ///NewsFeed
  static const dashboard = _Paths.dashboard;
  static const searchClass = _Paths.searchClass;
  static const carouselSliderDetails = _Paths.carouselSliderDetails;
  static const photo = _Paths.photo;
  static const newPost = _Paths.newPost;
  static const timeline = _Paths.timeline;
  static const friendTimeline = _Paths.friendTimeline;
  static const postMapLocation = _Paths.postMapLocation;
  static const imageListView = _Paths.imageListView;
  static const tagFriend = _Paths.tagFriend;
  static const feelingsActivity = _Paths.feelingsActivity;
  static const taggedFriendListScreen = _Paths.taggedFriendListScreen;

  ///Chat
  static const chatScreen = _Paths.chatScreen;
  static const inbox = _Paths.inbox;
  static const chooseFriends = _Paths.chooseFriends;

  ///Event
  static const eventClass = _Paths.eventClass;
  static const allEvents = _Paths.allEvents;
  static const myEvents = _Paths.myEvents;
  static const eventInviteList = _Paths.eventInviteList;
  static const addEvent = _Paths.addEvent;
  static const eventMapLocation = _Paths.eventMapLocation;
  // static const cameraFilters = _Paths.cameraFilters;

  ///Forum
  static const forumDetails = _Paths.forumDetails;
  static const forumRespond = _Paths.forumRespond;
  static const createTopic = _Paths.createTopic;
  static const forumTagPeople = _Paths.forumTagPeople;
  static const forumTagPedigree = _Paths.forumTagPedigree;
  static const taggedView = _Paths.taggedView;

  ///Shop
  static const followers = _Paths.followers;
  static const friendFollowers = _Paths.friendFollowers;
  static const productDetail = _Paths.productDetail;
  static const notificationClass = _Paths.notificationClass;

  ///Group
  static const groupDetails = _Paths.groupDetails;
  static const addGroup = _Paths.addGroup;
  static const selectGroupType = _Paths.selectGroupType;
  static const membersClass = _Paths.membersClass;

  ///Pedigree
  static const pedigreeTree = _Paths.pedigreeTree;
  static const addSireOrDam = _Paths.addSireOrDam;
  static const pedigreeSearch = _Paths.pedigreeSearch;
  static const addNewPedigree = _Paths.addNewPedigree;
  static const tagPostPedigree = _Paths.tagPostPedigree;

  ///Classified
  static const newClassifiedAd = _Paths.newClassifiedAd;
  static const classifiedMapLocation = _Paths.classifiedMapLocation;
  static const myClassified = _Paths.myClassified;

  ///Account
  static const account = _Paths.account;

  ///Shop
  static const paymentMethod = _Paths.paymentMethod;
  static const cardList = _Paths.cardList;
  static const shopGrid = _Paths.shopGrid;
  static const shopDetail = _Paths.shopDetail;
  static const cartPage = _Paths.cartPage;
  static const addAddress = _Paths.addAddress;
  static const addressList = _Paths.addressList;
  static const orderHistory = _Paths.orderHistory;
  static const blockedList = _Paths.blockedList;
  static const addressMapLocation = _Paths.addressMapLocation;
  static const orderDetailView = _Paths.orderDetailView;
  static const orderConfirmation = _Paths.orderConfirmation;
}

abstract class _Paths {
  static const videoPlayerClass = '/videoPlayerClass';
  static const audioPlayerClass = '/audioPlayerClass';
  static const generalClass = '/generalClass';
  ///Credentials

  static const login = '/login';
  static const signUp = '/signUp';
  static const completeProfile = '/completeProfile';
  static const mapLocation = '/mapLocation';

  ///Dashboard
  static const dashboard = '/dashboard';
  static const searchClass = '/searchClass';
  static const timeline = '/timeline';
  static const carouselSliderDetails = '/carouselSliderDetails';

  static const friendTimeline = '/friendTimeline';
  static const photo = '/photo';
  static const newPost = '/newPost';
  static const postMapLocation = '/postMapLocation';
  static const imageListView = '/imageListView';
  static const tagFriend = '/tagFriend';
  static const feelingsActivity = '/feelingsActivity';
  static const taggedFriendListScreen = '/taggedFriendListScreen';

  ///Event
  static const eventClass = '/eventClass';
  static const myEvents = '/myEvent';
  static const eventInviteList = '/eventInviteList';
  static const allEvents = '/allEvents';
  static const addEvent = '/addEvent';
  static const eventMapLocation = '/eventMapLocation';

  // static const cameraFilters = '/cameraFilters';

  ///Forum
  static const forumDetails = '/forumDetails';
  static const forumRespond = '/forumRespond';
  static const createTopic = '/createTopic';
  static const forumTagPeople = '/forumTagPeople';
  static const forumTagPedigree = '/forumTagPedigree';
  static const taggedView = '/taggedView';

  ///Shop
  static const followers = '/followers';
  static const friendFollowers = '/friendFollowers';
  static const productDetail = '/productDetail';
  static const notificationClass = '/notificationClass';

  ///Group
  static const groupDetails = '/groupDetails';
  static const addGroup = '/addGroup';
  static const selectGroupType = '/selectGroupType';
  static const membersClass = '/membersClass';

  ///Chat
  static const chatScreen = '/chatScreen';
  static const inbox = '/inbox';
  static const chooseFriends = '/chooseFriends';

  ///Pedigree
  static const pedigreeTree = '/pedigreeTree';
  static const addSireOrDam = '/addSireOrDam';
  static const pedigreeSearch = '/pedigreeSearch';
  static const addNewPedigree = '/addNewPedigree';
  static const tagPostPedigree = '/tagPostPedigree';

  ///Classified
  static const newClassifiedAd = '/newClassifiedAd';
  static const classifiedMapLocation = '/classifiedMapLocation';
  static const myClassified = '/myClassified';

  ///Account
  static const account = '/account';

  ///Shop
  static const paymentMethod = '/paymentMethod';
  static const cardList = '/cardList';
  static const shopGrid = '/shopGrid';
  static const shopDetail = '/shopDetail';
  static const cartPage = '/cartPage';
  static const addAddress = '/addAddress';
  static const addressList = '/addressList';
  static const orderHistory = '/orderHistory';
  static const blockedList = '/blockedList';
  static const addressMapLocation = '/addressMapLocation';
  static const orderDetailView = '/orderDetailView';
  static const orderConfirmation = '/orderConfirmation';
}
