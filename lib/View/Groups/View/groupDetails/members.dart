// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/CustomAlert.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/dividerClass.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/Groups/Model/groupModel.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class MembersClass extends StatelessWidget {
  MembersClass({Key? key}) : super(key: key);
 FeedController controller = Get.find();
  List<GroupMember> members = Get.arguments["members"];
  int groupID = Get.arguments["groupID"];
  bool isAdmin = Get.arguments["isAdmin"];
  RxBool change = false.obs;

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
          "Group Members",
          style:
              poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 28),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (change.value) {
          return observerWidget();
        }
        return observerWidget();
      }),
    );
  }

  SingleChildScrollView observerWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Admin",
              style: poppinsBold(color: DynamicColors.primaryColor),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: (){
              Utils.onNavigateTimeline(controller.groupData!.user!.id!);
            },
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      child: OptimizedCacheImage(imageUrl:
                        controller.groupData!.user!.profile!.profileImage!,fit: BoxFit.cover,
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
                        controller.groupData!.user!.profile!.fullname!,
                        style: poppinsRegular(),
                      ),
                      // Text(
                      //   user.profileNormal!.normalProfileMeta!.shortBio!,
                      //   style: poppinsLight(
                      //       fontSize: 12,
                      //       color:
                      //           DynamicColors.accentColor.withOpacity(0.5)),
                      // ),
                    ],
                  ),
                  // Spacer(),
                  // isAdmin == false
                  //     ? Container()
                  //     : members[index].role == "admin"?Container(): InkWell(
                  //         onTap: () {
                  //           Get.bottomSheet(
                  //               GroupMemberBottomSheet(
                  //                   user: members[index].user!,
                  //                   groupID: groupID),
                  //               isScrollControlled: true);
                  //         },
                  //         child: Icon(
                  //           Icons.more_vert,
                  //           color: DynamicColors.primaryColor,
                  //         )),
                ],
              ),
            ),
          ),
          DividerClass(),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Members",
              style: poppinsBold(color: DynamicColors.primaryColor),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: controller.groupData!.groupMembers!.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
            if(controller.groupData!.groupMembers![index].user == null){
              return Container();
            }
                UserModel user =
                controller.groupData!.groupMembers![index].user!;
                if( user.isReported == 1){
                  return Container();
                }
                if (controller.groupData!.user!.id ==
                    user.id) {
                  return Container();
                }
                return GestureDetector(
                  onTap: (){
                    Utils.onNavigateTimeline(user.id!);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                            child:  OptimizedCacheImage(
                              imageUrl:    user.profile!.profileImage!,
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
                            // Text(
                            //   user.profileNormal!.normalProfileMeta!.shortBio!,
                            //   style: poppinsLight(
                            //       fontSize: 12,
                            //       color:
                            //           DynamicColors.accentColor.withOpacity(0.5)),
                            // ),
                          ],
                        ),
                        Spacer(),
                        isAdmin == false
                            ? Container()
                            : members[index].id == controller.groupData!.user!.id
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      Get.bottomSheet(
                                          GroupMemberBottomSheet(
                                              user: members[index].user!,
                                              groupID: groupID),
                                          isScrollControlled: true);
                                    },
                                    child: Icon(
                                      Icons.more_vert,
                                      color: DynamicColors.primaryColor,
                                    )),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
class GroupMemberBottomSheet extends StatelessWidget {
  GroupMemberBottomSheet({Key? key, required this.user, required this.groupID})
      : super(key: key);

  FeedController controller = Get.find();
  final UserModel user;
  final int groupID;
  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
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
                    CustomButton(
                      text: "Admin",
                      isLong: true,
                      onTap: () {
                        Get.back();
                        alertCustomMethod(context,
                            theme: DynamicColors.primaryColor,
                            titleText:
                            "Do you want to make ${user.profile!.fullname} admin",
                            click: () {
                              Get.back();
                              // controller.makeGroupAdmin(groupID, user.id!);
                            }, click2: () {
                              Get.back();
                            }, buttonText: "Yes", buttonText2: "No");
                      },
                      borderColor: Colors.transparent,
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      borderRadius: BorderRadius.circular(5),
                      color: DynamicColors.primaryColor.withOpacity(0.6),
                      style: poppinsRegular(
                          fontSize: 15, color: DynamicColors.primaryColor),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      text: "Remove",
                      isLong: true,
                      onTap: () {
                        Get.back();
                        alertCustomMethod(context,
                            theme: DynamicColors.primaryColor,
                            titleText:
                            "Do you want to remove ${user.profile!.fullname}",
                            click: () {
                              Get.back();
                              // controller.removeGroupMember(groupID, user.id!);
                            }, click2: () {
                              Get.back();
                            }, buttonText: "Yes", buttonText2: "No");
                      },
                      borderColor: Colors.transparent,
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      borderRadius: BorderRadius.circular(5),
                      color: DynamicColors.primaryColor.withOpacity(0.6),
                      style: poppinsRegular(
                          fontSize: 15, color: DynamicColors.primaryColor),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
