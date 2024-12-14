import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/View/Chat/controller/chatServices.dart';
import 'package:bloodlines/View/Chat/view/stickyListView.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/userModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloodlines/View/Chat/controller/chatController.dart';
import 'package:bloodlines/View/Chat/model/chatModel.dart';
import 'package:bloodlines/View/Chat/model/inboxModel.dart';
import 'package:bloodlines/View/Chat/view/bottomTextField.dart';
import 'package:bloodlines/View/Chat/view/replyMessageWidget.dart';
import 'package:bloodlines/View/Chat/view/replyType.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/CustomAlert.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/customWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  InboxData? data = Get.arguments == null ? null : Get.arguments["data"];
  FeedController feedController = Get.find();
  UserModel? userData = Get.arguments["user"];
  int receiverID = Get.arguments["id"];
  bool isUserDeleted = Get.arguments["isUserDeleted"] ?? false;
  bool fromTimeline = Get.arguments["fromTimeline"] ?? false;

  ChatController controller = Get.find();

  getUserData() async {
    if(isUserDeleted == false){
      controller.userData =
          await feedController.getAnyUserProfile(receiverID, fromChat: true);
    }
    controller.getUserChat(
      controller.userData!.id!,
    );
    if(isUserDeleted == false){
      controller.update();
    }
  }

  @override
  void initState() {
    if (userData == null) {
      getUserData();
    } else {
      controller.userData = userData;
      if (data == null) {
        // if (userData == null) {
        controller.getUserChat(controller.userData!.id!, fromFriend: true);
        // }
      }
    }

    controller.isOnChat = true;
    controller.receiverId = receiverID;

    if (data != null) {
      controller.inboxData = data;
      controller.userData = data!.user;

      seenMessage();
    }

    if(isUserDeleted == false){
      feedController.getUnseenMessages();
    }
    super.initState();
  }

  seenMessage() async {
    if (data?.lastMessage != null) {
      InboxServices().messageSeen(inboxId: data!.lastMessage!.inboxId!);
    }
  }

  Future<bool> onWillPop() async {
    controller.isOnChat = false;
    controller.inboxData = null;
    controller.replyId = null;
    controller.replyModel = null;
    controller.userData = null;
    Get.back();
    controller.chatModel = null;
    controller.isReplying.value = false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
      onWillPop: onWillPop,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/chatBack.jpeg"), fit: BoxFit.fill)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: DynamicColors.primaryColorLight,
            centerTitle: true,
            leading: AppBarWidgets(
              onTap: () {
                onWillPop();
              },
            ),
            title: GestureDetector(
              onTap: () {
                if (controller.chatModel != null) {
                  if (controller.chatModel!.data!.items!.isNotEmpty) {
                    if (controller.userData != null) {
                      UserModel? user;
                      user = controller.userData!;

                      if(user.isUserDeleted == 0){
                        if (user.blockBy != true && user.isBlock != true) {
                          if (fromTimeline == false) {
                            Utils.routeOnTimeline(receiverID, user,
                                fromChat: fromTimeline, mustThen: true);
                          } else {
                            Get.back();
                          }
                        } else {
                          BotToast.showText(text: "User is blocked");
                        }
                      }
                    }
                  }
                } else {
                  if (userData != null) {
                    if(userData!.isUserDeleted == 0){
                      Utils.routeOnTimeline(receiverID, userData!,
                          fromChat: fromTimeline, mustThen: true);
                    }
                  }
                }
              },
              child: Row(
                children: [
                  controller.userData == null
                      ? Container()
                      : SizedBox(
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: OptimizedCacheImage(
                              imageUrl:
                                  controller.userData!.profile!.profileImage!,
                              height: 50,
                              width: 50,
                            ),
                          )),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.userData!.isUserDeleted == 1?"Deleted User":      controller.userData!.profile!.fullname!,
                        style: poppinsSemiBold(
                            color: DynamicColors.primaryColor, fontSize: 16),
                      ),
                      controller.userData!.isUserDeleted == 1?Container():   Obx(() => controller.inboxData == null
                          ? controller.userData!.userStatus!.value == true
                              ? OnlineWidget()
                              : Container()
                          : controller.userData!.typing!.value == true
                              ? Text(
                                  "typing..",
                                  style: poppinsSemiBold(
                                      color: DynamicColors.accentColor,
                                      fontSize: 13),
                                )
                              : controller.userData!.blockBy == false &&
                                      controller.userData!.isBlock == false
                                  ? controller.userData!.userStatus!.value ==
                                          true
                                      ? OnlineWidget()
                                      : Text(
                                          "Last Seen ${getLastSeenMethod(controller.userData!.updatedAt.toString())}",
                                          style: poppinsSemiBold(
                                              color: DynamicColors.accentColor,
                                              fontSize: 13),
                                        )
                                  : Container())
                    ],
                  ),
                ],
              ),
            ),
            elevation: 0,
            actions: [
              GetBuilder<ChatController>(builder: (controller) {
                return controller.chatModel == null ||
                        controller.chatModel!.data!.items!.isEmpty
                    ? Container()
                    : AppBarWidgets(
                        height: 50,
                        width: 50,
                        onTap: () {
                          alertCustomMethod(context,
                              titleText: "Do you want to clear chat",
                              buttonText: "Yes",
                              buttonText2: "No", click: () {
                            controller.clearChat();
                          }, click2: () {
                            Get.back();
                          }, theme: DynamicColors.primaryColor);
                        },
                        icon: Icons.delete,
                        color: DynamicColors.primaryColor,
                        size: 20,
                        margin: 2,
                        padding: EdgeInsets.all(8),
                      );
              }),
              SizedBox(
                width: 10,
              )
            ],
          ),
          body: GetBuilder<ChatController>(builder: (controller) {
            if (controller.chatModel == null) {
              return LoaderClass();
            }
            List<ChatMessageItem> list = controller.chatModel!.data!.items!
                .where((element) => element.isDeleted != 1)
                .toList();
            return Stack(
              children: [
                Obx(() {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: controller.isReplying.value == true ||
                                controller.fieldUpdate.value == true
                            ? 90
                            : 0),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification.metrics.pixels ==
                            scrollNotification.metrics.maxScrollExtent) {
                          print(scrollNotification);
                          if (controller.chatWait == false) {
                            if (controller.chatModel!.data!.nextPageUrl !=
                                    null &&
                                controller
                                    .chatModel!.data!.nextPageUrl?.isNotEmpty) {
                              controller.chatWait = true;
                              Future.delayed(Duration(seconds: 3), () {
                                controller.chatWait = false;
                              });
                              controller.getUserChat(receiverID,
                                  fullUrl: controller.chatModel!.data!.links);
                              return true;
                            }
                          }
                          return false;
                        } else {
                          print("min");
                        }
                        return false;
                      },
                      child: StickyListViewClass(list: list,isUserDeleted:isUserDeleted),
                    ),
                  );
                }),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: controller.userData == null
                      ? Container()
                      : Obx(() {
                          if (controller.fieldUpdate.value) {
                            return checkBlockStatus();
                          }
                          return checkBlockStatus();
                        }),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget checkBlockStatus() {
    UserModel user = controller.userData ?? UserModel.fromEmpty();
    if(user.isUserDeleted == 0){
      if (user.isBlock == false && user.blockBy == false) {
        return bottomContainer();
      } else {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            "Blocked User",
            style: poppinsBold(color: DynamicColors.primaryColor),
          ),
        );
      }
    }
    return Container();
  }

  Widget bottomContainer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (controller.isReplying.value == true)
          ReplyMessageWidget(
              onCancelReply: () {
                controller.focusNode.unfocus();
                controller.isReplying.value = false;
                controller.fieldUpdate.value = false;
                controller.replyModel = null;
                controller.replyId = null;

                controller.update();
              },
              child: ReplyType()),
        BottomTextField()
      ],
    );
  }

  // Widget _deleted(sendByMe, UserModel user) {
  //   return sendByMe == true
  //       ? Container(
  //           padding: EdgeInsets.only(left: 80, top: 10, bottom: 10),
  //           child: Align(
  //             alignment: Alignment.centerRight,
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(10),
  //               child: Container(
  //                 decoration: BoxDecoration(color: Color(0xff3c3f42)),
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(10.0),
  //                   child: Text("Message Deleted",
  //                       textAlign: TextAlign.start,
  //                       style: TextStyle(
  //                           color: Colors.white,
  //                           fontStyle: FontStyle.italic,
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w600)),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         )
  //       : Container(
  //           padding: EdgeInsets.only(right: 80, top: 10, bottom: 10),
  //           child: Align(
  //             alignment: Alignment.centerLeft,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Expanded(
  //                   flex: 2,
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(50),
  //                     child: CircleAvatar(
  //                       backgroundImage: OptimizedCacheImageProvider(
  //                         user.profile == null
  //                             ? dummyProfile
  //                             : user.profile!.profileImage!,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 10,
  //                 ),
  //                 Flexible(
  //                   flex: 10,
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(10),
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         color: DynamicColors.primaryColor,
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(10.0),
  //                         child: Text("Message Deleted",
  //                             textAlign: TextAlign.start,
  //                             style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontStyle: FontStyle.italic,
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.w600)),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  // }
}
