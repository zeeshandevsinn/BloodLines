import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/newsFeed/model/postMedia.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:flutter/material.dart';

import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class PostMediaWidget extends StatelessWidget {
  const PostMediaWidget({
    super.key,
    required this.postMedia,
    required this.index,
    this.noHit = false,
    this.result,
  });

  final PostMedia postMedia;
  final bool noHit;
  final int index;
  final PostModel? result;

  @override
  Widget build(BuildContext context) {
    print(postMedia.mediaType);
    switch (postMedia.mediaType) {
      case "video":
        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.videoPlayerClass,
                arguments: {"type": "network", "url": postMedia.media});
          },
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 100,
                minWidth: 100,
                maxHeight:Utils.height(context)/2,
                maxWidth:Utils.width(context),
              ),
              child: Stack(
                children: [
                  SizedBox(
                    width: Utils.width(context),
                    height: Utils.height(context)/2,


                    child: OptimizedCacheImage(imageUrl:postMedia.thumbnail!,fit: BoxFit.contain,
                    ),
                  ),
                  // Image(
                  //     fit: BoxFit.contain,
                  //     width: Utils.width(context),
                  //     height: Utils.height(context)/2,
                  //     image: NetworkImage(postMedia.thumbnail!)),
                  Align(
                    alignment: Alignment.center,
                    child: Center(
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
                  )
                ],
              )),
        );
      case "audio":
        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.audioPlayerClass, arguments: {
              "url": postMedia.media,
              "type": postMedia.id == null ? "file" : "network",
            });
          },
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 100,
                minWidth: 100,
                maxHeight:Utils.height(context)/2,
                maxWidth:Utils.width(context),
              ),

              child: Container(
                decoration: BoxDecoration(color: Colors.black),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.music_note,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: DynamicColors.primaryColor, width: 2)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Icon(
                              FontAwesome5.play,
                              color: DynamicColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        );
      default:
        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.photo, arguments: {
              "image": postMedia.media!,
            });
          },
          child:  ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 100,
              minWidth: Utils.width(context),
              maxHeight:Utils.height(context)/2,
              maxWidth:Utils.width(context),
            ),
            child: OptimizedCacheImage(imageUrl:postMedia.media!,
              fit: BoxFit.contain,
              width: Utils.width(context),
            ),
          ),
        );
    }
  }
}
