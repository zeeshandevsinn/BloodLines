// ignore_for_file: must_be_immutable, invalid_use_of_protected_member

import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/CustomAlert.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/dividerClass.dart';
import 'package:bloodlines/Components/textField.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/SingletonPattern/singletonUser.dart';
import 'package:bloodlines/View/Forum/Model/forumDetailsModel.dart';
import 'package:bloodlines/View/Forum/View/forumDetails.dart';
import 'package:bloodlines/View/Forum/View/placeholder.dart';
import 'package:bloodlines/View/Pedigree/Data/pedigreeController.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/view/post/textPost.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/readmore.dart';
import 'package:bloodlines/userModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:shimmer/shimmer.dart';

class ForumRespond extends StatelessWidget {
  ForumRespond({super.key});
  ForumDetailsData forumDetailsData = Get.arguments["model"];
  int forumId = Get.arguments["forumId"] ?? 0;
  UserModel? user = SingletonUser.singletonClass.getUser;
  FeedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.model = forumDetailsData;
    return GetBuilder<FeedController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: AppBarWidgets(
              isCardType: true,
            ),
            title: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      controller.forumDetailsModel == null
                          ? controller.model!.user!.profile!.profileImage!
                          : controller.forumDetailsModel!.data!.user!.profile!
                              .profileImage!,
                      height: 40,
                      width: 40,
                    )),
                SizedBox(
                  width: 10,
                ),
                Text(
                  controller.forumDetailsModel == null
                      ? controller.model!.user!.profile!.fullname!
                      : controller
                          .forumDetailsModel!.data!.user!.profile!.fullname!,
                  style: montserratSemiBold(fontSize: 16),
                ),
              ],
            ),
            actions: [
              CustomButton(
                text: "View Profile",
                onTap: () {
                  Utils.onNavigateTimeline(controller.model!.user!.id!);
                },
                style: montserratSemiBold(fontSize: 12),
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                margin: EdgeInsets.symmetric(vertical: 10),
                borderRadius: BorderRadius.circular(5),
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Utils.width(context) / 1.1,
                        child: Text(
                          controller.forumDetailsModel != null
                              ? controller.forumDetailsModel!.data!.title!
                              : controller.model!.title!,
                          style: montserratRegular(fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${controller.forumDetailsModel != null ? controller.forumDetailsModel!.data!.responsesCount! : controller.model!.responsesCount} Respond",
                        style: montserratRegular(
                            fontSize: 12, color: DynamicColors.blue),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          "${user!.profile!.fullname}, can you answer this question?",
                          style: montserratRegular(
                              fontSize: 12, color: DynamicColors.primaryColor),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: CustomButton(
                          color: DynamicColors.blueColor.withOpacity(0.3),
                          isLong: false,
                          onTap: () {
                            Get.bottomSheet(
                                ForumBottomSheet(
                                  model: controller.model!,
                                ),
                                isScrollControlled: true);
                          },
                          borderRadius: BorderRadius.circular(4),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          borderColor: Colors.transparent,
                          style: montserratSemiBold(
                              color: DynamicColors.blueColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/forum/forumEdit.png",
                                height: 15,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Respond",
                                style: montserratRegular(
                                    fontSize: 14,
                                    color: DynamicColors.blueColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                DividerClass(
                  color: DynamicColors.accentColor.withOpacity(0.5),
                ),
                GetBuilder<FeedController>(builder: (controller) {
                  return controller.forumDetailsModel == null
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BannerPlaceholder(),
                                TitlePlaceholder(width: double.infinity),
                                SizedBox(height: 16.0),
                                ContentPlaceholder(
                                  lineType: ContentLineType.threeLines,
                                ),
                                SizedBox(height: 16.0),
                                TitlePlaceholder(width: 200.0),
                                SizedBox(height: 16.0),
                                ContentPlaceholder(
                                  lineType: ContentLineType.twoLines,
                                ),
                                SizedBox(height: 16.0),
                                TitlePlaceholder(width: 200.0),
                                SizedBox(height: 16.0),
                                ContentPlaceholder(
                                  lineType: ContentLineType.twoLines,
                                ),
                              ],
                            ),
                          ),
                        )
                      : controller.forumDetailsModel!.data!.responses!.isEmpty
                          ? Center(
                              child: Text(
                                "No Data",
                                style: poppinsBold(fontSize: 25),
                              ),
                            )
                          : ResponsesList(forumId: forumId);
                })
              ],
            ),
          ));
    });
  }
}

class ResponsesList extends StatelessWidget {
  ResponsesList({
    super.key,
    required this.forumId,
  });

  final int forumId;
  FeedController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: controller.forumDetailsModel!.data!.responses!.length,
        itemBuilder: (context, index) {
          ResponseData responseData =
              controller.forumDetailsModel!.data!.responses![index];
          if(responseData.isReported == 1){
            return Container();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.bottomSheet(ForumCommentBottomSheet(
                    model:
                        controller.forumDetailsModel!.data!.responses![index]));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                      image: NetworkImage(responseData
                                          .user!.profile!.profileImage!)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              responseData.user!.profile!.fullname!,
                              style: montserratRegular(fontSize: 12),
                            ),
                            responseData.tag== null ?Container(): (responseData.tag!.users.isEmpty &&responseData.tag!.pedigree.isEmpty  )?Container():
                            InkWell(
                              onTap: () {
                                // Get.back();
                                Get.toNamed(Routes.taggedView, arguments: {
                                  "pedigree":
                                  responseData.tag == null ? [] : responseData.tag!.pedigree,
                                  "user": responseData.tag == null ? [] : responseData.tag!.users,
                                });
                              },
                              child: Row(
                                children: [
                                  SizedBox(width: 5,),
                                  Icon(
                                    Icons.people,
                                    color: DynamicColors.primaryColorRed,
                                    size: Utils.height(context) / 50,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                             IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Get.bottomSheet(BottomSheetResponseEdit(
                                        result: responseData,
                                        responseId: responseData.id!,
                                        model: controller.model!,
                                      ));
                                      // Get.toNamed(Routes.taggedView);
                                    },
                                    icon: Icon(Icons.more_vert),
                                    color: DynamicColors.primaryColor,
                                  )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ), //Look at all
                        ReadMoreText(
                          responseData.content!,
                          style: montserratRegular(
                              fontSize: 14, color: DynamicColors.accentColor),
                          moreStyle: montserratRegular(
                              fontSize: 14,
                              color: DynamicColors.primaryColorRed),
                          lessStyle: montserratRegular(
                              fontSize: 14,
                              color: DynamicColors.primaryColorRed),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Obx(() {
                              return LikeButton(
                                onTap: (a) async {
                                  controller.responseLike(
                                      responseData.id!,
                                      responseData.isLike!.value == 0
                                          ? "like"
                                          : "remove",
                                      index,
                                      forumId);
                                  return true;
                                },

                                circleColor: CircleColor(
                                    start: DynamicColors.primaryColor,
                                    end: DynamicColors.primaryColor
                                        .withOpacity(0.5)),
                                bubblesColor: BubblesColor(
                                    dotPrimaryColor: DynamicColors.primaryColor,
                                    dotSecondaryColor: DynamicColors
                                        .primaryColor
                                        .withOpacity(0.5)),
                                size: 20,
                                likeBuilder: (bool isLiked) {
                                  if (isLiked == true) {
                                    return Image.asset(
                                      "assets/like.png",  color: DynamicColors.primaryColorRed,
                                    );
                                  }
                                  return Image.asset(
                                    "assets/like.png",
                                    color: DynamicColors.primaryColorRed,
                                  );
                                },
                                isLiked: responseData.isLike!.value == 0
                                    ? true
                                    : false,
                                // likeCount: likeCount,
                              );
                            }),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "${controller.forumDetailsModel!.data!.responses![index].comments!.length.toString()} ${controller.forumDetailsModel!.data!.responses![index].comments!.length == 1 ? 'response' : 'responses'}",
                              style: montserratLight(
                                  fontSize: 12,
                                  color: DynamicColors.accentColor
                                      .withOpacity(0.6)),
                            ),
                            Spacer(),
                            Text(
                              responseData.totalLikes!.value == 1
                                  ? '1 like'
                                  : '${responseData.totalLikes!.value} likes',
                              style: poppinsLight(
                                  fontSize: 12,
                                  color: DynamicColors.accentColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: controller.forumDetailsModel!.data!
                                .responses![index].comments!.length,
                            itemBuilder: (context, i) {

                              ResponseComment responseDataComment = controller
                                  .forumDetailsModel!
                                  .data!
                                  .responses![index]
                                  .comments![i];
                              if(responseDataComment.isReported == 1){
                                return Container();
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 5),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        responseData
                                                            .user!
                                                            .profile!
                                                            .profileImage!)),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            responseDataComment
                                                .user!.profile!.fullname!,
                                            style:
                                                montserratRegular(fontSize: 12),
                                          ),

                                          Spacer(),
                                          GestureDetector(
                                                  onTap: () {
                                                    Get.bottomSheet(
                                                        BottomSheetResponseCommentEdit(
                                                      result: responseDataComment,
                                                      type: "comment",
                                                      responseData: controller
                                                          .forumDetailsModel!
                                                          .data!
                                                          .responses![index],
                                                    ));
                                                  },
                                                  child: Icon(Icons.more_vert)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ), //Look at all
                                      ReadMoreText(
                                        responseDataComment.comment!,
                                        style: montserratRegular(
                                            fontSize: 14,
                                            color: DynamicColors.accentColor),
                                        moreStyle: montserratRegular(
                                            fontSize: 14,
                                            color:
                                                DynamicColors.primaryColorRed),
                                        lessStyle: montserratRegular(
                                            fontSize: 14,
                                            color:
                                                DynamicColors.primaryColorRed),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class ForumBottomSheet extends StatelessWidget {
  ForumBottomSheet({super.key, this.model, this.responseId});
  ForumDetailsData? model;
  int? responseId;
  FeedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedController>(builder: (logic) {
      return Wrap(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            child: Container(
              decoration: BoxDecoration(
                color: DynamicColors.primaryColorLight,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
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
                      Center(
                        child: Text(
                          "Write Response",
                          style: montserratBold(fontSize: 24),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          model!.title!,
                          style: montserratRegular(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        hint: "Write your answer",
                        controller: controller.responseController,
                        // padding: EdgeInsets.zero,
                        mainPadding: EdgeInsets.zero,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          InkWell(
                            onTap: () {
                              PedigreeController pedigree =
                                  Get.put(PedigreeController());
                              pedigree.getAllPedigrees();
                              Get.toNamed(Routes.forumTagPedigree);
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/newPost/dog.png",
                                  height: 10,
                                  width: 10,
                                ),
                                Text(
                                  "Tag Dog Pedigree",
                                  style: poppinsSemiBold(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              controller.getFollowing();
                              Get.toNamed(Routes.forumTagPeople);
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/newPost/tag.png",
                                  height: 10,
                                  width: 10,
                                ),
                                Text(
                                  "Tag People",
                                  style: poppinsSemiBold(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      pedigreeTagsMethod(),
                      SizedBox(
                        height: 30,
                      ),
                      userTagsMethod(),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: CustomButton(
                          text: responseId == null ? "Post" : "Update",
                          color: Colors.white,
                          onTap: () {
                            if (controller.responseController.text.isEmpty) {
                              BotToast.showText(text: "Empty field !!");
                            } else {
                              controller.createResponse(model!.id!,
                                  responseId: responseId);
                            }
                          },
                          isLong: false,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          borderRadius: BorderRadius.circular(5),
                          style: montserratSemiBold(
                              fontSize: 14,
                              color: DynamicColors.primaryColorRed),
                          borderColor: DynamicColors.primaryColorRed,
                        ),
                      ),
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
    });
  }

  Widget pedigreeTagsMethod() {
    return controller.forumTaggedPedigreeList.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tag Pedigree",
                style: poppinsSemiBold(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: controller.forumTaggedPedigreeList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {

                      return Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Chip(
                          label: Text(
                            controller.forumTaggedPedigreeList[index].dogName!,
                            style: poppinsRegular(fontSize: 15),
                          ),
                          backgroundColor: DynamicColors.accentColor,
                          deleteIconColor: DynamicColors.primaryColor,
                          deleteIcon: Icon(FontAwesome.cancel_circled),
                          onDeleted: () {
                            controller.forumPedigreeList.removeWhere(
                                (element) =>
                                    element ==
                                    controller
                                        .forumTaggedPedigreeList[index].id);
                            controller.forumTaggedPedigreeList.removeAt(index);
                            controller.update();
                          },
                        ),
                      );
                    }),
              ),
            ],
          );
  }

  Widget userTagsMethod() {
    return controller.forumTaggedUser.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tag People",
                style: poppinsSemiBold(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: controller.forumTaggedUser.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if( controller.forumTaggedUser[index].isReported == 1){
                        return Container();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Chip(
                          label: Text(
                            controller.forumTaggedUser[index].username!,
                            style: poppinsRegular(fontSize: 15),
                          ),
                          backgroundColor: DynamicColors.accentColor,
                          deleteIconColor: DynamicColors.primaryColor,
                          deleteIcon: Icon(FontAwesome.cancel_circled),
                          onDeleted: () {
                            controller.forumTaggedUserList.removeWhere(
                                (element) =>
                                    element ==
                                    controller.forumTaggedUser[index].id);
                            controller.forumTaggedUser.value.removeAt(index);
                            controller.update();
                          },
                        ),
                      );
                    }),
              ),
            ],
          );
  }
}

class ForumCommentBottomSheet extends StatelessWidget {
  ForumCommentBottomSheet({super.key, this.model, this.commentId});
  ResponseData? model;
  int? commentId;
  FeedController controller = Get.find();

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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Text(
                      "Write Comment",
                      style: montserratBold(fontSize: 24),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      model!.content!,
                      style: montserratRegular(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      hint: "Write your comment",
                      controller: controller.commentResponseController,
                      // padding: EdgeInsets.zero,
                      mainPadding: EdgeInsets.zero,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CustomButton(
                      text: commentId != null ? "Update" : "Post",
                      color: Colors.white,
                      onTap: () {
                        if (controller.commentResponseController.text.isEmpty) {
                          BotToast.showText(text: "Empty field !!");
                        } else {
                          controller.createComment(model!.id!, model!.topicId!,commentId:commentId);
                        }
                      },
                      isLong: false,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      borderRadius: BorderRadius.circular(5),
                      style: montserratSemiBold(
                          fontSize: 14, color: DynamicColors.primaryColorRed),
                      borderColor: DynamicColors.primaryColorRed,
                    ),
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

class BottomSheetResponseEdit extends StatelessWidget {
  BottomSheetResponseEdit(
      {super.key,
      required this.result,
      required this.model,
      required this.responseId});
  ResponseData result;
  ForumDetailsData model;
  int responseId;
  FeedController controller = Get.find();
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
                result.user!.id == Api.singleton.sp.read("id")?Container():     SizedBox(
                  height: 15,
                ),
                result.user!.id == Api.singleton.sp.read("id")?Container():     Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      // controller.deleteTopic(result.id!,topicId);

                      alertCustomMethod(context,
                          theme: DynamicColors.primaryColor,
                          titleText: "Do you want to report this response?",
                          click: () {
                        Get.back();
                        controller.reportPost(postId:result.id!, type: "response",commentPostId: model.id);
                      }, click2: () {
                        Get.back();
                      }, buttonText: "Yes", buttonText2: "No");
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
                          "Report Response",
                          style: poppinsRegular(
                              color: DynamicColors.textColor,
                              fontSize: Utils.height(context) / 60),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: DynamicColors.textColor,
                  height: 15,
                ),
                result.user!.id != Api.singleton.sp.read("id")?Container():    SizedBox(
                  height: 15,
                ),
             result.user!.id != Api.singleton.sp.read("id")?Container():   Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      // controller.deleteTopic(result.id!,topicId);

                      alertCustomMethod(context,
                          theme: DynamicColors.primaryColor,
                          titleText: "Do you want to delete this response?",
                          click: () {
                        Get.back();
                        controller.deleteResponse(result.id!, result.topicId);
                      }, click2: () {
                        Get.back();
                      }, buttonText: "Yes", buttonText2: "No");
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
                          "Delete Response",
                          style: poppinsRegular(
                              color: DynamicColors.textColor,
                              fontSize: Utils.height(context) / 60),
                        )
                      ],
                    ),
                  ),
                ),
                result.user!.id != Api.singleton.sp.read("id")?Container():      Divider(
                  color: DynamicColors.textColor,
                  height: 15,
                ),
                result.user!.id != Api.singleton.sp.read("id")?Container():    Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      controller.responseController.text = result.content ?? "";
                      controller.forumTaggedPedigreeList = result.tag!.pedigree;
                      controller.forumTaggedUser = result.tag!.users.obs;

                      controller.forumPedigreeList.addAll(controller
                          .forumTaggedPedigreeList
                          .map((element) => element.id!));
                      controller.forumTaggedUserList.addAll(controller
                          .forumTaggedUser
                          .map((element) => element.id!));

                      Get.bottomSheet(
                          ForumBottomSheet(
                              model: model, responseId: responseId),
                          isScrollControlled: true);
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
                          "Edit Response",
                          style: poppinsRegular(
                              color: DynamicColors.textColor,
                              fontSize: Utils.height(context) / 60),
                        )
                      ],
                    ),
                  ),
                ),
                result.user!.id != Api.singleton.sp.read("id")?Container():      result.tag == null?Container(): Divider(
                  color: DynamicColors.textColor,
                  height: 15,
                ),
                result.user!.id != Api.singleton.sp.read("id")?Container():       result.tag == null?Container():   Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.taggedView, arguments: {
                        "pedigree":
                            result.tag == null ? [] : result.tag!.pedigree,
                        "user": result.tag == null ? [] : result.tag!.users,
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: DynamicColors.primaryColor,
                          size: Utils.height(context) / 50,
                        ),
                        SizedBox(
                          width: Utils.width(context) / 30,
                        ),
                        Text(
                          "View Tags",
                          style: poppinsRegular(
                              color: DynamicColors.textColor,
                              fontSize: Utils.height(context) / 60),
                        )
                      ],
                    ),
                  ),
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

class BottomSheetResponseCommentEdit extends StatelessWidget {
  BottomSheetResponseCommentEdit({
    super.key,
    required this.result,
    required this.responseData,
     this.type = "response",
  });
  String? type;
  ResponseComment result;
  ResponseData responseData;
  FeedController controller = Get.find();
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
                result.user!.id == Api.singleton.sp.read("id")?Container():     SizedBox(
                  height: 15,
                ),
                result.user!.id == Api.singleton.sp.read("id")?Container():    Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      // controller.deleteTopic(result.id!,topicId);

                      alertCustomMethod(context,
                          theme: DynamicColors.primaryColor,
                          titleText: "Do you want to report this comment?",
                          click: () {
                            Get.back();
                            controller.reportPost(
                               postId: result.id!, type:type,responseType: "response",commentPostId: responseData.topicId);
                          }, click2: () {
                            Get.back();
                          }, buttonText: "Yes", buttonText2: "No");
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
                          "Report Comment",
                          style: poppinsRegular(
                              color: DynamicColors.textColor,
                              fontSize: Utils.height(context) / 60),
                        )
                      ],
                    ),
                  ),
                ),
                result.user!.id != Api.singleton.sp.read("id")?Container():      SizedBox(
                  height: 15,
                ),
                result.user!.id != Api.singleton.sp.read("id")?Container():       Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      // controller.deleteTopic(result.id!,topicId);

                      alertCustomMethod(context,
                          theme: DynamicColors.primaryColor,
                          titleText: "Do you want to delete this comment?",
                          click: () {
                        Get.back();
                        controller.deleteResponseComment(
                            result.id!, responseData.topicId);
                      }, click2: () {
                        Get.back();
                      }, buttonText: "Yes", buttonText2: "No");
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
                          "Delete Comment",
                          style: poppinsRegular(
                              color: DynamicColors.textColor,
                              fontSize: Utils.height(context) / 60),
                        )
                      ],
                    ),
                  ),
                ),
                result.user!.id != Api.singleton.sp.read("id")?Container():       Divider(
                  color: DynamicColors.textColor,
                  height: 15,
                ),
                result.user!.id != Api.singleton.sp.read("id")?Container():     Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      controller.commentResponseController.text =
                          result.comment ?? "";
                      Get.bottomSheet(
                          ForumCommentBottomSheet(
                              model: responseData, commentId: result.id),
                          isScrollControlled: true);
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
                          "Edit Comment",
                          style: poppinsRegular(
                              color: DynamicColors.textColor,
                              fontSize: Utils.height(context) / 60),
                        )
                      ],
                    ),
                  ),
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
