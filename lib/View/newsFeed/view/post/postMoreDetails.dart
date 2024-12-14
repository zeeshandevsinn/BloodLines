// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:ui' as ui;
import 'package:bloodlines/View/newsFeed/data/feedComponentData.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/View/newsFeed/view/post/newPost.dart';
import 'package:bloodlines/View/newsFeed/view/post/postDetails.dart';
import 'package:bloodlines/View/newsFeed/view/post/postMediaWidget.dart';
import 'package:bloodlines/View/newsFeed/view/post/postWidget.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:like_button/like_button.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class PostMoreDetails extends StatelessWidget {
  PostMoreDetails({
    Key? key,
    required this.result,
    // required this.positionalIndex,
    this.fromSearch = false,
    this.fromBottom = false,
    this.fromSave = false,
    this.fromGroup = false,
    this.fromTimeline = false,
    this.fromDetails = false,
    this.fromFriendTimeline = false,
    required this.index,
  }) : super(key: key);

  final PostModel result;

  // final int positionalIndex;
  final bool fromSearch;
  final bool fromBottom;
  final bool fromSave;
  final bool fromGroup;
  final bool fromDetails;
  final bool fromTimeline;
  final bool fromFriendTimeline;
  final int index;
  final CarouselController carouselController = CarouselController();
  final FeedController controller = Get.find();
  RxInt current = 0.obs;
  FeedComponentData feedData = FeedComponentData();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostNameDetails(
          user: result.user!,
          result: result,
          fromSearch: fromSearch,
          fromSave: fromSave,
          index: index,
        ),
        SizedBox(
          height: 15,
        ),
        if (result.content != null)
          result.backgroundColor == "0"
              ? feedData.markdownBody(
                  result.content!, context, poppinsRegular(fontSize: 15),
                  selectable: false)
              : Container(
                  height: Utils.height(context) / 3,
                  width: Utils.width(context),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(result.backgroundColor!.contains("#")
                        ? int.parse(result.backgroundColor!.split("#")[1])
                        : int.parse(result.backgroundColor!)),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: feedData.markdownBody(
                            result.content!,
                            context,
                            poppinsRegular(
                              fontSize: 15,
                              color: (DynamicColors.whiteColor.value -
                                          int.parse(result.backgroundColor!
                                                  .contains("#")
                                              ? "4900000"
                                              : result.backgroundColor!)) <=
                                      5900000
                                  ? DynamicColors.black
                                  : DynamicColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        SizedBox(
          height: 5,
        ),
        result.parentPost != null
            ? Container()
            : result.media!.isEmpty
                ? Container()
                : Column(
                    children: [
                      CarouselClass(
                        carouselController: carouselController,
                        result: result,
                        current: current,
                        controller: controller,
                        // positionalIndex: positionalIndex,
                        fromSearch: fromSearch,
                        fromBottom: fromBottom,
                      ),
                      Container(
                        color: DynamicColors.whiteColor,
                        width: double.infinity,
                        height: 1,
                      ),
                    ],
                  ),
        result.parentId == 0 && result.parentPost == null
            ? Container()
            : result.parentId != 0 && result.parentPost == null
                ? unavailablePost(context)
                :
        result.parentPost!.user == null?
        unavailablePost(context)
            :    result.parentPost!.user!.isBlock == false && result.parentPost!.user!.blockBy == false?
        sharePostWidget(context, result.parentPost!, index)
            :unavailablePost(context)
        ,
        SizedBox(
          height: 10,
        ),
        fromSearch == true || fromBottom == true
            ? Container()
            : Row(
                children: [
                  postActions(
                    result,
                    "heart",
                    "5,233",
                    fromSave: fromSave,
                    fromGroup: fromGroup,
                    fromDetails: fromDetails,
                    fromTimeline: fromTimeline,
                    fromFriendTimeline: fromFriendTimeline,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (result.parentPost == null && result.parentId != 0) {
                        BotToast.showText(text: "Post Unavailable");
                      } else {
                        controller.getPostComments(postId: result.id);
                        Get.bottomSheet(
                          PostDetails(
                            result: result,
                            index: index,
                            fromDetails: fromDetails,
                            fromGroup: fromGroup,
                          ),
                          isScrollControlled: true,
                          enableDrag: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30))),
                        ).then((value) {
                          controller.commentClear();
                        });
                      }
                    },
                    child: postActions(
                      result,
                      "assets/comment.png",
                      result.commentsCount!
                          .value, // result.postCommentsCount!.value,
                      fromSave: fromSave,
                      fromGroup: fromGroup,
                      fromDetails: fromDetails,
                      fromTimeline: fromTimeline,
                      fromFriendTimeline: fromFriendTimeline,
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        if (result.parentPost == null && result.parentId != 0) {
                          BotToast.showText(text: "Post Unavailable");
                        } else {
                          Get.bottomSheet(
                                  SizedBox(
                                    height: Utils.height(context) / 1.2,
                                    child: NewPost(
                                      parentPostId: result.parentId == 0
                                          ? result.id
                                          : result.parentId,
                                      fromShare: true,
                                      fromGroup: fromGroup,
                                      groupData: result.group,
                                    ),
                                  ),
                                  persistent: true,
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  ignoreSafeArea: false)
                              .then((value) {
                            controller.backgroundColor.value =
                                DynamicColors.primaryColorLight.value;
                            controller.postTextController.clear();
                            controller.audience.value = "public";
                            controller.media.clear();
                            controller.tempList.clear();
                            controller.fileList.clear();
                          });
                        }
                      },
                      child: postActions(
                        result,
                        "assets/share.png",
                        0, //result.postShareCount!.value,
                        fromSave: fromSave,
                        fromGroup: fromGroup,
                        fromDetails: fromDetails,
                        fromTimeline: fromTimeline,
                        fromFriendTimeline: fromFriendTimeline,
                      )

                      // Obx(() {
                      //   return postActions(
                      //     result,
                      //     "assets/share.png",
                      //     283, //result.postShareCount!.value,
                      //     fromSave: fromSave,
                      //     fromGroup: fromGroup,
                      //     fromDetails: fromDetails,
                      //     fromTimeline: fromTimeline,
                      //   );
                      // })

                      ),
                  Spacer(),
                  // InkWell(
                  //   onTap: () {
                  //     controller.likesData = Rxn(LikesData());
                  //     controller.likesInfo(postID: result.id.toString());
                  //     Get.toNamed(Routes.likeInfo);
                  //   },
                  //   child: Obx(() => result.postLikeCount!.value == 0
                  //       ? Container()
                  //       : Text(
                  //           "${result.postLikeCount!.value} ${result.postLikeCount!.value == 1 ? 'like' : 'likes'}",
                  //           style: poppinsRegular(fontSize: 15),
                  //         )),
                  // )
                ],
              ),

      ],
    );
  }

  Widget sharePostWidget(BuildContext context, PostModel result, index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.carouselSliderDetails, arguments: {
          "result": result,
          // "positionalIndex": positionalIndex,
          "fromSearch": fromSearch,
          "fromSave": fromSave,
          "fromTimeline": fromTimeline,
          "fromGroup": fromGroup,
          "fromDetails": fromDetails,
          "fromBottom": fromBottom,
          "fromFriendTimeline": fromFriendTimeline,
          "controller": controller,
          "index": index,
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
              border:
                  Border.all(color: DynamicColors.textColor.withOpacity(0.5))),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostNameDetails(
                  user: result.user!,
                  result: result,
                  fromShare: true,
                  index: index,
                ),
                SizedBox(
                  height: 15,
                ),
                if (result.content != null)
                  result.backgroundColor == "0"
                      ? feedData.markdownBody(result.content!, context,
                          poppinsRegular(fontSize: 15),
                          selectable: false)
                      : Container(
                          height: Utils.height(context) / 3,
                          width: Utils.width(context),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(int.parse(result.backgroundColor!)),
                          ),
                          child: Center(
                            child: SingleChildScrollView(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: feedData.markdownBody(
                                    result.content!,
                                    context,
                                    poppinsRegular(
                                      fontSize: 15,
                                      color: (DynamicColors.whiteColor.value -
                                                  int.parse(result
                                                      .backgroundColor!)) <=
                                              5900000
                                          ? DynamicColors.black
                                          : DynamicColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                // feedData.markdownBody(
                //     result.content!, context, poppinsRegular(fontSize: 15),
                //     selectable: false),
                SizedBox(
                  height: 5,
                ),
                result.media!.isEmpty
                    ? Container()
                    : CarouselClass(
                        carouselController: carouselController,
                        result: result,
                        current: current,
                        controller: controller,
                        // positionalIndex: positionalIndex,
                        fromSearch: fromSearch,
                        fromBottom: fromBottom,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget unavailablePost(context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Text(
        "Post is unavailable",
        style: poppinsRegular(
            color: DynamicColors.primaryColor,
            fontSize: Utils.height(context) / 45,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CarouselClass extends StatelessWidget {
  const CarouselClass({
    super.key,
    required this.carouselController,
    required this.result,
    required this.current,
    required this.controller,
    // required this.positionalIndex,
    required this.fromSearch,
    required this.fromBottom,
  });

  // final int positionalIndex;
  final bool fromSearch;
  final bool fromBottom;
  final CarouselController carouselController;
  final PostModel result;
  final RxInt current;
  final FeedController controller;

  Future<ui.Image> _getImage(String url) async {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    Image image = Image.network(url);

    image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool isSync) {
      print(info.image.height);
      // print(Utils.height(context));
      completer.complete(info.image);
    }));

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        result.media!.length == 1 && result.media![0].mediaType == "image"
            ? FutureBuilder<ui.Image>(
                future: _getImage(result.media![0].media!),
                builder:
                    (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
                  if (!snapshot.hasData) return Container();
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.photo,
                          arguments: {"image": result.media![0].media!});
                    },
                    child: OptimizedCacheImage(
                      imageUrl: result.media![0].media!,
                      fit: (double.parse(snapshot.data!.height.toString())) >
                              1000
                          ? BoxFit.cover
                          : BoxFit.contain,
                      height: (double.parse(snapshot.data!.height.toString())) >
                              1000
                          ? Utils.height(context) / 1.5
                          : null,
                      width: Utils.width(context),
                    ),
                  );
                })
            : SizedBox(
                height: Utils.height(context) / 2.5,
                child: buildCarouselSlider()),
        result.media!.length == 1
            ? Container()
            : Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: result.media!.asMap().entries.map((entry) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => carouselController.animateToPage(entry.key),
                      child: Obx(() {
                        return Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? DynamicColors.primaryColorRed
                                      : DynamicColors.primaryColorRed
                                          .withOpacity(0.5))
                                  .withOpacity(
                                      current.value == entry.key ? 0.9 : 0.4)),
                        );
                      }),
                    );
                  }).toList(),
                ),
              ),
      ],
    );
  }

  CarouselSlider buildCarouselSlider() {
    return CarouselSlider.builder(
        carouselController: carouselController,
        itemCount: result.media!.length,
        options: CarouselOptions(
          height: double.infinity,
          // aspectRatio: 16 / 9,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: false,
          reverse: false,
          autoPlay: false,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: false,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index, reason) async {
            current.value = index;
          },
        ),
        itemBuilder: (BuildContext context, int index, int pageViewIndex) {
          return PostMediaWidget(
            postMedia: result.media![index],
            result: result,
            noHit: true,
            index: index,
          );
        });
  }
}

Row postActions(
  PostModel result,
  image,
  count, {
  required bool fromDetails,
  required bool fromSave,
  required bool fromGroup,
  required bool fromTimeline,
  required bool fromFriendTimeline,
}) {
  FeedController controller = Get.find();
  if (fromSave == true) {
    print('a');
  }

  return Row(
    children: [
      image == "heart"
          ? Obx(() {
              return LikeButton(
                circleColor: CircleColor(
                    start: DynamicColors.primaryColor,
                    end: DynamicColors.primaryColor.withOpacity(0.5)),
                bubblesColor: BubblesColor(
                    dotPrimaryColor: DynamicColors.primaryColor,
                    dotSecondaryColor:
                        DynamicColors.primaryColor.withOpacity(0.5)),
                size: 20,
                onTap: (bool isLiked) async {
                  if (result.parentPost == null && result.parentId != 0) {
                    BotToast.showText(text: "Post Unavailable");
                    return false;
                  } else {
                    controller.likeDislike(
                      postID: result.id.toString(),
                      fromDetails: fromDetails,
                      fromSave: fromSave,
                      fromTimeline: fromTimeline,
                      fromGroup: fromGroup,
                      fromFriendTimeline: fromFriendTimeline,
                      reaction: isLiked == false ? "like" : "remove",
                    );
                    return !isLiked;
                  }
                },
                likeBuilder: (bool isLiked) {
                  if (isLiked == true) {
                    return Image.asset(
                      "assets/like.png",  color: DynamicColors.primaryColorRed,
                    );
                  }
                  return Image.asset(
                    "assets/like.png",
                  );
                },
                isLiked: result.isLike!.value,
                likeCount: result.totalLikes!.value == 0
                    ? null
                    : result.totalLikes!.value,
              );
            })
          : Image.asset(
              image,
              height: 20,
              // height: 50,
            ),
      SizedBox(
        width: 3,
      ),
      image == "heart"
          ? Container()
          : Text(
              count == 0 ? "" : count.toString(),
              style: poppinsLight(fontSize: 12, color: DynamicColors.textColor),
            ),
      SizedBox(
        width: 40,
      ),
    ],
  );
}
