// ignore_for_file: invalid_use_of_protected_member, must_be_immutable

import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class GroupInviteClass extends StatefulWidget {
  GroupInviteClass({
    Key? key,
    this.id = 0,
    this.myGroup = false,
  }) : super(key: key);
  int id;
  bool myGroup;

  @override
  State<GroupInviteClass> createState() => _GroupInviteClassState();
}

class _GroupInviteClassState extends State<GroupInviteClass> {
  FeedController controller = Get.find();
  int? id = Get.arguments == null ? null : Get.arguments["id"];
  bool myGroup =
  Get.arguments == null ? false : Get.arguments["myGroup"] ?? false;

  RxList<int> membersList = <int>[].obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.id != 0){
      id = widget.id;
    }
    controller.groupInvitedList = null;
    controller.getGroupInviteList(id ?? 0);
    if (controller.groupInviteSelectList.isNotEmpty) {
      membersList.addAll(controller.groupInviteSelectList.map((e) => e.id!));
    }
  }

  Widget body() {
    return GetBuilder<FeedController>(builder: (controller) {
      if (controller.groupInvitedList == null) {
        return LoaderClass();
      } else if (controller.groupInvitedList!.data!.isEmpty) {
        return Center(
          child: Text(
            "No Data",
            style: poppinsBold(fontSize: 25),
          ),
        );
      }
      return SingleChildScrollView(
        child: Wrap(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              child: Container(
                decoration: BoxDecoration(
                  color: DynamicColors.primaryColorLight,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),

                        Row(
                          children: [
                            Text(
                              "Invite Friends",
                              style: montserratBold(fontSize: 24),
                            ),
                            Spacer(),
                            Obx(() {
                              return CustomButton(
                                isLong: false,
                                onTap: () {
                                  controller.isInviteAll.value =
                                  !controller.isInviteAll.value;
                                  if (controller.isInviteAll.value == true) {
                                    for (var element
                                    in controller.groupInvitedList!.data!) {
                                      if(element.profile!=null){
                                        membersList.value.add(element.id!);
                                        controller.groupInviteSelectList.add(element);
                                      }
                                    }
                                  } else {
                                    for (var element
                                    in controller.groupInvitedList!.data!) {
                                      membersList.value.remove(element.id!);
                                      controller.groupInviteSelectList
                                          .removeWhere((e) => element.id == e.id);
                                    }
                                  }
                                  controller.update();
                                },
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                color: DynamicColors.whiteColor,
                                borderColor: controller.isInviteAll.value
                                    ? DynamicColors.primaryColorRed
                                    : DynamicColors.accentColor,
                                borderRadius: BorderRadius.circular(5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Invite All",
                                      style: montserratSemiBold(
                                        fontSize: 14,
                                        color: controller.isInviteAll.value
                                            ? DynamicColors.primaryColorRed
                                            : DynamicColors.accentColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: controller.isInviteAll.value
                                            ? DynamicColors.primaryColorRed
                                            : DynamicColors.accentColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Icon(
                                          Icons.check,
                                          color: DynamicColors.whiteColor,
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: controller.groupInvitedList!.data!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if( controller.groupInvitedList!.data![index].isReported == 1){
                                return Container();
                              }
                              if (controller
                                  .groupInvitedList!.data![index].profile ==
                                  null) {
                                return Container();
                              }
                              return GestureDetector(
                                onTap: () {
                                  Utils.onNavigateTimeline(controller
                                      .groupInvitedList!.data![index].id!);
                                },
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 48,
                                        width: 48,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: DynamicColors.primaryColorRed),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(30),
                                          child: SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: OptimizedCacheImage(
                                              imageUrl:
                                              controller
                                                  .groupInvitedList!
                                                  .data![index]
                                                  .profile!
                                                  .profileImage!,

                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller
                                                .groupInvitedList!
                                                .data![index]
                                                .profile!
                                                .fullname!,
                                            style: poppinsRegular(fontSize: 14),
                                          ),
                                          // Text(
                                          //   inviteMembers[index].subtitle,
                                          //   style: poppinsRegular(
                                          //       fontSize: 10,
                                          //       color: DynamicColors.accentColor),
                                          // ),
                                        ],
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          if (membersList.value.contains(
                                              controller.groupInvitedList!
                                                  .data![index].id)) {
                                            membersList.value.remove(controller
                                                .groupInvitedList!
                                                .data![index]
                                                .id!);
                                            controller.groupInviteSelectList.removeWhere((element) => element.id == controller.groupInvitedList!
                                                .data![index].id);
                                          } else {
                                            membersList.value.add(controller
                                                .groupInvitedList!
                                                .data![index]
                                                .id!);
                                            controller.groupInviteSelectList.add(
                                                controller.groupInvitedList!
                                                    .data![index]);
                                          }
                                          controller.update();
                                        },
                                        child: GetBuilder<FeedController>(
                                            builder: (controller) {
                                              return Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: membersList.value
                                                            .contains(controller
                                                            .groupInvitedList!
                                                            .data![index]
                                                            .id)
                                                            ? DynamicColors
                                                            .primaryColorRed
                                                            : DynamicColors
                                                            .accentColor),
                                                    color: membersList.value
                                                        .contains(controller
                                                        .groupInvitedList!
                                                        .data![index]
                                                        .id)
                                                        ? DynamicColors
                                                        .primaryColorRed
                                                        : DynamicColors.whiteColor),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 10,
                                                    color: membersList.value
                                                        .contains(controller
                                                        .groupInvitedList!
                                                        .data![index]
                                                        .id)
                                                        ? DynamicColors.whiteColor
                                                        : DynamicColors.accentColor,
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      // CustomButton(
                                      //   text: "Invite",
                                      //   isLong: false,
                                      //   onTap: () {
                                      //     controller.invitePeople(eventId: id!,
                                      //         members: [
                                      //           controller.groupInvitedList!
                                      //               .data![index].id!
                                      //         ]);
                                      //   },
                                      //   padding: EdgeInsets.symmetric(
                                      //       vertical: 7, horizontal: 20),
                                      //   color: DynamicColors.primaryColorRed,
                                      //   borderColor: DynamicColors
                                      //       .primaryColorRed,
                                      //   borderRadius: BorderRadius.circular(5),
                                      //   style: poppinsSemiBold(
                                      //       color: DynamicColors.whiteColor,
                                      //       fontSize: 14),
                                      // )
                                    ],
                                  ),
                                ),
                              );
                            }),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // if(id == null){
    //   return body();
    // }
    return Scaffold(
      backgroundColor: DynamicColors.primaryColorLight,
      appBar: id == null
          ? null
          : AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: AppBarWidgets(),
        title: Text(
          "Invite Members",
          style: poppinsSemiBold(
              color: DynamicColors.primaryColor, fontSize: 24),
        ),
        elevation: 0,
      ),
      body: body(),
      bottomNavigationBar: id == null
          ? null
          :  GetBuilder<FeedController>(builder: (controller) {
        return Container(
          width: double.infinity,
          height: kBottomNavigationBarHeight,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              return CustomButton(
                text: "Invite",
                isLong: true,
                onTap: () {
                  controller.inviteToGroup( id,  membersList.value);

                },
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                color: controller.isInviteAll.value == true ||
                    membersList.value.isNotEmpty
                    ? DynamicColors.primaryColorRed
                    : DynamicColors.accentColor,
                borderRadius: BorderRadius.circular(5),
                borderColor: Colors.transparent,
                style: poppinsSemiBold(
                    color: DynamicColors.whiteColor, fontSize: 14),
              );
            }),
          ),
        );
      }),
    );
  }
}