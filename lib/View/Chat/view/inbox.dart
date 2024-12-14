import 'package:bloodlines/Components/Dummy.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/dividerClass.dart';
import 'package:bloodlines/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:bloodlines/View/Chat/controller/chatController.dart';
import 'package:bloodlines/View/Chat/model/inboxModel.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/customWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class Inbox extends StatelessWidget {
  Inbox({super.key});

  ChatController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColors.primaryColorLight,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: AppBarWidgets(),
        title: Text(
          "Chats",
          style:
              poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 28),
        ),
        actions: [
          AppBarProfileWidget(),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      body: GetBuilder<ChatController>(builder: (controller) {
        return controller.inbox == null
            ? LoaderClass()
            : Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 20),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.chooseFriends);
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: DynamicColors.primaryColor),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 10,
                              child: Icon(
                                Icons.mode_edit,
                                color: DynamicColors.primaryColorLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      DividerClass(),
                      ListView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: controller.inbox!.data!.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            InboxData inboxData =
                                controller.inbox!.data![index];
                            UserModel user;
                            if(inboxData.user != null){
                              user = inboxData.user!;
                            }else{
                              user = UserModel.fromDeleted();
                            }
                            controller.socket!.off('typing-${inboxData.inboxId}');
                            controller.socket!.on('typing-${inboxData.inboxId}',
                                (data) {
                              inboxData.user!.typing!.value = data["typing"];
                              if (data["typing"] == false) {
                                inboxData.user!.typing!.value = data["typing"];
                              }
                            });
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.userData = inboxData.user!;
                                    controller.inboxId =
                                        inboxData.lastMessage?.inboxId;
                                    controller.messageSeen(controller.inboxId);
                                    Get.toNamed(Routes.chatScreen, arguments: {
                                      "data": inboxData,
                                      "isUserDeleted": user.isUserDeleted == 1?true:false,
                                      "id": inboxData.user!.id,
                                    })!
                                        .then((value) => controller.getInbox());
                                  },
                                 child: Slidable(
                                    key: const ValueKey(0),
                                    startActionPane: ActionPane(
                                      motion: const ScrollMotion(),

                                      // dismissible: DismissiblePane(onDismissed: () {}),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            controller.deleteInbox(
                                                inboxData.lastMessage!.inboxId);
                                          },
                                          flex: 8,
                                          backgroundColor:
                                              DynamicColors.primaryColorLight,
                                          foregroundColor:
                                              DynamicColors.primaryColorLight,
                                          icon: Icons.delete_outline,
                                          // imageIcon: Container(
                                          //   decoration: BoxDecoration(
                                          //     shape: BoxShape.circle,
                                          //     color: DynamicColors.primaryColor,
                                          //   ),
                                          //   child: Padding(
                                          //     padding:
                                          //         const EdgeInsets.all(8.0),
                                          //     child: ImageIcon(AssetImage(
                                          //         "assets/delete.png")),
                                          //   ),
                                          // ),
                                        ),
                                      ],
                                    ),
                                    child: Pad(
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: OptimizedCacheImage(
                                                imageUrl:
                                                user.isUserDeleted == 1?
                                                dummyProfile
                                                    :   user.profile!.profileImage!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                             user.isUserDeleted == 1?
                                                 "Deleted User"
                                                 :   user.profile!.fullname!,
                                                style: poppinsRegular(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),

                                              user.isUserDeleted == 1?
                                              Container()
                                                  :   Obx(() => inboxData.user!.typing!.value == true
                                                  ? Text(
                                                "typing..",
                                                style: poppinsLight(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey,
                                              )):
                                              inboxData.lastMessage == null
                                                  ? Container()
                                                  : messageType(
                                                  context, inboxData)),
                                            ],
                                          ),
                                          Spacer(),
                                          Obx(
                                            () => inboxData
                                                        .unseenMessage!.value !=
                                                    0
                                                ? Container(
                                                    height: 8,
                                                    width: 8,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: DynamicColors
                                                            .primaryColor),
                                                  )
                                                : SizedBox.shrink(),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                DividerClass(),
                              ],
                            );
                          })
                    ],
                  ),
                ],
              );
      }),
    );
  }

  messageType(context, InboxData inboxData) {
    if(inboxData.lastMessage!.isDeleted == 1){
      // return Text("Message Deleted",
      //     textAlign: TextAlign.start,
      //     style: TextStyle(
      //         color: DynamicColors.accentColor.withOpacity(0.5),
      //         fontStyle: FontStyle.italic,
      //         fontSize: 12,
      //         fontWeight: FontWeight.w600));
      return Container();
    }
    if(inboxData.lastMessage!.media!.isEmpty){
      return messageWidget(context, inboxData);
    }else{
      switch (inboxData.lastMessage!.media![0].fileType) {
        case "image":
          return Row(
            children: [
              Icon(
                Icons.image,
                color: Colors.grey,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                "Image ∙ ",
                style: poppinsLight(
                    color: DynamicColors.accentColor.withOpacity(0.5),
                    fontSize: 12,fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                getTimeMethod(inboxData.lastMessage!.createdAt!.toString()),
                style: poppinsLight(
                    color: DynamicColors.accentColor.withOpacity(0.5),
                    fontSize: 12,fontWeight: FontWeight.w600),
              ),
            ],
          );
        case "video":
          return Row(
            children: [
              Icon(
                Icons.video_call,
                color: Colors.grey,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                "Video ∙ ",
                style: poppinsLight(
                    color: DynamicColors.accentColor.withOpacity(0.5),
                    fontSize: 12,fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                getTimeMethod(inboxData.lastMessage!.createdAt!.toString()),
                style: poppinsLight(
                    color: DynamicColors.accentColor.withOpacity(0.5),
                    fontSize: 12,fontWeight: FontWeight.w600),
              ),
            ],
          );
        case "audio":
          return Row(
            children: [
              Icon(
                Icons.music_note,
                color: Colors.white,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                "Audio ∙ ",
                style: poppinsLight(
                    color: DynamicColors.accentColor.withOpacity(0.5),
                    fontSize: 12,fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                getTimeMethod(inboxData.lastMessage!.createdAt!.toString()),
                style: poppinsLight(
                    color: DynamicColors.accentColor.withOpacity(0.5),
                    fontSize: 12,fontWeight: FontWeight.w600),
              ),
            ],
          );
        default:
          return messageWidget(context, inboxData);
      }
    }

  }

  SizedBox messageWidget(context, InboxData inboxData) {
    return SizedBox(
        width: Utils.width(context) / 1.7,
        child: Row(
          children: [
            Text(
              "${inboxData.lastMessage!.msg}",
              maxLines: 1,
              style: poppinsLight(
                  color: DynamicColors.accentColor.withOpacity(0.5),
                  fontSize: 12,fontWeight: FontWeight.w600),
            ),
            Text(
              " ∙ ${getTimeMethod(inboxData.lastMessage!.createdAt!.toString())}",
              style: poppinsLight(
                  color: DynamicColors.accentColor.withOpacity(0.5),
                  fontSize: 12,fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
  }
}
