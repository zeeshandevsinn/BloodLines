// ignore_for_file: must_be_immutable

import 'package:badges/badges.dart' as bg;
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/textField.dart';
import 'package:bloodlines/View/Chat/controller/chatController.dart';
import 'package:bloodlines/View/Classified/View/classified.dart';
import 'package:bloodlines/View/Dashboard/drawerClass.dart';
import 'package:bloodlines/View/Forum/View/forum.dart';
import 'package:bloodlines/View/Groups/View/groups.dart';
import 'package:bloodlines/View/Pedigree/View/pedigree.dart';
import 'package:bloodlines/View/Shop/Data/shopController.dart';
import 'package:bloodlines/View/Shop/View/shop.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/view/feed.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class Dashboard extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FeedController controller = Get.find();
  ShopController shopController = Get.find();
  ChatController chatController = Get.put(ChatController());

  List<String> searchList = [
    "Search feed here",
    "Search pedigree here",
    "Search forums here",
    "Search feeds here",
    "Search classified here",
    "Search product here",
  ];

  @override
  Widget build(BuildContext context) {
    double widths = MediaQuery.of(context).size.width;
    return Container(
      color: DynamicColors.primaryColorLight,
      child: SafeArea(
        child: Scaffold(
          backgroundColor:  DynamicColors.primaryColorLight,
          key: scaffoldKey,
          floatingActionButton: Obx(() {
            if (controller.tabIndex.value == 5) {
              return cartFloating();
            }
            return floatingActionButton();
          }),
          drawer: DrawerClass(
            scaffoldKey: scaffoldKey,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: kToolbarHeight + 10,
                ),
                child: Obx(() {
                  return IndexedStack(
                    index: controller.tabIndex.value,
                    children: [
                      Feed(),
                      Pedigree(),
                      Forum(),
                      Groups(),
                      Classified(),
                      Shop(),
                    ],
                  );
                }),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: DynamicColors.primaryColorLight,
                  height: kToolbarHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              scaffoldKey.currentState!.openDrawer();
                            },
                            child: SizedBox(
                              height: kToolbarHeight - 10,
                              child: ImageIcon(
                                AssetImage(
                                  "assets/icons/menu.png",
                                ),
                                size: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Obx(() {
                            return CustomTextField(
                              filled: true,
                              isUnderLineBorder: false,
                              padding: EdgeInsets.only(left: 10, top: 8),
                              radius: 5,
                              hint: searchList[controller.tabIndex.value],
                              isBorder: true,
                              readOnly: true,
                              onTap: () {
                                Get.toNamed(Routes.searchClass);
                              },
                              // readOnly: true,
                              isTransparentBorder: true,
                              fillColor: Colors.grey[200]!,
                              suffixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                            );
                          }),
                        ),
                        Expanded(
                          flex: 2,
                          child: Obx(() {
                              return bg.Badge(
                                showBadge: controller.unSeenMessages.value,
                                badgeStyle: bg.BadgeStyle(
                                  shape: bg.BadgeShape.circle,
                                  badgeColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                ),
                                badgeContent: Padding(
                                  padding: const EdgeInsets.only(top: 10,right: 10),
                                  child: Container(
                                    width: 10,height: 10,
                                    decoration: BoxDecoration(
                                      color: DynamicColors.primaryColorRed,
                                      shape: BoxShape.circle,
                                      // border: Border.all(color: DynamicColors.primaryColorRed)
                                    ),
                                  ),
                                ),
                                child: AppBarWidgets(
                                  isCardType: false,
                                  height: kToolbarHeight,
                                  width: kToolbarHeight,
                                  margin: 2,
                                  onTap: () {
                                    Get.toNamed(Routes.inbox)!.then((value) => controller.getUnseenMessages());
                                  },
                                  padding: EdgeInsets.all(8),
                                  assetImage: "assets/icons/chat.png",
                                ),
                              );
                            }
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 2,
                          child: AppBarWidgets(
                            isCardType: false,
                            height: kToolbarHeight,
                            onTap: () {
                              controller.getFollowRequests();
                              controller.getInvitationList();
                              Get.toNamed(Routes.notificationClass);
                            },
                            width: kToolbarHeight,
                            size: 20,
                            margin: 2,
                            padding: EdgeInsets.all(8),
                            assetImage: "assets/icons/notification.png",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            color: DynamicColors.primaryColorLight,
            height: kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LikeButton(
                      onTap: (a) async {
                        controller.tabIndex.value = 0;
                        return true;
                      },

                      circleColor: CircleColor(
                          start: DynamicColors.primaryColor,
                          end: DynamicColors.primaryColor.withOpacity(0.5)),
                      bubblesColor: BubblesColor(
                          dotPrimaryColor: DynamicColors.primaryColor,
                          dotSecondaryColor:
                              DynamicColors.primaryColor.withOpacity(0.5)),
                      size: widths / 6.5,
                      likeBuilder: (bool isLiked) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ImageIcon(
                              AssetImage("assets/icons/feed.png"),
                              color: controller.tabIndex.value == 0
                                  ? DynamicColors.primaryColorRed
                                  : Colors.grey,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              "Feeds",
                              style: montserratRegular(
                                fontSize: 11,
                                color: controller.tabIndex.value == 0
                                    ? DynamicColors.primaryColorRed
                                    : Colors.grey,
                              ),
                            )
                          ],
                        );
                      },
                      isLiked: controller.tabIndex.value == 0 ? true : false,
                      // likeCount: likeCount,
                    ),
                    LikeButton(
                      onTap: (a) async {
                        controller.tabIndex.value = 1;
                        return true;
                      },
                      size: widths / 6.5,
                      circleColor: CircleColor(
                          start: DynamicColors.primaryColor,
                          end: DynamicColors.primaryColor.withOpacity(0.5)),
                      bubblesColor: BubblesColor(
                          dotPrimaryColor: DynamicColors.primaryColor,
                          dotSecondaryColor:
                              DynamicColors.primaryColor.withOpacity(0.5)),
                      likeBuilder: (bool isLiked) {
                        return Column(
                          children: [
                            ImageIcon(
                              AssetImage("assets/icons/pedigree.png"),
                              color: controller.tabIndex.value == 1
                                  ? DynamicColors.primaryColorRed
                                  : Colors.grey,
                            ),
                            Text(
                              "Pedigree",
                              style: montserratRegular(
                                fontSize: 11,
                                color: controller.tabIndex.value == 1
                                    ? DynamicColors.primaryColorRed
                                    : Colors.grey,
                              ),
                            )
                          ],
                        );
                      },
                      isLiked: controller.tabIndex.value == 1 ? true : false,
                      // likeCount: likeCount,
                    ),
                    LikeButton(
                      onTap: (a) async {
                        controller.tabIndex.value = 2;
                        return true;
                      },

                      circleColor: CircleColor(
                          start: DynamicColors.primaryColor,
                          end: DynamicColors.primaryColor.withOpacity(0.5)),
                      bubblesColor: BubblesColor(
                          dotPrimaryColor: DynamicColors.primaryColor,
                          dotSecondaryColor:
                              DynamicColors.primaryColor.withOpacity(0.5)),
                      size: widths / 6.5,
                      likeBuilder: (bool isLiked) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ImageIcon(
                              AssetImage("assets/icons/forum.png"),
                              color: controller.tabIndex.value == 2
                                  ? DynamicColors.primaryColorRed
                                  : Colors.grey,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              "Forums",
                              style: montserratRegular(
                                fontSize: 11,
                                color: controller.tabIndex.value == 2
                                    ? DynamicColors.primaryColorRed
                                    : Colors.grey,
                              ),
                            )
                          ],
                        );
                      },
                      isLiked: controller.tabIndex.value == 2 ? true : false,
                      // likeCount: likeCount,
                    ),
                    LikeButton(
                      onTap: (a) async {
                        controller.tabIndex.value = 3;
                        return true;
                      },
                      size: widths / 6.5,
                      circleColor: CircleColor(
                          start: DynamicColors.primaryColor,
                          end: DynamicColors.primaryColor.withOpacity(0.5)),
                      bubblesColor: BubblesColor(
                          dotPrimaryColor: DynamicColors.primaryColor,
                          dotSecondaryColor:
                              DynamicColors.primaryColor.withOpacity(0.5)),
                      likeBuilder: (bool isLiked) {
                        return Column(
                          children: [
                            ImageIcon(
                              AssetImage("assets/icons/group.png"),
                              color: controller.tabIndex.value == 3
                                  ? DynamicColors.primaryColorRed
                                  : Colors.grey,
                            ),
                            Text(
                              "Groups",
                              style: montserratRegular(
                                fontSize: 11,
                                color: controller.tabIndex.value == 3
                                    ? DynamicColors.primaryColorRed
                                    : Colors.grey,
                              ),
                            )
                          ],
                        );
                      },
                      isLiked: controller.tabIndex.value == 3 ? true : false,
                      // likeCount: likeCount,
                    ),
                    LikeButton(
                      onTap: (a) async {
                        controller.tabIndex.value = 4;
                        return true;
                      },
                      size: widths / 6.5,
                      circleColor: CircleColor(
                          start: DynamicColors.primaryColor,
                          end: DynamicColors.primaryColor.withOpacity(0.5)),
                      bubblesColor: BubblesColor(
                          dotPrimaryColor: DynamicColors.primaryColor,
                          dotSecondaryColor:
                              DynamicColors.primaryColor.withOpacity(0.5)),
                      likeBuilder: (bool isLiked) {
                        return Column(
                          children: [
                            ImageIcon(
                              AssetImage("assets/icons/classified.png"),
                              color: controller.tabIndex.value == 4
                                  ? DynamicColors.primaryColorRed
                                  : Colors.grey,
                            ),
                            Text(
                              "Classified",
                              style: montserratRegular(
                                fontSize: 11,
                                color: controller.tabIndex.value == 4
                                    ? DynamicColors.primaryColorRed
                                    : Colors.grey,
                              ),
                            )
                          ],
                        );
                      },
                      isLiked: controller.tabIndex.value == 4 ? true : false,
                      // likeCount: likeCount,
                    ),
                    LikeButton(
                      onTap: (a) async {
                        controller.tabIndex.value = 5;
                        return true;
                      },
                      size: widths / 6.5,
                      circleColor: CircleColor(
                          start: DynamicColors.primaryColor,
                          end: DynamicColors.primaryColor.withOpacity(0.5)),
                      bubblesColor: BubblesColor(
                          dotPrimaryColor: DynamicColors.primaryColor,
                          dotSecondaryColor:
                              DynamicColors.primaryColor.withOpacity(0.5)),
                      likeBuilder: (bool isLiked) {
                        return Column(
                          children: [
                            ImageIcon(
                              AssetImage("assets/icons/shop.png"),
                              color: controller.tabIndex.value == 5
                                  ? DynamicColors.primaryColorRed
                                  : Colors.grey,
                            ),
                            Text(
                              "Shop",
                              style: montserratRegular(
                                fontSize: 11,
                                color: controller.tabIndex.value == 5
                                    ? DynamicColors.primaryColorRed
                                    : Colors.grey,
                              ),
                            )
                          ],
                        );
                      },
                      isLiked: controller.tabIndex.value == 5 ? true : false,
                      // likeCount: likeCount,
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget floatingActionButton() {
    return SpeedDial(
      backgroundColor: DynamicColors.primaryColorRed,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
      activeIcon: Icons.close,
      overlayColor: Colors.black38 ,
      icon: Icons.add,
      childrenButtonSize: Size.fromRadius(35),
      childPadding: EdgeInsets.only(right: 10),
      direction: SpeedDialDirection.up,
      buttonSize: Size.fromRadius(30),
      switchLabelPosition: true,
      children: [
        speedDialChild("Add New Classified Ad", "assets/icons/classified.png",
            fromImage: true, onTap: () {
          Get.toNamed(Routes.newClassifiedAd);
        }),
        speedDialChild("Add New Group", "assets/icons/group.png",
            fromImage: true, onTap: () {
          Get.toNamed(Routes.addGroup);
        }),
        speedDialChild("Add New Pedigree", "assets/newPost/dog.png",
            fromImage: true, onTap: () {
          Get.toNamed(Routes.addNewPedigree);
        }),
        speedDialChild("Add New Event", FontAwesome5.calendar_alt, onTap: () {
          Get.toNamed(Routes.addEvent);
        }),
        speedDialChild("New Post", FontAwesome5.edit, onTap: () {
          Get.toNamed(Routes.newPost);
        }),
        speedDialChild("Share Bloodlines App", Entypo.paper_plane),
      ],
    );
  }

  Widget cartFloating() {
   return GetBuilder<ShopController>(builder: (controller){
     return bg.Badge(
       showBadge: true,
       badgeStyle: bg.BadgeStyle(
         shape: bg.BadgeShape.circle,
         badgeColor: DynamicColors.black,
         padding: EdgeInsets.zero,
       ),
       badgeContent: Container(
         height: 20,width: 20,
         decoration: BoxDecoration(
           color: Colors.black,
           shape: BoxShape.circle,
           // border: Border.all(color: DynamicColors.primaryColorRed)
         ),
         child: controller.cartModel == null? Container(): Center(
           child: Text(
             controller.cartModel!.data!.cart!.length.toString(),
             style: montserratLight(
                 fontSize: 16, color: DynamicColors.whiteColor),
           ),
         ),
       ),
       child: FloatingActionButton(
         onPressed: () {
           Get.toNamed(Routes.cartPage);
         },
         shape: CircleBorder(),
         backgroundColor: DynamicColors.primaryColorRed,
         child: Image.asset(
           "assets/icons/shop.png",
           height: 25,
           color: Colors.white,
         ),
       ),
     );
   });
  }

  SpeedDialChild speedDialChild(title, icon,
      {fromImage = false, VoidCallback? onTap}) {
    return SpeedDialChild(
      shape: CircleBorder(),
      elevation: 5,
      // foregroundColor: Colors.grey,


      labelWidget: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 4),
          decoration: BoxDecoration(
            color:  DynamicColors.primaryColor.withOpacity(0.4),
          ),
          child: Text(
            title,
            style: montserratBold(fontSize: 22, color: DynamicColors.whiteColor),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: fromImage == false
            ? Icon(
                icon,
                color: Colors.white,
              )
            : ImageIcon(
                AssetImage(icon),
                color: DynamicColors.primaryColorLight,
              ),
      ),
      onTap: onTap,
      backgroundColor: DynamicColors.primaryColor,


    );
  }
}
