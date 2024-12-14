// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Groups/Model/groupModel.dart';
import 'package:bloodlines/View/Groups/Model/groupSelectionModel.dart';
import 'package:bloodlines/View/newsFeed/data/feedComponentData.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/textField.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class AddGroup extends StatefulWidget {
  AddGroup({Key? key}) : super(key: key);

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  FeedController controller = Get.find();

  FeedComponentData feedData = FeedComponentData();
  final formKey = GlobalKey<FormState>();

  final GroupData? data = Get.arguments == null ? null : Get.arguments["data"];

  String? photo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (data != null) {
      controller.groupName.text = data!.name!;
      controller.groupDescription.text = data!.description!;
      controller.groupSelectList =
          data!.groupMembers!.map((e) => e.userId!).toList();
      controller.groupSelectList.remove(Api.singleton.sp.read("id"));
      controller.groupType.value =
          data!.type == "free" ? "Free Group" : "Subscription Group";
      if (data!.type == "free") {
        groupSelectionModelList[0].isSelected!.value = true;
        groupSelectionModelList[1].isSelected!.value = false;
      } else {
        groupSelectionModelList[1].isSelected!.value = true;
        groupSelectionModelList[0].isSelected!.value = false;
      }
      controller.charges.text = data!.charges ?? "";
      if(data!.photo != checkImageUrl("group")){
        photo = data!.photo!;
      }


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColors.primaryColorLight,
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Center(
          child: CustomButton(
            elevation: 5,
            text: "Continue",
            isLong: false,
            onTap: () {
              if(formKey.currentState!.validate()){
                if (data == null) {
                  Get.toNamed(Routes.selectGroupType);
                } else {
                  Get.toNamed(Routes.selectGroupType,
                      arguments: {"id": data!.id});
                }
              }
            },
            borderColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            borderRadius: BorderRadius.circular(5),
            color: DynamicColors.primaryColorRed,
            style: poppinsSemiBold(
                fontSize: 14, color: DynamicColors.primaryColorLight),
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: AppBarWidgets(),
        title: Text(
          data != null ? "Update group" : "New Group",
          style:
              poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 28),
        ),
        elevation: 0,
      ),
      body: GetBuilder<FeedController>(builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: SizedBox(
                        height: Utils.height(context) / 7,
                        width: double.infinity,
                        child: DottedBorder(
                          dashPattern: [8],
                          color: DynamicColors.primaryColorRed,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(8),
                          padding: EdgeInsets.all(6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child:data != null &&
                                controller.files == null &&
                                photo != null
                                ? Stack(
                              children: [
                                OptimizedCacheImage(
                                  imageUrl: photo!,
                                  width: Utils.width(context),
                                  fit: BoxFit.cover,
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      photo = null;
                                      controller.update();
                                    },
                                    child: Icon(
                                      Entypo.cancel_circled,
                                      color: DynamicColors.primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            )
                                : controller.files == null
                                ? GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      feedData.bottomSheet(context,
                                          fromAddEvent: true);
                                    },
                                    child: Center(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_circle_outline,
                                            color: DynamicColors.primaryColorRed,
                                            size: 25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Add Group Photo",
                                            style: poppinsRegular(
                                                fontSize: 15,
                                                color: DynamicColors
                                                    .primaryColorRed),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                :  Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.toNamed(Routes.photo,
                                                  arguments: {
                                                    "image":
                                                        controller.files!.path,
                                                    "type": "file"
                                                  });
                                            },
                                            child: Image.file(
                                              File(
                                                controller.files!.path,
                                              ),
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                controller.files = null;
                                                controller.update();
                                              },
                                              child: Icon(
                                                Entypo.cancel_circled,
                                                color: DynamicColors.primaryColor,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Group Name",
                    style:
                        poppinsLight(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                    controller: controller.groupName,
                    mainPadding: EdgeInsets.zero,
                    hint: "Live Show",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Group Description",
                    style:
                        poppinsLight(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                    controller: controller.groupDescription,
                    mainPadding: EdgeInsets.zero,
                    hint: "Lorem ipsum dolor sit amet, consetetur.",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Add Members",
                    style:
                        poppinsLight(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: controller.usersList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if(controller.usersList[index].isReported == 1){
                          return Container();
                        }
                        if (controller.usersList[index].id ==
                            Api.singleton.sp.read("id")) {
                          return Container();
                        }
                        if (controller.usersList[index].profile == null) {
                          return Container();
                        }
                        return GestureDetector(
                          onTap: () {
                            Utils.onNavigateTimeline(
                                controller.usersList[index].id!);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: DynamicColors.primaryColorRed),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: SizedBox(
                                      height: 65,
                                      width: 65,
                                      child: OptimizedCacheImage(
                                        imageUrl: controller.usersList[index]
                                            .profile!.profileImage!,
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
                                      controller
                                          .usersList[index].profile!.fullname!,
                                      style: poppinsRegular(),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    if (controller.groupSelectList.contains(
                                        controller.usersList[index].id)) {
                                      controller.groupSelectList.remove(
                                          controller.usersList[index].id!);
                                    } else {
                                      controller.groupSelectList
                                          .add(controller.usersList[index].id!);
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
                                              color: controller.groupSelectList
                                                      .contains(controller
                                                          .usersList[index].id)
                                                  ? DynamicColors.primaryColorRed
                                                  : DynamicColors.accentColor),
                                          color: controller.groupSelectList
                                                  .contains(controller
                                                      .usersList[index].id)
                                              ? DynamicColors.primaryColorRed
                                              : DynamicColors.whiteColor),
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          size: 10,
                                          color: controller.groupSelectList
                                                  .contains(controller
                                                      .usersList[index].id)
                                              ? DynamicColors.whiteColor
                                              : DynamicColors.accentColor,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
