import 'dart:convert';

import 'package:bloodlines/View/Chat/model/mediaClass.dart';
import 'package:bloodlines/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloodlines/View/Chat/controller/chatController.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class ReplyType extends StatelessWidget {
  ReplyType({Key? key}) : super(key: key);
  final ChatController _controller = Get.find();

  List<MediaClass> media = [];
  @override
  Widget build(BuildContext context) {
    if(_controller.replyModel == null) return Container();
    UserModel user =
        UserModel.fromJson(json.decode(_controller.replyModel!.user!));
    if (_controller.replyModel!.fileType != null) {
      var data = json.decode(_controller.replyModel!.media!.toString());
      media = List<MediaClass>.from(data.map((x) => MediaClass.fromJson(x)));
    }
    return SizedBox(
      // color: Colors.black12,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           user.profile == null?user.username!: user.profile!.fullname!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: poppinsLight(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 3,
          ),
          body()
        ],
      ),
    );
  }

  Widget body() {
    switch (_controller.replyModel!.fileType) {
      case "image":
        return IntrinsicHeight(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25)),
            child: Row(
              children: [
                SizedBox(
                  width: 3,
                ),
                Text(
                  "Image",
                  style: poppinsLight(color: DynamicColors.primaryColorLight),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 70,
                    child: OptimizedCacheImage(imageUrl:
                      media[0].filename!,
                      fit: BoxFit.contain,
                      height: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case "video":
        return IntrinsicHeight(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25)),
            child: Row(
              children: [
                SizedBox(
                  width: 3,
                ),
                Text(
                  "Video",
                  style: poppinsLight(color: DynamicColors.primaryColorLight),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 70,
                    child: OptimizedCacheImage(imageUrl:
                      media[0].thumbnail!,
                      fit: BoxFit.contain,
                      height: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              _controller.replyModel!.message!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  poppinsLight(fontSize: 15, color: DynamicColors.primaryColorLight),
            ),
          ),
        );
    }

    // return  _controller.replyModel!.type == null
    //         ? ClipRRect(
    //             borderRadius: BorderRadius.only(
    //                 topRight: Radius.circular(25),
    //                 topLeft: Radius.circular(25)),
    //             child: Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //               child: Text(
    //                 _controller.replyModel!.msg!,
    //                 maxLines: 1,
    //                 overflow: TextOverflow.ellipsis,
    //                 style: poppinsLight(
    //                     fontSize: 15, color: DynamicColors.primaryColor),
    //               ),
    //             ),
    //           )
    //         : _controller.replyModel!.type == "image"
    //             ? IntrinsicHeight(
    //                 child: ClipRRect(
    //                   borderRadius: BorderRadius.only(
    //                       topRight: Radius.circular(25),
    //                       topLeft: Radius.circular(25)),
    //                   child: Row(
    //                     children: [
    //                       SizedBox(
    //                         width: 3,
    //                       ),
    //                       Text(
    //                         "Image",
    //                         style:
    //                             poppinsLight(color: DynamicColors.primaryColor),
    //                       ),
    //                       Spacer(),
    //                       Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: SizedBox(
    //                           width: 70,
    //                           child: OptimizedCacheImage(imageUrl:
    //                             media[0].filename!,
    //                             fit: BoxFit.fill,
    //                             height: 40,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               )
    //             : _controller.replyModel!.type == "video"
    //                 ? IntrinsicHeight(
    //                     child: ClipRRect(
    //                       borderRadius: BorderRadius.only(
    //                           topRight: Radius.circular(25),
    //                           topLeft: Radius.circular(25)),
    //                       child: Row(
    //                         children: [
    //                           SizedBox(
    //                             width: 3,
    //                           ),
    //                           Text(
    //                             "Video",
    //                             style: poppinsLight(
    //                                 color: DynamicColors.primaryColor),
    //                           ),
    //                           Spacer(),
    //                           Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: SizedBox(
    //                               width: 70,
    //                               child: OptimizedCacheImage(imageUrl:
    //                                 media[0].thumbnail!,
    //                                 fit: BoxFit.fill,
    //                                 height: 40,
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   )
    //                 : ClipRRect(
    //                     borderRadius: BorderRadius.only(
    //                         topRight: Radius.circular(25),
    //                         topLeft: Radius.circular(25)),
    //                     child: Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: Row(
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           Icon(
    //                             FontAwesome.file_pdf,
    //                             color: Color(0xffd51820),
    //                           ),
    //                           SizedBox(
    //                             width: 5,
    //                           ),
    //                           Text(
    //                             _controller.replyModel!.messageType!,
    //                             style: poppinsLight(
    //                               fontSize: 10,
    //                               fontWeight: FontWeight.w300,
    //                               color: DynamicColors.businessGrey,
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                   );
  }
}
