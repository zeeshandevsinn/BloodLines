// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/customWidget.dart';
import 'package:bloodlines/Components/dividerClass.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/Timeline/View/timeline.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/model/notificationModel.dart';
import 'package:bloodlines/userModel.dart';
import 'package:flutter/material.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class NotificationClass extends StatelessWidget {
  NotificationClass({Key? key}) : super(key: key);

  RxInt index = 0.obs;
  FeedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DynamicColors.primaryColorLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: AppBarWidgets(),
          title: Text(
            "Notifications",
            style: poppinsSemiBold(
                color: DynamicColors.primaryColor, fontSize: 28),
          ),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight - 10),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Obx(() {
                      return CustomTabBarClass(
                        onTap: () {
                          index.value = 0;
                        },
                        title: "Followers",
                        tabValue: index.value,
                        value: 0,
                      );
                    })),
                Expanded(
                    flex: 3,
                    child: Obx(() {
                      return CustomTabBarClass(
                        onTap: () {
                          index.value = 1;
                        },
                        title: "Groups",
                        tabValue: index.value,
                        value: 1,
                      );
                    })),
              ],
            ),
          ),
        ),
        body: GetBuilder<FeedController>(
          builder: (controller) {
            return Obx(() {
              return IndexedStack(
                index: index.value,
                children: [
                  controller.requestModel == null
                      ? Center(child: LoaderClass())
                      : controller.requestModel!.data!.isEmpty
                          ? Center(
                              child: Text(
                                "No Data",
                                style: poppinsBold(fontSize: 25),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DividerClass(),
                                  ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                      itemCount:
                                          controller.requestModel!.data!.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                    if( controller
                                        .requestModel!.data![index].users == null){
                                      return Container();
                                    }
                                        UserModel user = controller
                                            .requestModel!.data![index].users!;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: SizedBox(
                                                      height: 50,
                                                      child:
                                                          OptimizedCacheImage(
                                                        imageUrl: user.profile!
                                                            .profileImage!,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        Utils.width(context) /
                                                            1.7,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        RichText(
                                                            text: TextSpan(
                                                                children: [
                                                              TextSpan(
                                                                  text: user
                                                                      .profile!
                                                                      .fullname!,
                                                                  style: poppinsLight(
                                                                      color: DynamicColors
                                                                          .primaryColorRed,
                                                                      fontSize:
                                                                          16)),
                                                              TextSpan(
                                                                  text:
                                                                      " sends you a Follow Request",
                                                                  style: poppinsLight(
                                                                      fontSize:
                                                                          16)),
                                                            ])),
                                                        SizedBox(
                                                          height: 11,
                                                        ),
                                                        Row(
                                                          children: [
                                                            CustomButton(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          25),
                                                              isLong: false,
                                                              style: poppinsLight(
                                                                  color: DynamicColors
                                                                      .primaryColor,
                                                                  fontSize: 16),
                                                              text: "Reject",
                                                              color: Colors
                                                                  .transparent,
                                                              onTap: () {
                                                                controller
                                                                    .acceptOrRejectRequest(user.id!,
                                                                        "rejected");
                                                              },
                                                              border: Border.all(
                                                                  color: DynamicColors
                                                                      .primaryColor),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            Spacer(),
                                                            CustomButton(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          25),
                                                              text: "Accept",
                                                              isLong: false,
                                                              style: poppinsLight(
                                                                  color: DynamicColors
                                                                      .primaryColorLight,
                                                                  fontSize: 15),
                                                              onTap: () {
                                                                controller
                                                                    .acceptOrRejectRequest(user.id!,
                                                                        "accepted");
                                                              },
                                                              color: DynamicColors
                                                                  .primaryColor,
                                                              borderColor:
                                                                  DynamicColors
                                                                      .primaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                      getTimeMethod(controller
                                                          .requestModel!
                                                          .data![index]
                                                          .createdAt!
                                                          .toLocal()
                                                          .toString()),
                                                      style: poppinsLight(
                                                          fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                            notificationList.length - 1 == index
                                                ? SizedBox.shrink()
                                                : DividerClass()
                                          ],
                                        );
                                      })
                                ],
                              ),
                            ),


                  controller.groupInvitationList == null
                      ? Center(child: LoaderClass())
                      : controller.groupInvitationList!.data!.isEmpty
                          ? Center(
                              child: Text(
                                "No Data",
                                style: poppinsBold(fontSize: 25),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DividerClass(),
                                  ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                      itemCount: controller
                                          .groupInvitationList!.data!.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                    if(controller
                                        .groupInvitationList!
                                        .data![index]
                                        .groupData!
                                        .user == null){
                                      return Container();
                                    }
                                        UserModel user = controller
                                            .groupInvitationList!
                                            .data![index]
                                            .groupData!
                                            .user!;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: SizedBox(
                                                      height: 50,
                                                      child:
                                                          OptimizedCacheImage(
                                                        imageUrl: user.profile!
                                                            .profileImage!,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        Utils.width(context) /
                                                            1.7,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        RichText(
                                                            text: TextSpan(
                                                                children: [
                                                              TextSpan(
                                                                  text: user
                                                                      .profile!
                                                                      .fullname!,
                                                                  style: poppinsLight(
                                                                      color: DynamicColors
                                                                          .primaryColorRed,
                                                                      fontSize:
                                                                          16)),
                                                              TextSpan(
                                                                  text:
                                                                      " invites you to join ",
                                                                  style: poppinsLight(
                                                                      fontSize:
                                                                          16)),
                                                                  TextSpan(
                                                                      text: controller.groupInvitationList!.data![index].groupData!.name,
                                                                      style: poppinsLight(
                                                                          color: DynamicColors
                                                                              .primaryColorRed,
                                                                          fontSize:
                                                                          16)),
                                                            ])),
                                                        SizedBox(
                                                          height: 11,
                                                        ),
                                                        Row(
                                                          children: [
                                                            CustomButton(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          25),
                                                              isLong: false,
                                                              style: poppinsLight(
                                                                  color: DynamicColors
                                                                      .primaryColor,
                                                                  fontSize: 16),
                                                              text: "Reject",
                                                              color: Colors
                                                                  .transparent,
                                                              onTap: () {
                                                                controller.groupAcceptOrRejectRequest(
                                                                    controller
                                                                        .groupInvitationList!
                                                                        .data![
                                                                            index]
                                                                        .groupData!
                                                                        .id!,
                                                                    "reject");
                                                              },
                                                              border: Border.all(
                                                                  color: DynamicColors
                                                                      .primaryColor),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            Spacer(),
                                                            CustomButton(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          25),
                                                              text: "Accept",
                                                              isLong: false,
                                                              style: poppinsLight(
                                                                  color: DynamicColors
                                                                      .primaryColorLight,
                                                                  fontSize: 15),
                                                              onTap: () {
                                                                controller.groupAcceptOrRejectRequest(
                                                                    controller
                                                                        .groupInvitationList!
                                                                        .data![
                                                                            index]
                                                                        .groupData!
                                                                        .id!,
                                                                    "accept");
                                                              },
                                                              color: DynamicColors
                                                                  .primaryColor,
                                                              borderColor:
                                                                  DynamicColors
                                                                      .primaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                      getTimeMethod(controller
                                                          .groupInvitationList!
                                                          .data![index]
                                                          .createdAt ??
                                                      controller
                                                          .groupInvitationList!
                                                          .data![index]
                                                          .groupData!
                                                          .createdAt!
                                                          .toLocal()
                                                          .toString()
                                                          ),
                                                      style: poppinsLight(
                                                          fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                            notificationList.length - 1 == index
                                                ? SizedBox.shrink()
                                                : DividerClass()
                                          ],
                                        );
                                      })
                                ],
                              ),
                            ),
                ],
              );
            });
          },
        ));
  }
}
