// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:bloodlines/Components/Dummy.dart';
import 'package:bloodlines/View/Chat/model/mediaClass.dart';
import 'package:bloodlines/View/Chat/view/delegate.dart';
import 'package:bloodlines/userModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:bloodlines/View/Chat/controller/chatController.dart';
import 'package:bloodlines/View/Chat/model/chatModel.dart';
import 'package:bloodlines/View/Chat/view/replyContainer.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
RxDouble videoProgress = 0.0.obs;
class MessageTile extends StatelessWidget {
  MessageTile({super.key, required this.chatMessageItem, required this.index});
  ChatMessageItem chatMessageItem;
  int index;
  ChatController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    if (chatMessageItem.user == null) {
      return Container();
    }
    UserModel user = UserModel.fromJson(jsonDecode(chatMessageItem.user!));
    // ChatMessageItem chatMessageItem = chatMessageItemList[index];

    if (chatMessageItem.senderId == Api.singleton.sp.read("id")) {
      return Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(left: 80, right: 10, bottom: 10),
        child: _replyContainer(
          context,
          chatMessageItem: chatMessageItem,
          sendByMe: true,
          child: getMessageType(
              context, Color(0xff3c3f42), DynamicColors.primaryColorLight),
        ),
      );
    }

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(right: 80, left: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CircleAvatar(
                backgroundImage: OptimizedCacheImageProvider(
                  user.profile == null
                      ? dummyProfile
                      : user.profile!.profileImage!,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 10,
            child: _replyContainer(
              context,
              chatMessageItem: chatMessageItem,
              sendByMe: false,
              child: getMessageType(context, DynamicColors.primaryColor,
                  DynamicColors.primaryColorLight),
            ),
          ),
          SizedBox(
            width:    30,
          ),
        ],
      ),
    );
  }

  Widget _replyContainer(context,
      {Widget? child, ChatMessageItem? chatMessageItem, bool? sendByMe}) {
    if (chatMessageItem!.parentId == null) {
      return child!;
    } else {
      ChatMessageItem? reply = chatMessageItem.reply == null
          ? null
          : ChatMessageItem.fromJson(json.decode(chatMessageItem.reply!));
      return ReplyContainer(
        reply: reply,
        index: index,
        sendByMe: sendByMe,
        length: chatMessageItem.message == null
            ? null
            : chatMessageItem.message!.length,
        child: child,
      );
    }
  }

  Widget getMessageType(context, Color backgroundColor, Color fontColor) {
    print(chatMessageItem.fileType);
    if (chatMessageItem.media != null) {
      List<MediaClass> mediaList = List<MediaClass>.from(json
          .decode(chatMessageItem.media!)
          .map((x) => MediaClass.fromJson(x)));
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
              color: Color(0xff3c3f42),
              borderRadius: BorderRadius.circular(05)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mediaList.length == 1
                  ? mediaMethod(
                      backgroundColor, mediaList[0], fontColor, context, 0,
                      height: Utils.height(context) / 3,fileType:chatMessageItem.fileType)
                  : GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: mediaList.length <= 4 ? mediaList.length : 4,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                              crossAxisCount: 2,
                              height: mediaList.length == 2
                                  ? Utils.height(context) / 4.5
                                  : 120),
                      itemBuilder: (context, index) {
                        MediaClass media = mediaList[index];
                        return mediaMethod(
                            backgroundColor, media, fontColor, context, index,
                            height: mediaList.length == 2
                                ? Utils.height(context) / 5
                                : 100,
                            condition: mediaList.length > 4,
                            list: mediaList,fileType:chatMessageItem.fileType);
                      }),
              SizedBox(
                height: 5,
              ),
              chatMessageItem.message!.isEmpty
                  ? Container()
                  : Text(
                      chatMessageItem.message!,
                      style: poppinsRegular(fontSize: 13, color: fontColor),
                    ),
              Text(
                DateFormat.jm()
                    .format(
                        DateTime.parse(chatMessageItem.createdAt!).toLocal())
                    .toString(),
                style: poppinsRegular(fontSize: 9, color: fontColor),
              ),
            ],
          ));
    } else {
      if (chatMessageItem.parentId == null) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: backgroundColor),
          child: textWidget(fontColor),
        );
      }
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: backgroundColor),
        child: textWidget(fontColor),
      );
    }
  }

  Container mediaMethod(
      Color backgroundColor, MediaClass media, Color fontColor, context, index,
      {double? height, bool condition = false, List<MediaClass>? list, required String? fileType}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            index == 3 && condition == true
                ? GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.imageListView,
                          arguments: {"list": list});
                    },
                    child: ClipRRect(
                      child: Container(
                        height: height ?? 100,
                        width: Utils.width(context),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            image: DecorationImage(
                              image: OptimizedCacheImageProvider(
                                media.filename!.split(".").last == "mp4" ||
                                        media.filename!.split(".").last == "mov"
                                    ? media.thumbnail!
                                    : media.filename!,
                              ),
                              fit: BoxFit.cover,
                            )),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                          child: Center(
                            child: Text(
                              "+4",
                              style: poppinsRegular(
                                  color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                        // child: OptimizedCacheImage(
                        //   imageUrl:media.filename!.split(".").last == "mp4" ||
                        //       media.filename!.split(".").last == "mov"? media.thumbnail!:media.filename!,
                        //   fit: BoxFit.cover,
                        //   // color: Colors.transparent,
                        //   height:height?? 100,
                        //   width: Utils.width(context),
                        //
                        //   // height: Utils.height(context) / 4,
                        // ),
                      ),
                    ),
                  )
                : media.filename!.split(".").last == "mp4" ||
                        media.filename!.split(".").last == "mov"
                    ? fileType == "uploading"?
            Stack(
              alignment: Alignment.center,
              children: [
                Image.file(
                  File(json
                      .decode(chatMessageItem.media!)[0]!["thumbnail"]),
                  fit: BoxFit.fill,
                  color: Colors.black,
                  height: Utils.height(context) / 8,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Obx(() {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularPercentIndicator(
                            radius: 20.0,
                            lineWidth: 3.0,
                            percent: videoProgress.value,
                            progressColor: Colors.green,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Api.singleton.cancelToken.cancel();
                                controller.chatModel!.data!.items!
                                    .removeAt(index);
                                controller.clear();
                                if (Api.singleton.cancelToken
                                    .isCancelled) {
                                  Api.singleton.cancelToken =
                                      CancelToken();
                                }
                                controller.update();
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      );
                    })),
              ],
            )
                : GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.videoPlayerClass, arguments: {
                            "url": media.filename!,
                            "type": "network"
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [

                            OptimizedCacheImage(
                              imageUrl: media.thumbnail??"https://nono-c.com/wp-content/uploads/2019/03/video-placeholder-1024x577.jpg",
                              fit: BoxFit.cover,
                              height: height ?? 100,
                              width: Utils.width(context),
                              // height: Utils.height(context) / 4,
                            ),
                            Center(
                              child: Container(

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black38,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 4.0,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(Icons.play_arrow,size:30,color: Colors.white,),
                                  )),
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.photo, arguments: {
                            "image": media.filename!,
                          });
                        },
                        child: OptimizedCacheImage(
                          imageUrl: media.filename!,
                          fit: BoxFit.cover,
                          width: Utils.width(context),
                          height: height ?? 100,
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Padding textWidget(Color fontColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatMessageItem.message!,
              style: poppinsRegular(fontSize: 13, color: fontColor),
            ),
            chatMessageItem.senderId == Api.singleton.sp.read("id")
                ? Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: Text(
                          DateFormat.jm()
                              .format(DateTime.parse(chatMessageItem.createdAt!)
                                  .toLocal())
                              .toString(),
                          style: poppinsRegular(fontSize: 9, color: fontColor),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3, left: 15),
                            child: chatMessageItem.isSeen == 1
                                ? Icon(
                                    Icons.check_circle,
                                    size: 13,
                                    color: DynamicColors.primaryColorLight,
                                  )
                                : Icon(
                                    Icons.check,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                          )),
                    ],
                  )
                : Text(
                    DateFormat.jm()
                        .format(DateTime.parse(chatMessageItem.createdAt!)
                            .toLocal())
                        .toString(),
                    style: poppinsRegular(fontSize: 9, color: fontColor),
                  ),
            // Text(
            //   DateFormat.jm()
            //       .format(DateTime.parse(chatMessageItem.createdAt!).toLocal())
            //       .toString(),
            //   style: poppinsRegular(fontSize: 9, color: fontColor),
            //
            // ),
          ],
        ),
      ),
    );
  }
}
// switch (media.fileType) {
//   case "image":
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5), color: backgroundColor),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Get.toNamed(Routes.photo, arguments: {
//                   "image": media.filename!,
//                 });
//               },
//               child: OptimizedCacheImage(imageUrl:
//               media.filename!,
//                 fit: BoxFit.contain,
//                 // width: Utils.width(context) ,
//                 // height: Utils.height(context) / 4,
//               ),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             chatMessageItem.message!.isEmpty
//                 ? Container()
//                 : Text(
//               chatMessageItem.message!,
//               style: poppinsRegular(fontSize: 13, color: fontColor),
//             ),
//             Text(
//               DateFormat.jm()
//                   .format(
//                   DateTime.parse(chatMessageItem.createdAt!).toLocal())
//                   .toString(),
//               style: poppinsRegular(fontSize: 9, color: fontColor),
//             ),
//           ],
//         ),
//       ),
//     );
//   case "video":
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5), color: backgroundColor),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: GestureDetector(
//           onTap: (){
//             Get.toNamed(Routes.videoPlayerClass,arguments: {
//               "url":media.filename!,
//               "type":"network"
//             });
//           },
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   OptimizedCacheImage(imageUrl:
//                   media.thumbnail!,
//                     fit: BoxFit.contain,
//                     height: Utils.height(context) / 4,
//                   ),
//                   Align(
//                     alignment: Alignment.center,
//                     child: Icon(
//                       Icons.play_circle,
//                       color: DynamicColors.primaryColor,
//                       size: 35,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               chatMessageItem.message!.isEmpty
//                   ? Container()
//                   : Text(
//                 chatMessageItem.message!,
//                 style: poppinsRegular(fontSize: 13, color: fontColor),
//               ),
//               Text(
//                 DateFormat.jm()
//                     .format(
//                     DateTime.parse(chatMessageItem.createdAt!).toLocal())
//                     .toString(),
//                 style: poppinsRegular(fontSize: 9, color: fontColor),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   default:
//     if (chatMessageItem.parentId == null) {
//       return Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5), color: backgroundColor),
//         child: textWidget(fontColor),
//       );
//     }
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5), color: backgroundColor),
//       child: textWidget(fontColor),
//     );
// }
