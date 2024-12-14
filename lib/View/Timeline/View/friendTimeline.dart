// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/CustomAlert.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/Chat/controller/chatController.dart';
import 'package:bloodlines/View/Pedigree/View/pedigree.dart';
import 'package:bloodlines/View/Timeline/View/timelineDetails/forumPosts.dart';
import 'package:bloodlines/View/Timeline/View/timelineDetails/photos.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/view/post/postWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class FriendTimeline extends StatefulWidget {
  FriendTimeline({super.key});

  @override
  State<FriendTimeline> createState() => _FriendTimelineState();
}

class _FriendTimelineState extends State<FriendTimeline> {
  RxInt tab = 0.obs;
  int id = Get.arguments["id"];
  bool fromChat = Get.arguments["fromChat"] ?? false;

  FeedController controller = Get.find();
  ChatController chatController = Get.put(ChatController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getUserProfile(id);
    controller.getUsersFeed(id);
    Api.singleton.sp.write("friendId", id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<FeedController>(builder: (logic) {
        if (controller.friendProfile.value == null) {
          return Center(
            child: LoaderClass(),
          );
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Utils.height(context) / 2.5,
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (controller.friendProfile.value!.profileStatus !=
                                "private") {
                              if (controller
                                      .friendProfile.value!.isFriend!.value ==
                                  "following") {
                                Get.toNamed(Routes.photo, arguments: {
                                  "image": controller.friendProfile.value!
                                      .profile!.coverImage!,
                                });
                              }
                            }
                          },
                          child: SizedBox(
                            width: Utils.width(context),
                            height: Utils.height(context) / 4.5,
                            child: OptimizedCacheImage(
                              imageUrl: controller
                                  .friendProfile.value!.profile!.coverImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 30, left: 10),
                            child: AppBarWidgets(
                              margin: 0,
                              decorationColor: Colors.black45,
                              color: DynamicColors.whiteColor,
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child:  Padding(
                              padding: EdgeInsets.only(top: 40, right: 10),
                              child: PopupMenuButton(
                                initialValue: 3,
                                child: Container(
                                  // margin: EdgeInsets.all(0),
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:  Colors.black45,

                                  ),
                                  child:  Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: Icon(
                                      Icons.more_vert,
                                      color: DynamicColors.whiteColor,
                                      size: 21,
                                    ),
                                  ),
                                ),
                                itemBuilder: (context) {
                                  return <PopupMenuEntry>[
                                    PopupMenuItem(

                                      value: 1,
                                      child: Text(
                                        "Block",
                                        style: poppinsRegular(),
                                      ),
                                      onTap: () {
                                        controller.blockUnblockUser(userId: id.toString(), status: "block");
                                      },
                                    ),
                                    PopupMenuDivider(
                                      height: 10,
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: Text(
                                        "Report",
                                        style: poppinsRegular(),
                                      ),
                                      onTap: () {
                                        controller.reportPost(postId: id,type: "user");
                                      },
                                    ),
                                  ];
                                },
                              ),
                            )),
                      ],
                    ),
                    Positioned(
                      top: Utils.height(context) / 4.3,
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.friendProfile.value!.profile!.fullname!
                                  .capitalize!,
                              style: montserratRegular(fontSize: 24),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.friendFollowers = null;
                                    controller.getFollowers(id: id);
                                    controller.getFollowing(id: id);
                                    Get.toNamed(Routes.friendFollowers,
                                            arguments: {"data": true})!
                                        .then((value) =>
                                            controller.getUserProfile(id));
                                  },
                                  child: RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: controller
                                            .friendProfile.value!.followersCount
                                            .toString(),
                                        style: montserratBold(fontSize: 16)),
                                    WidgetSpan(
                                        child: SizedBox(
                                      width: 5,
                                    )),
                                    TextSpan(
                                        text: "Followers",
                                        style: poppinsLight(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w200)),
                                  ])),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.getFollowers(id: id);
                                    controller.getFollowing(id: id);
                                    Get.toNamed(Routes.friendFollowers)!.then(
                                        (value) =>
                                            controller.getUserProfile(id));
                                  },
                                  child: RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: controller
                                            .friendProfile.value!.followingCount
                                            .toString(),
                                        style: montserratBold(fontSize: 16)),
                                    WidgetSpan(
                                        child: SizedBox(
                                      width: 5,
                                    )),
                                    TextSpan(
                                        text: "Following",
                                        style: poppinsLight(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w200)),
                                  ])),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: Utils.height(context) / 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          width: Utils.width(context) / 1.1,
                          child: Text(
                            controller.friendProfile.value!.profile!.about ??
                                "",
                            style: poppinsLight(
                                fontSize: 13, fontWeight: FontWeight.w200),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: Utils.height(context) / 6.5,
                        right: 10,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: GestureDetector(
                                onTap: () {
                                  if (controller
                                          .friendProfile.value!.profileStatus !=
                                      "private") {
                                    if (controller.friendProfile.value!
                                            .isFriend!.value ==
                                        "following") {
                                      Get.toNamed(Routes.photo, arguments: {
                                        "image": controller.friendProfile.value!
                                            .profile!.profileImage!,
                                      });
                                    }
                                  }
                                },
                                child: SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: OptimizedCacheImage(
                                    imageUrl: controller.friendProfile.value!
                                        .profile!.profileImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                              isLong: false,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              borderRadius: BorderRadius.circular(10),
                              borderColor: Colors.transparent,
                              onTap: () {
                                if (controller
                                        .friendProfile.value!.isFriend!.value ==
                                    "following") {
                                  alertCustomMethod(context,
                                      titleText: "Do you want to unfollow?",
                                      buttonText: "Yes",
                                      buttonText2: "No",
                                      theme: DynamicColors.primaryColor,
                                      titleStyle: poppinsRegular(
                                          fontSize: 20,
                                          color: DynamicColors.primaryColor,
                                          fontWeight: FontWeight.w200),
                                      click: () {
                                    Get.back();
                                    controller.removeFollowing(id);
                                  }, click2: () {
                                    Get.back();
                                  });
                                }else if(controller.friendProfile.value!
                                    .isFriend!.value ==
                                    "requested"){
                                  alertCustomMethod(context,
                                      titleText: "Do you want to cancel the request?",
                                      buttonText: "Yes",
                                      buttonText2: "No",
                                      theme: DynamicColors.primaryColor,
                                      titleStyle: poppinsRegular(
                                          fontSize: 20,
                                          color: DynamicColors.primaryColor,
                                          fontWeight: FontWeight.w200),
                                      click: () {
                                        Get.back();
                                        controller.cancelFollowRequest(id);
                                      }, click2: () {
                                        Get.back();
                                      });
                                } else {
                                  controller.sendFollowRequest(id);
                                }
                              },
                              color: DynamicColors.primaryColorRed,
                              child: Obx(() {
                                return Text(
                                  controller.friendProfile.value!.isFriend!
                                              .value ==
                                          "following"
                                      ? "Following"
                                      : controller.friendProfile.value!
                                                  .isFriend!.value ==
                                              "requested"
                                          ? "Requested"
                                          : "Follow",
                                  style: poppinsRegular(
                                      color: DynamicColors.whiteColor,
                                      fontSize: 13),
                                );
                              }),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CustomButton(
                              text: "Chat",
                              onTap: () {
                                if (fromChat == true) {
                                  Get.back();
                                } else {
                                  chatController.chatModel = null;
                                  chatController.inboxId = null;
                                  chatController.userData =
                                      controller.friendProfile.value!;
                                  Get.toNamed(Routes.chatScreen, arguments: {
                                    "id": controller.friendProfile.value!.id,
                                    "user": controller.friendProfile.value!,
                                    "fromTimeline":true
                                  })!
                                      .then(
                                          (value) => chatController.getInbox());
                                }
                              },
                              isLong: false,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              borderRadius: BorderRadius.circular(10),
                              borderColor: Colors.transparent,
                              color: DynamicColors.primaryColorRed,
                              style: poppinsRegular(
                                  fontSize: 13,
                                  color: DynamicColors.primaryColorLight),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              controller.friendProfile.value!.profileStatus == "private" &&
                      controller.friendProfile.value!.isFriend!.value ==
                          "no_following"
                  ? noFriendWidget()
                  : postMethod()
            ],
          ),
        );
      }),
    );
  }

  Column postMethod() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 3,
                child: Obx(() {
                  return CustomTabBarClass(
                    onTap: () {
                      tab.value = 0;
                    },
                    title: "Posts",
                    tabValue: tab.value,
                    value: 0,
                  );
                })),
            Expanded(
                flex: 3,
                child: Obx(() {
                  return CustomTabBarClass(
                    onTap: () {
                      tab.value = 1;
                    },
                    title: "Photos",
                    tabValue: tab.value,
                    value: 1,
                  );
                })),
            Expanded(
                flex: 3,
                child: Obx(() {
                  return CustomTabBarClass(
                    onTap: () {
                      tab.value = 2;
                    },
                    title: "Forum Posts",
                    tabValue: tab.value,
                    value: 2,
                  );
                })),
            Expanded(
                flex: 3,
                child: Obx(() {
                  return CustomTabBarClass(
                    onTap: () {
                      tab.value = 3;
                    },
                    title: "Pedigree",
                    tabValue: tab.value,
                    value: 3,
                  );
                })),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Obx(() {
          return IndexedStack(
            index: tab.value,
            children: [
              controller.friendPostsData == null
                  ? LoaderClass()
                  : ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: controller.friendPostsData!.postModel!.length,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return PostClass(
                          index: index,
                          result: controller.friendPostsData!.postModel![index],
                          fromFriendTimeline: true,
                        );
                      }),
              controller.friendProfile.value!.profileStatus == "private" &&
                  controller.friendProfile.value!.isFriend!.value ==
                      "not_following"
                  ? noFriendWidget()
                  : TimelinePhotos(gallery: controller.friendProfile.value!.gallery!),
              TimelineForum(forumList: controller.friendProfile.value!.forums!),
              DataTableClass(myPedigree: true, fromTimeline: true),
            ],
          );
        })
      ],
    );
  }

  noFriendWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: DynamicColors.primaryColorRed)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child:
                      Icon(Linecons.lock, color: DynamicColors.primaryColorRed),
                )),
            SizedBox(
              height: 20,
            ),
            Text(
              "This Profile is Private",
              style: montserratSemiBold(fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Follow this Profile to View their Photos",
              textAlign: TextAlign.center,
              style: montserratRegular(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  bottomSheet() {
    return Wrap(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          child: Container(
            decoration: BoxDecoration(
              color: DynamicColors.primaryColorLight,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      height: 10,
                      width: 70,
                      decoration: BoxDecoration(
                          color: DynamicColors.primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Block",
                      style: montserratRegular(
                          color: DynamicColors.primaryColorRed),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: DynamicColors.primaryColorRed,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Report",
                      style: montserratRegular(
                          color: DynamicColors.primaryColorRed),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTabBarClass extends StatelessWidget {
  CustomTabBarClass(
      {super.key,
      required this.value,
      required this.tabValue,
      required this.onTap,
      required this.title});

  final int value;
  final int tabValue;
  final String title;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textStyle(value)),
          SizedBox(
            height: 3,
          ),
          tabValue == value
              ? Container(
                  height: 2,
                  width: 20,
                  decoration: BoxDecoration(
                      color: DynamicColors.primaryColorRed,
                      borderRadius: BorderRadius.circular(2)),
                )
              : SizedBox.shrink()
        ],
      )),
    );
  }

  TextStyle textStyle(int index) {
    return poppinsRegular(
        fontSize: 12,
        color: tabValue == index
            ? DynamicColors.primaryColorRed
            : DynamicColors.textColor);
  }
}
