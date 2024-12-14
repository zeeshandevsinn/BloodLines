import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/customWidget.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/newsFeed/model/feelingModel.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/View/newsFeed/view/post/newPost.dart';
import 'package:bloodlines/View/newsFeed/view/post/postMoreDetails.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/userModel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostClass extends StatelessWidget {
  PostClass({
    super.key,
    required this.result,
    required this.index,
    this.fromSearch = false,
    this.fromBottom = false,
    this.fromSave = false,
    this.fromTimeline = false,
    this.fromFriendTimeline = false,
    this.fromDetails = false,
    this.fromGroup = false,
  });

  final PostModel result;
  final bool fromSearch;
  final bool fromBottom;
  final bool fromSave;
  final bool fromTimeline;
  final bool fromFriendTimeline;
  final bool fromDetails;
  final bool fromGroup;
  final int index;
  final FeedController controller = Get.find();
  RxInt current = 0.obs;

  int getIndexMethod() {
    return controller.postsData!.postModel!
        .indexWhere((element) => element.id == result.id);
  }

  @override
  Widget build(BuildContext context) {
    if(result.isReported == 1){
      return Container();
    }
    // controller.postData = result;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5,),
      child: Column(
        children: [
          Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
              child: VisibilityDetector(
                key: Key(index.toString()),
                onVisibilityChanged: (VisibilityInfo info) async {
                  print(info.visibleFraction);
                  if (info.visibleFraction == 1) {
                    if (Api.singleton.sp.read("posIndex") == null) {
                      Api.singleton.sp.write("posIndex", index);
                      // controller.postLikeSocket(
                      //   result.id,
                      //   index,
                      //   fromSearch: fromSearch,
                      //   fromBottom: fromBottom,
                      //   fromGroup: fromGroup,
                      //   fromSave: fromSave,
                      //   fromTimeline: fromTimeline,
                      // );
                    } else {
                      if (Api.singleton.sp.read("posIndex") != index) {
                        Api.singleton.sp.write("posIndex", index);
                        // controller.postLikeSocket(
                        //   result.id,
                        //   index,
                        //   fromSearch: fromSearch,
                        //   fromBottom: fromBottom,
                        //   fromGroup: fromGroup,
                        //   fromSave: fromSave,
                        //   fromTimeline: fromTimeline,
                        // );
                      }
                    }
                    for (int index = 0; index < result.media!.length; index++) {
                      if (result.media![index].mediaType == "video") {}
                    }
                    // controller.currentIndex.value = positionalIndex;
                  } else {
                    for (int index = 0; index < result.media!.length; index++) {
                      if (result.media![index].mediaType == "video") {
                        // result.media![index].betterPlayerController.v
                      }
                    }
                  }
                },
                child: PostMoreDetails(
                  result: result,
                  index: index,
                  fromSearch: fromSearch,
                  fromBottom: fromBottom,
                  fromDetails: fromDetails,
                  fromSave: fromSave,
                  fromGroup: fromGroup,
                  fromTimeline: fromTimeline,
                  fromFriendTimeline: fromFriendTimeline,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),

          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}

class PostNameDetails extends StatelessWidget {
  PostNameDetails({
    super.key,
    required this.user,
    required this.result,
    this.fromShare = false,
    this.fromSearch = false,
    this.fromDetails = false,
    this.fromGroup = false,
    this.fromSave = false,
    this.fromTimeline = false,
    this.fromFriendTimeline = false,
    required this.index,
  });

  final UserModel user;
  final PostModel result;
  final bool fromShare;
  final bool fromSearch;
  final bool fromDetails;
  final bool fromSave;
  final bool fromGroup;
  final bool fromTimeline;
  final bool fromFriendTimeline;
  final int? index;

  @override
  Widget build(BuildContext context) {
    double width = Utils.width(context);
    // double height = Utils.height(context);
    if (fromGroup == false && result.group != null) {
      return Row(
        children: [
          InkWell(
            onTap: () {
              Get.toNamed(Routes.groupDetails,
                  arguments: {"id": result.group!.id});
            },
            child: Stack(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: DynamicColors.accentColor)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: OptimizedCacheImage(
                      imageUrl: result.group!.photo!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: DynamicColors.accentColor)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: OptimizedCacheImage(
                        imageUrl: user.profile!.profileImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          SizedBox(
            width: width - 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.groupDetails,
                        arguments: {"id": result.group!.id});
                  },
                  child: Text(
                    result.group!.name!,
                    style: poppinsSemiBold(
                        fontSize: 15, color: DynamicColors.textColor),
                  ),
                ),
                RichText(
                  text: TextSpan(children: feelingsSpan(fontSize: 10)),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      getTimeMethod(result.createdAt!.toString()),
                      style: poppinsLight(
                          fontSize: 10,
                          color: DynamicColors.accentColor.withOpacity(0.8)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          fromShare == true ||
                  fromSearch == true ||
                  fromDetails == true ||
                  fromSave == true
              ? Container()
              : InkWell(
                  onTap: () {
                    Get.bottomSheet(BottomSheetPostEdit(
                      result: result,
                    ));
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: DynamicColors.textColor,
                  ),
                )
        ],
      );
    }
    return Row(
      children: [
        InkWell(
          onTap: () {
            Utils.onNavigateTimeline(user.id!);
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: DynamicColors.accentColor)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: OptimizedCacheImage(
                imageUrl: user.profile!.profileImage!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        SizedBox(
          width: width - 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(children: feelingsSpan()),
              ),
              // result.postActivity != null ||
              //         result.checkIn != null ||
              //         result.postFor != null
              //     ? Container()
              //     :
              Row(
                children: [
                  Text(
                    getTimeMethod(result.createdAt!.toString()),
                    style: poppinsLight(
                        fontSize: 10,
                        color: DynamicColors.accentColor.withOpacity(0.8)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    getIcon(result),
                    color: DynamicColors.accentColor,
                    size: 15,
                  )
                ],
              ),
            ],
          ),
        ),
        Spacer(),
        // result.user!.id != Api.singleton.sp.read("id")
        //     ? Container()
        //     :
    fromShare == true
                ? Container()
                : GestureDetector(
                    onTap: () {
                      Get.bottomSheet(BottomSheetPostEdit(
                        result: result,
                      ));
                    },
                    child: Icon(
                      Icons.more_vert,
                    ))
        // CustomButton(
        //   color: DynamicColors.primaryColorRed,
        //   text: "Follow",
        //   borderColor: DynamicColors.primaryColorRed,
        //   borderRadius: BorderRadius.circular(5),
        //   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        //   style: montserratLight(
        //       fontSize: 10, color: DynamicColors.primaryColorLight),
        // )
      ],
    );
  }

  List<InlineSpan> feelingsSpan({double fontSize = 15}) {
    return [
      TextSpan(
        text: user.profile!.fullname!,
        style: poppinsSemiBold(fontSize: fontSize),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            Utils.onNavigateTimeline(user.id!);
          },
      ),
      result.parentPost == null
          ? TextSpan()
          : TextSpan(
              text: " shared a post ",
              style: poppinsSemiBold(
                  color: DynamicColors.accentColor.withOpacity(0.6),
                  fontSize: fontSize)),
      result.postActivity == null
          ? TextSpan()
          : TextSpan(
              text: " is ",
              style: poppinsSemiBold(
                  color: DynamicColors.accentColor.withOpacity(0.6),
                  fontSize: fontSize)),
      result.postActivity == null
          ? TextSpan()
          : feelingList.any((element) =>
                  element.name!.toLowerCase() ==
                  result.postActivity.toString().toLowerCase())
              ? TextSpan(
                  text: "feeling ",
                  style: poppinsRegular(
                      color: DynamicColors.accentColor.withOpacity(0.6),
                      fontSize: fontSize))
              : TextSpan(),
      result.postActivity == null
          ? TextSpan()
          : TextSpan(
              text: result.postActivity.toString().capitalize!,
              style: poppinsBold(
                  color: DynamicColors.primaryColor, fontSize: fontSize)),
      result.location!.address == null
          ? TextSpan()
          : result.postActivity != null
              ? TextSpan()
              : TextSpan(
                  text: " is",
                  style: poppinsRegular(
                      color: DynamicColors.accentColor.withOpacity(0.6),
                      fontSize: fontSize)),
      result.location!.address == null
          ? TextSpan()
          : TextSpan(
              text: " at ",
              style: poppinsRegular(
                  color: DynamicColors.accentColor.withOpacity(0.6),
                  fontSize: fontSize)),
      result.location!.address == null
          ? TextSpan()
          : TextSpan(
              text: result.location!.address,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (Platform.isAndroid) {
                    final AndroidIntent intent = AndroidIntent(
                        action: 'action_view',
                        data: Uri.encodeFull(
                            "https://www.google.com/maps/search/?api=1&query=${result.location!.latitude},${result.location!.longitude}"),
                        package: 'com.google.android.apps.maps');
                    intent.launch();
                  } else {
                    String url =
                        "https://www.google.com/maps/search/?api=1&query=${result.location!.latitude},${result.location!.longitude}";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }
                  }
                },
              style: poppinsBold(
                  color: DynamicColors.primaryColor, fontSize: fontSize)),
      result.tag == null
          ? TextSpan()
          : result.location!.address != null
              ? TextSpan()
              : result.postActivity != null
                  ? TextSpan()
                  : TextSpan(
                      text: " is",
                      style: poppinsRegular(
                          color: DynamicColors.accentColor.withOpacity(0.6),
                          fontSize: 15)),
      result.tag == null
          ? TextSpan()
          : result.tag!.people!.isEmpty
              ? TextSpan()
              : TextSpan(
                  text: " with ",
                  style: poppinsRegular(
                      color: DynamicColors.accentColor.withOpacity(0.6),
                      fontSize: 15)),
      result.tag == null
          ? TextSpan()
          : result.tag!.people!.isEmpty
              ? TextSpan()
              : getUsers(result.tag!),

      result.tag == null
          ? TextSpan()
          : result.tag!.pedigrees!.isEmpty
              ? TextSpan()
              : TextSpan(
                  text: result.tag!.people!.isEmpty
                      ? " with pedigrees "
                      : " and with pedigrees ",
                  style: poppinsRegular(
                      color: DynamicColors.accentColor.withOpacity(0.6),
                      fontSize: 15)),
      result.tag == null
          ? TextSpan()
          : result.tag!.pedigrees!.isEmpty
              ? TextSpan()
              : getPedigrees(result.tag!),
      // : getUsers(result.tagFriend!),
    ];
  }

  InlineSpan getUsers(Tag tagList) {
    return tagList.people!.length == 1
        ? WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: InkWell(
              onTap: () {
                if (tagList.people![0].id == Api.singleton.sp.read("id")) {
                  Get.toNamed(Routes.timeline);
                } else {
                  if (tagList.people![0].blockBy == false &&
                      tagList.people![0].isBlock == false) {
                    Get.toNamed(Routes.friendTimeline, arguments: {
                      "id": tagList.people![0].id,
                      "fromSearch": fromSearch
                    });
                  }
                }
              },
              child: Text(
                  "${tagList.people![0].profile!.fullname}", // getUsers(data.tagFriend!),
                  style: poppinsBold(
                      color: tagList.people![0].blockBy == true ||
                              tagList.people![0].isBlock == true
                          ? Colors.grey
                          : DynamicColors.primaryColor,
                      fontSize: 15)),
            ),
          )
        : tagList.people!.length == 2
            ? TextSpan(children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: InkWell(
                    onTap: () {
                      if (tagList.people![0].id ==
                          Api.singleton.sp.read("id")) {
                        Get.toNamed(Routes.timeline);
                      } else {
                        if (tagList.people![0].blockBy == false &&
                            tagList.people![0].isBlock == false) {
                          Get.toNamed(Routes.friendTimeline, arguments: {
                            "id": tagList.people![0].id,
                            "fromSearch": fromSearch
                          });
                        }
                      }
                    },
                    child: Text(
                        "${tagList.people![0].profile!.fullname}", // getUsers(data.tagFriend!),
                        style: poppinsBold(
                            color: tagList.people![0].blockBy == true ||
                                    tagList.people![0].isBlock == true
                                ? Colors.grey
                                : DynamicColors.primaryColor,
                            fontSize: 15)),
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Text(" and ",
                      style: poppinsRegular(
                          color: DynamicColors.accentColor.withOpacity(0.6),
                          fontSize: 15)),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: InkWell(
                    onTap: () {
                      if (tagList.people![1].id ==
                          Api.singleton.sp.read("id")) {
                        Get.toNamed(Routes.timeline);
                      } else {
                        if (tagList.people![1].blockBy == false &&
                            tagList.people![1].isBlock == false) {
                          Get.toNamed(Routes.friendTimeline, arguments: {
                            "id": tagList.people![1].id,
                            "fromSearch": fromSearch
                          });
                        }
                      }
                    },
                    child: Text(
                        "${tagList.people![1].profile!.fullname}", // getUsers(data.tagFriend!),
                        style: poppinsBold(
                            color: tagList.people![1].blockBy == true ||
                                    tagList.people![1].isBlock == true
                                ? Colors.grey
                                : DynamicColors.primaryColor,
                            fontSize: 15)),
                  ),
                ),
              ])
            : TextSpan(children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: InkWell(
                    onTap: () {
                      if (tagList.people![0].id ==
                          Api.singleton.sp.read("id")) {
                        Get.toNamed(Routes.timeline);
                      } else {
                        if (tagList.people![0].blockBy == false &&
                            tagList.people![0].isBlock == false) {
                          Get.toNamed(Routes.friendTimeline, arguments: {
                            "id": tagList.people![0].id,
                            "fromSearch": fromSearch
                          });
                        }
                      }
                    },
                    child: Text(
                        "${tagList.people![0].profile!.fullname}", // getUsers(data.tagFriend!),
                        style: poppinsBold(
                            color: tagList.people![0].blockBy == true ||
                                    tagList.people![0].isBlock == true
                                ? Colors.grey
                                : DynamicColors.primaryColor,
                            fontSize: 15)),
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.taggedFriendListScreen,
                            arguments: {"list": tagList.people});
                      },
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: " and ",
                              style: poppinsRegular(
                                  color: DynamicColors.accentColor
                                      .withOpacity(0.6),
                                  fontSize: 15)),
                          TextSpan(
                              text: "${tagList.people!.length - 1} Others",
                              style: poppinsRegular(
                                  color: DynamicColors.primaryColor,
                                  fontSize: 15)),
                        ]),
                      )),
                ),
              ]);
  }

  InlineSpan getPedigrees(Tag tagList) {
    return tagList.pedigrees!.length == 1
        ? WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: InkWell(
              onTap: () {
                Get.toNamed(Routes.pedigreeTree,
                    arguments: {"id": tagList.pedigrees![0].id});
              },
              child: Text(
                  "${tagList.pedigrees![0].dogName}", // getUsers(data.tagFriend!),
                  style: poppinsBold(
                      color: DynamicColors.primaryColor, fontSize: 15)),
            ),
          )
        : tagList.pedigrees!.length == 2
            ? TextSpan(children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.pedigreeTree,
                          arguments: {"id": tagList.pedigrees![0].id});
                    },
                    child: Text(
                        "${tagList.pedigrees![0].dogName}", // getUsers(data.tagFriend!),
                        style: poppinsBold(
                            color: DynamicColors.primaryColor, fontSize: 15)),
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Text(" and ",
                      style: poppinsRegular(
                          color: DynamicColors.accentColor.withOpacity(0.6),
                          fontSize: 15)),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.pedigreeTree,
                          arguments: {"id": tagList.pedigrees![1].id});
                    },
                    child: Text(
                        "${tagList.pedigrees![1].dogName}", // getUsers(data.tagFriend!),
                        style: poppinsBold(
                            color: DynamicColors.primaryColor, fontSize: 15)),
                  ),
                ),
              ])
            : TextSpan(children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.pedigreeTree,
                          arguments: {"id": tagList.pedigrees![0].id});
                    },
                    child: Text(
                        "${tagList.pedigrees![0].dogName}", // getUsers(data.tagFriend!),
                        style: poppinsBold(
                            color: DynamicColors.primaryColor, fontSize: 15)),
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.taggedFriendListScreen,
                          arguments: {"list": tagList.pedigrees});
                    },
                    child: Text(" and ${tagList.pedigrees!.length - 1} Others",
                        style: poppinsRegular(
                            color: DynamicColors.accentColor.withOpacity(0.6),
                            fontSize: 15)),
                  ),
                ),
              ]);
  }

  IconData getIcon(PostModel result) {
    switch (result.audience) {
      case "public":
        return FontAwesome.globe;
      case "followers_of_followers":
        return Icons.people;
      case "followers":
        return Icons.person;
      default:
        return Elusive.group;
    }
  }
}

class BottomSheetPostEdit extends StatelessWidget {
  BottomSheetPostEdit({super.key, required this.result});
  final PostModel result;
  final FeedController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: Utils.width(context),
          decoration: BoxDecoration(
              color: DynamicColors.primaryColorLight,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black.withOpacity(0.9),
                  blurRadius: 10,
                ),
              ]),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Container(
                    height: 5,
                    width: Utils.width(context) / 8,
                    color: DynamicColors.primaryColor,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                result.user!.id == Api.singleton.sp.read("id")
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 4),
                        child: InkWell(
                          onTap: () {
                            Get.back();
                            controller.reportPost(postId: result.id,type: "post",commentPostId: result.group?.id);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.report,
                                color: DynamicColors.primaryColor,
                                size: Utils.height(context) / 50,
                              ),
                              SizedBox(
                                width: Utils.width(context) / 30,
                              ),
                              Text(
                                "Report Post",
                                style: poppinsRegular(
                                    color: DynamicColors.textColor,
                                    fontSize: Utils.height(context) / 60),
                              )
                            ],
                          ),
                        ),
                      ),
                result.user!.id != Api.singleton.sp.read("id")
                    ? Container()
                    : Divider(
                        color: DynamicColors.textColor,
                        height: 15,
                      ),
                result.user!.id != Api.singleton.sp.read("id")
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 4),
                        child: InkWell(
                          onTap: () {
                            Get.back();
                            controller.deletePost(postId: result.id);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: DynamicColors.primaryColor,
                                size: Utils.height(context) / 50,
                              ),
                              SizedBox(
                                width: Utils.width(context) / 30,
                              ),
                              Text(
                                "Delete Post",
                                style: poppinsRegular(
                                    color: DynamicColors.textColor,
                                    fontSize: Utils.height(context) / 60),
                              )
                            ],
                          ),
                        ),
                      ),
                result.user!.id != Api.singleton.sp.read("id")
                    ? Container()
                    : Divider(
                        color: DynamicColors.textColor,
                        height: 15,
                      ),
                result.user!.id != Api.singleton.sp.read("id")
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 4),
                        child: InkWell(
                          onTap: () {
                            Get.back();
                            if (result.parentId == 0) {
                              Get.toNamed(Routes.newPost,
                                  arguments: {"data": result});
                            } else {
                              Get.bottomSheet(
                                      SizedBox(
                                        height: Utils.height(context) / 1.2,
                                        child: NewPost(
                                          parentPostId: result.parentId == 0
                                              ? result.id
                                              : result.parentId,
                                          fromShare: true,
                                          isUpdate: true,
                                          newData: result,
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
                                controller.taggedUserList.clear();
                                controller.taggedPedigreeList.clear();
                                controller.media.clear();
                                controller.fileList.clear();
                                controller.audience.value = "public";
                                controller.mentionedUsersIds.clear();
                                controller.tempList.clear();
                                controller.taggedUser.clear();
                                controller.taggedPedigree.clear();
                                postLocation = Rxn<PostLocation>();
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: DynamicColors.primaryColor,
                                size: Utils.height(context) / 50,
                              ),
                              SizedBox(
                                width: Utils.width(context) / 30,
                              ),
                              Text(
                                "Edit Post",
                                style: poppinsRegular(
                                    color: DynamicColors.textColor,
                                    fontSize: Utils.height(context) / 60),
                              )
                            ],
                          ),
                        ),
                      ),
                result.user!.id != Api.singleton.sp.read("id")
                    ? Container()
                    : Divider(
                        color: DynamicColors.textColor,
                        height: 15,
                      ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
