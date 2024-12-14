import 'package:bloodlines/Components/CustomAlert.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/Timeline/Model/memberModel.dart';
import 'package:bloodlines/View/Timeline/View/timeline.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/view/feed.dart';
import 'package:bloodlines/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class Followers extends StatefulWidget {
  Followers({Key? key}) : super(key: key);

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> with TickerProviderStateMixin {
  FeedController controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.followerController = TabController(length: 2, vsync: this);
    if (Get.arguments != null) {
      controller.followerController!.animateTo(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: DynamicColors.primaryColorLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: AppBarWidgets(
            decorationColor: Colors.transparent,
          ),
          title: GetBuilder<FeedController>(builder: (controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: CustomTabBarClass(
                      onTap: () {
                        controller.followerController!.index = 0;
                        controller.update();
                      },
                      title: "Following",
                      tabValue: controller.followerController!.index,
                      value: 0,
                    )),
                Expanded(
                    flex: 4,
                    child: CustomTabBarClass(
                      onTap: () {
                        controller.followerController!.index = 1;
                        controller.update();
                      },
                      title: "Followers",
                      tabValue: controller.followerController!.index,
                      value: 1,
                    )),
              ],
            );
          }),
          elevation: 0,
        ),
        body: GetBuilder<FeedController>(builder: (controller) {
          return TabBarView(
            controller: controller.followerController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              controller.followings == null?
              Center(child: LoaderClass(),):
              controller.followings!.data!.isEmpty?Center(
                child: Text(
                  "No Data",
                  style: poppinsBold(fontSize: 25),
                ),
              ):
              ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: controller.followings!.data!.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    UserModel user = controller.followings!.data![index].users!;
                    return GestureDetector(
                      onTap: (){
                        Utils.onNavigateTimeline(user.id!);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child:
                                SizedBox(

                                  child: OptimizedCacheImage(
                                    imageUrl:
                                    user.profile!.profileImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.profile!.fullname!,
                                  style: poppinsRegular(),
                                ),
                              ],
                            ),
                            Spacer(),
                            CustomButton(
                              text: "Unfollow",
                              isLong: false,
                              onTap: () {
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
                                      controller.removeFollowing(user.id!,myFollowers:true);
                                    },
                                    click2: () {
                                      Get.back();
                                    });
                              },
                              borderColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              borderRadius: BorderRadius.circular(5),
                              color: DynamicColors.primaryColorRed.withOpacity(
                                  0.3),
                              style: poppinsRegular(
                                  fontSize: 15,
                                  color: DynamicColors.primaryColorRed),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),


              controller.followers == null?
              Center(child: LoaderClass(),):
              controller.followers!.data!.isEmpty?Center(
                child: Text(
                  "No Data",
                  style: poppinsBold(fontSize: 25),
                ),
              ):
              ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: controller.followers!.data!.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    UserModel user = controller.followers!.data![index].users!;
                    return GestureDetector(
                      onTap: (){
                        Utils.onNavigateTimeline(user.id!);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child:OptimizedCacheImage(
                                  imageUrl:
                                  user.profile!.profileImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.profile!.fullname!,
                                  style: poppinsRegular(),
                                ),

                              ],
                            ),
                            Spacer(),
                            CustomButton(
                              text:controller.followers!.data![index].isFollowing == true?
                                  "Unfollow"
                                  : "Follow Back",
                              isLong: false,
                              onTap: () {
                                if(controller.followers!.data![index].isFollowing == true){
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
                                        controller.removeFollowing(user.id!,myFollowers:true);
                                      },
                                      click2: () {
                                        Get.back();
                                      });
                                }else{
                                  controller.sendFollowRequest(user.id!);
                                }
                              },
                              borderColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              borderRadius: BorderRadius.circular(5),
                              color: DynamicColors.primaryColorRed.withOpacity(
                                  controller.followers!.data![index].isFollowing == false?1:  0.3),
                              style: poppinsRegular(
                                  fontSize: 15,
                                  color:controller.followers!.data![index].isFollowing == false?Colors.white: DynamicColors.primaryColorRed),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          );
        }),
      ),
    );
  }
}




class FriendFollowers extends StatefulWidget {
  FriendFollowers({Key? key}) : super(key: key);

  @override
  State<FriendFollowers> createState() => _FriendFollowersState();
}

class _FriendFollowersState extends State<FriendFollowers>
    with TickerProviderStateMixin {
  FeedController controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.friendFollowerController = TabController(length: 2, vsync: this);
    if (Get.arguments != null) {
      controller.friendFollowerController!.animateTo(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: DynamicColors.primaryColorLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: AppBarWidgets(
            decorationColor: Colors.transparent,
          ),
          title: GetBuilder<FeedController>(builder: (controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: CustomTabBarClass(
                      onTap: () {
                        controller.friendFollowerController!.index = 0;
                        controller.update();
                      },
                      title: "Following",
                      tabValue: controller.friendFollowerController!.index,
                      value: 0,
                    )),
                Expanded(
                    flex: 4,
                    child: CustomTabBarClass(
                      onTap: () {
                        controller.friendFollowerController!.index = 1;
                        controller.update();
                      },
                      title: "Followers",
                      tabValue: controller.friendFollowerController!.index,
                      value: 1,
                    )),
                // InkWell(
                //   onTap: () {
                //     controller.friendFollowerController!.animateTo(0);
                //     controller.update();
                //   },
                //   child: Text(
                //     "Friends",
                //     style: poppinsLight(
                //         fontSize: 12,
                //         color: controller.friendFollowerController!.index == 0
                //             ? DynamicColors.primaryColor
                //             : DynamicColors.accentColor.withOpacity(0.5)),
                //   ),
                // ),
                // SizedBox(
                //   width: 10,
                // ),
                // SizedBox(
                //   height: 20,
                //   child: VerticalDivider(
                //     width: 2,
                //     color: DynamicColors.textColor,
                //   ),
                // ),
                // SizedBox(
                //   width: 10,
                // ),
                // InkWell(
                //   onTap: () {
                //     controller.friendFollowerController!.animateTo(1);
                //     controller.update();
                //   },
                //   child: Text(
                //     "Followers",
                //     style: poppinsLight(
                //         fontSize: 12,
                //         color: controller.friendFollowerController!.index == 1
                //             ? DynamicColors.primaryColor
                //             : DynamicColors.accentColor.withOpacity(0.5)),
                //   ),
                // ),
              ],
            );
          }),
          elevation: 0,
        ),
        body: GetBuilder<FeedController>(builder: (controller) {
          return TabBarView(
            controller: controller.friendFollowerController,
            physics: NeverScrollableScrollPhysics(),
            children: [
            controller.friendFollowings == null?
                Center(child: LoaderClass(),):
            controller.friendFollowings!.data!.isEmpty?Center(
          child: Text(
          "No Data",
          style: poppinsBold(fontSize: 25),
          ),
          ):
            ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: controller.friendFollowings!.data!.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    UserModel user = controller.friendFollowings!.data![index].users!;
                    return GestureDetector(
                      onTap: (){
                        Utils.onNavigateTimeline(user.id!);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: OptimizedCacheImage(
                                  imageUrl:
                                  user.profile!.profileImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.profile!.fullname!,
                                  style: poppinsRegular(),
                                ),

                              ],
                            ),
                            Spacer(),
                            // CustomButton(
                            //   text: "Unfollow",
                            //   isLong: false,
                            //   onTap: () {},
                            //   borderColor: Colors.transparent,
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 15, vertical: 10),
                            //   borderRadius: BorderRadius.circular(5),
                            //   color: DynamicColors.primaryColorRed.withOpacity(
                            //       0.3),
                            //   style: poppinsRegular(
                            //       fontSize: 15,
                            //       color: DynamicColors.primaryColorRed),
                            // ),
                          ],
                        ),
                      ),
                    );
                  }),
              controller.friendFollowers == null?
              Center(child: LoaderClass(),):
              controller.friendFollowers!.data!.isEmpty?Center(
                child: Text(
                  "No Data",
                  style: poppinsBold(fontSize: 25),
                ),
              ):
              ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: controller.friendFollowers!.data!.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    UserModel user = controller.friendFollowers!.data![index].users!;
                    return GestureDetector(
                      onTap: (){
                        Utils.onNavigateTimeline(user.id!);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: OptimizedCacheImage(
                                  imageUrl:
                                  user.profile!.profileImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.profile!.fullname!,
                                  style: poppinsRegular(),
                                ),
                              ],
                            ),
                            Spacer(),
                            // CustomButton(
                            //   text: "Remove",
                            //   isLong: false,
                            //   onTap: () {},
                            //   borderColor: Colors.transparent,
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 15, vertical: 10),
                            //   borderRadius: BorderRadius.circular(5),
                            //   color: DynamicColors.primaryColorRed.withOpacity(
                            //       0.3),
                            //   style: poppinsRegular(
                            //       fontSize: 15,
                            //       color: DynamicColors.primaryColorRed),
                            // ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          );
        }),
      ),
    );
  }
}
