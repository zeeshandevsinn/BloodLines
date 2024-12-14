// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/SingletonPattern/singletonUser.dart';
import 'package:bloodlines/View/Pedigree/View/pedigree.dart';
import 'package:bloodlines/View/Timeline/View/timelineDetails/forumPosts.dart';
import 'package:bloodlines/View/Timeline/View/timelineDetails/photos.dart';
import 'package:bloodlines/View/Timeline/View/timelineDetails/post.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/view/post/postWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class Timeline extends StatefulWidget {
  Timeline({Key? key}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  RxInt tab = 0.obs;

  FeedController controller = Get.find();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getUser();
    controller.getUsersFeed(Api.singleton.sp.read("id"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<FeedController>(builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Utils.height(context) / 2.8,
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.photo, arguments: {
                              "image": controller.myProfile.value!.profile!
                                  .coverImage!
                            });
                          },
                          child: SizedBox(
                            width: Utils.width(context),
                            height: Utils.height(context) / 4.5,
                            child: OptimizedCacheImage(
                              imageUrl:
                              controller.myProfile.value!.profile!.coverImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                            top: Platform.isIOS ? 40 : 20,
                            left: 10,
                            child: AppBarWidgets(
                              margin: 0,

                              padding: EdgeInsets.all(4),
                              decorationColor: Colors.black45,
                              color: DynamicColors.whiteColor,
                            )),
                        Positioned(
                            top: Platform.isIOS ? 45 : 25,
                            right: 10,
                            child: AppBarWidgets(
                              margin: 0,
                              onTap: () {
                                Get.toNamed(Routes.completeProfile,
                                    arguments: {
                                      "data": controller.myProfile.value!
                                    })!.then((value) =>  controller.getUser());
                              },
                              icon: Icons.edit,
                              padding: EdgeInsets.all(4),
                              decorationColor: Colors.black45,
                              color: DynamicColors.whiteColor,
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
                              controller.myProfile.value!.profile!.fullname!,
                              style: montserratRegular(fontSize: 24),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.getFollowers();
                                    controller.getFollowing();
                                    Get.toNamed(Routes.followers,
                                        arguments: {"data": true})!.then((value) =>  controller.getUser());
                                  },
                                  child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: controller
                                                .myProfile.value!.followersCount
                                                .toString(),
                                            style: montserratBold(
                                                fontSize: 16)),
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
                                    controller.getFollowers();
                                    controller.getFollowing();
                                    Get.toNamed(Routes.followers)!.then((value) =>  controller.getUser());
                                  },
                                  child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: controller
                                                .myProfile.value!.followingCount
                                                .toString(),
                                            style: montserratBold(
                                                fontSize: 16)),
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
                            controller.myProfile.value!.profile!.about ?? "",
                            style: poppinsLight(
                                fontSize: 13, fontWeight: FontWeight.w200),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: Utils.height(context) / 5.5,
                        right: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.photo, arguments: {
                                "image": controller.myProfile.value!.profile!
                                    .profileImage!
                              });
                            },
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: OptimizedCacheImage(
                                imageUrl: controller
                                    .myProfile.value!.profile!.profileImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                        )),
                  ],
                ),
              ),
              Column(
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
                    return Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: IndexedStack(
                        index: tab.value,
                        children: [
                          controller.myPostsData == null?
                          LoaderClass()
                              :    ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                              itemCount:
                              controller.myPostsData!.postModel!.length,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return PostClass(
                                  index: index,
                                  result:controller.myPostsData!.postModel![index],
                                  fromTimeline: true,
                                );
                              }),
                          TimelinePhotos(gallery: controller
                              .myProfile.value!.gallery!,),
                          TimelineForum(forumList: controller
                              .myProfile.value!.forums!),
                          DataTableClass(myPedigree: true, fromTimeline: true),
                        ],
                      ),
                    );
                  }),
                ],
              )
            ],
          ),
        );
      }),
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
              "Follow this Profile to View there Pedigree and Posts",
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
  CustomTabBarClass({Key? key,
    required this.value,
    required this.tabValue,
    required this.onTap,
    required this.title})
      : super(key: key);

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
