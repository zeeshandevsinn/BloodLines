import 'dart:convert';

import 'package:bloodlines/View/Chat/model/chatModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloodlines/View/Chat/controller/chatController.dart';
import 'package:bloodlines/View/Chat/view/replyMessageWidget.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class ReplyContainer extends StatelessWidget {
  const ReplyContainer({
    Key? key,
    required this.reply,
    required this.child,
    required this.index,
    this.length,
    this.sendByMe,
  }) : super(key: key);

  final dynamic reply;
  final int index;
  final Widget? child;
  final int? length;
  final bool? sendByMe;

  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.find();
    if (reply == null) {
      return child!;
    } else {
      switch (reply!.fileType) {
        case "video":
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  await controller.scroll(reply.id, index);
                },
                child: IntrinsicHeight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18),
                        topLeft: Radius.circular(18)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 3,
                          ),
                          Container(
                            color: Colors.green,
                            width: 5,
                          ),

                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "Video",
                            style: poppinsLight(
                                color: sendByMe!
                                    ? DynamicColors.primaryColorLight
                                    : DynamicColors.primaryColor),
                          ),
                          Spacer(),
                          // Spacer
                          //   (),
                          SizedBox(
                              width: 40,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  OptimizedCacheImage(imageUrl:
                                    // reply!.fileType == null
                                    //     ?
                                    json
                                            .decode(reply!.media![0])
                                            .thumbnail!,
                                        // : json.decode(
                                        //     reply!.media!)[0]!["thumbnail"],
                                    fit: BoxFit.fill,
                                    height: 40,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.play_arrow,
                                      color: DynamicColors.primaryColor,
                                      size: 10,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              child!,
            ],
          );

        case "image":
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  await controller.scroll(reply.id, index);
                },
                child: IntrinsicHeight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18),
                        topLeft: Radius.circular(18)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 3,
                          ),
                          Container(
                            color: Colors.green,
                            width: 5,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "Image",
                            style: poppinsLight(
                                color: sendByMe!
                                    ? DynamicColors.primaryColorLight
                                    : DynamicColors.primaryColor),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 40,
                            child: OptimizedCacheImage(imageUrl:
                              // reply!.fileType == null
                              //     ?
                              json.decode(reply!.media![0]).filename!,
                                  // : json.decode(reply!.media!)[0]!["filename"],
                              fit: BoxFit.fill,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              child!,
            ],
          );
        default:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  await controller.scroll(reply.id, index);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18),
                      topLeft: Radius.circular(18)),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                    ),
                    child: ReplyMessageWidget(
                      onCancelReply: null,
                      isText: true,
                      fromReply: true,
                      chatMessageItem: reply,
                      sender: sendByMe,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Text(
                          reply!.message!,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsLight(
                              fontSize: 14, color: DynamicColors.primaryColorLight),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              child!,
            ],
          );
      }

      // return Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //
      //     if (reply!.type == "message")
      //
      //     else
      //       reply!.type == "image"
      //           ?
      //           : reply!.type == "video"
      //               ?
      //               : Container(
      //                   width: double.infinity,
      //                   decoration: BoxDecoration(
      //                     color: Colors.black12,
      //                   ),
      //                   child: ReplyMessageWidget(
      //                     from: 2,
      //                     onCancelReply: null,
      //                     isText: true,
      //                     fromReply: true,
      //                     chatMessageItem: reply,
      //                     child: Padding(
      //                       padding: const EdgeInsets.symmetric(
      //                         vertical: 10,
      //                       ),
      //                       child: Text(
      //                         reply!.msg!,
      //                         maxLines: 1,
      //                         softWrap: true,
      //                         overflow: TextOverflow.ellipsis,
      //                         style: poppinsLight(
      //                             fontSize: 14,
      //                             color: DynamicColors.primaryColorLight),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //     child!,
      //   ],
      // );
    }
  }

  checkLength({double? l}) {
    double mult = l ?? 2.2;
    return SizedBox(
      width: length!.toDouble() * mult,
    );
  }
}
