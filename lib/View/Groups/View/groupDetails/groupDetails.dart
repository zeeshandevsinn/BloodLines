import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/CustomAlert.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Groups/Model/groupModel.dart';
import 'package:bloodlines/View/Groups/View/groupDetails/groupItemsClass.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/view/event/components/eventWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GroupDetails extends StatefulWidget {
  GroupDetails({super.key});

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  final FeedController controller = Get.find();

  int id = Get.arguments["id"];

  @override
  void initState() {
    controller.currentGroupId = id;
    controller.getJoinedGroups();
    super.initState();
    if (Api.singleton.sp.read("GroupID") == null ||
        Api.singleton.sp.read("GroupID") != id) {
      controller.groupData = null;
      controller.groupPosts = null;
    }
    Api.singleton.sp.write("GroupID", id);
    controller.getGroupPosts(id);
    controller.getGroupDetails(id);
  }

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
          "Group Details",
          style:
          poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
        ),
        elevation: 0,
        actions: [
          GetBuilder<FeedController>(builder: (logic) {
            if(controller.groupData == null){
              return Container();
            }else if(controller.groupData!.isJoined != "joined"){
              return Container();
            }
            return AppBarWidgets(
              height: 50,
              width: 50,
              onTap: () {
                if (controller.groupData != null) {
                  Get.toNamed(Routes.newPost,
                      arguments: {"group": controller.groupData!,});
                }
              },
              color: DynamicColors.primaryColorRed,
              icon: Entypo.plus_circled,
              size: 20,
              margin: 2,
              padding: EdgeInsets.all(8),
            );
          }),
          SizedBox(
            width: 10,
          ),
          AppBarWidgets(
            height: 50,
            width: 50,
            onTap: () {
              if (controller.groupData != null) {
                // if (controller.groupData!.isJoined == "joined") {
                //   Get.bottomSheet(
                //       GroupBottomSheet(
                //         data: controller.groupData!,
                //       ),
                //       isScrollControlled: true);
                // }
                Get.bottomSheet(
                    GroupBottomSheet(
                      data: controller.groupData!,
                    ),
                    isScrollControlled: true);
              }
            },
            color: DynamicColors.primaryColorRed,
            assetImage: "assets/icons/info.png",
            size: 20,
            margin: 2,
            padding: EdgeInsets.all(8),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: GetBuilder<FeedController>(builder: (controller) {
        if (controller.groupData == null) {
          return Center(
            child: LoaderClass(),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              GroupItemsClass(
                model: controller.groupData!,
                premium: controller.groupData!.type != "free" ? true : false,
                myGroup: controller.groupData!.user!.id ==
                    Api.singleton.sp.read("id")
                    ? true
                    : false,
                joined:
                controller.groupData!.isJoined == "joined" ? true : false,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class GroupBottomSheet extends StatelessWidget {
  GroupBottomSheet({super.key, required this.data});

  FeedController controller = Get.find();
  final GroupData data;

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
                    TextWidget("Group Info", data.description ?? ""),
                    SizedBox(
                      height: 20,
                    ),
                    TextWidget("Created Date",
                        DateFormat('dd-MMMM-yyyy').format(data.createdAt!)),
                    SizedBox(
                      height: 20,
                    ),
                    TextWidget("Total Members", "${data.groupMembers!.length}"),



                    data.user!.id == Api.singleton.sp.read("id")?Container():
                    CustomButton(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      color: DynamicColors.primaryColorRed,
                      text: "Report Group",
                      onTap: () {
                        Get.back();
                       controller.reportPost(postId: data.id,type: "group");
                      },
                      borderColor: DynamicColors.primaryColorRed,
                      style: poppinsSemiBold(
                          color: DynamicColors.whiteColor, fontSize: 16),
                    ),

                    data.isJoined != "joined"?Container():  SizedBox(
                      height: 20,
                    ),
                    data.isJoined != "joined"?Container():  CustomButton(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      color: DynamicColors.primaryColor.withOpacity(0.3),
                      text: "Members",
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.membersClass, arguments: {
                          "members": data.groupMembers!,
                          "groupID": data.id,
                          "isAdmin":
                          data.user!.id == Api.singleton.sp.read("id")
                              ? true
                              : false
                        });
                      },
                      borderColor: DynamicColors.primaryColor.withOpacity(0.3),
                      style: poppinsSemiBold(
                          color: DynamicColors.primaryColor, fontSize: 16),
                    ),
                    data.user!.id != Api.singleton.sp.read("id")
                        ? Container()
                        : SizedBox(
                      height: 10,
                    ),
                    data.user!.id != Api.singleton.sp.read("id")
                        ? Container()
                        : CustomButton(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      color: DynamicColors.primaryColor.withOpacity(0.3),
                      text: "Edit Group Info",
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.addGroup, arguments: {
                          "data": data,

                        });
                      },
                      borderColor:
                      DynamicColors.primaryColor.withOpacity(0.3),
                      style: poppinsSemiBold(
                          color: DynamicColors.primaryColor,
                          fontSize: 16),
                    ),
                    data.user!.id != Api.singleton.sp.read("id")
                        ? Container()
                        : SizedBox(
                      height: 10,
                    ),
                    data.user!.id != Api.singleton.sp.read("id")
                        ? Container()
                        : CustomButton(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      color: DynamicColors.primaryColor.withOpacity(0.3),
                      text: "Invitation Requests",
                      onTap: () {
                        // Get.toNamed(Routes.groupRequests);
                      },
                      borderColor:
                      DynamicColors.primaryColor.withOpacity(0.3),
                      style: poppinsSemiBold(
                          color: DynamicColors.primaryColor,
                          fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    data.isJoined != "joined"
                        ? Container()
                        : CustomButton(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      color: DynamicColors.liveColor,
                      text: "Leave Group",
                      onTap: () {
                        Get.back();
                        alertCustomMethod(context,
                            theme: DynamicColors.primaryColor,
                            titleText:data.user!.id == Api.singleton.sp.read("id")?
                                "If you leave this group, Group will be deleted"
                                : "Do you want to leave this group",
                            click: () {
                              Get.back();
                              controller.leaveGroup(data.id!);
                            },
                            click2: () {
                              Get.back();
                            },
                            buttonText: "Yes",
                            buttonText2: "No");
                      },
                      borderColor: DynamicColors.liveColor,
                      style: poppinsSemiBold(
                          color: DynamicColors.whiteColor, fontSize: 16),
                    ),
                    data.user!.id != Api.singleton.sp.read("id")
                        ? Container()
                        : SizedBox(
                      height: 10,
                    ),
                    data.user!.id != Api.singleton.sp.read("id")
                        ? Container()
                        : CustomButton(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      color: DynamicColors.liveColor,
                      text: "Delete Group",
                      onTap: () {
                        Get.back();
                        alertCustomMethod(context,
                            theme: DynamicColors.primaryColor,
                            titleText: "Do you want to delete this group",
                            click: () {
                              Get.back();
                              controller.deleteGroup(data.id!);
                            },
                            click2: () {
                              Get.back();
                            },
                            buttonText: "Yes",
                            buttonText2: "No");
                      },
                      borderColor: DynamicColors.liveColor,
                      style: poppinsSemiBold(
                          color: DynamicColors.whiteColor, fontSize: 16),
                    ),

                    // Container(
                    //   padding:
                    //       EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(5),
                    //       color: DynamicColors.primaryColor.withOpacity(0.3)),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Icon(
                    //         Icons.info,
                    //         color: DynamicColors.primaryColor,
                    //       ),
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text(
                    //         "Report inappropriate content",
                    //         style: poppinsSemiBold(
                    //             color: DynamicColors.primaryColor,
                    //             fontSize: 16),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
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
