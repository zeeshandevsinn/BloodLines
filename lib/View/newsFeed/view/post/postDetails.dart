// ignore_for_file: invalid_use_of_protected_member, must_be_immutable

import 'package:bloodlines/Components/CustomAlert.dart';
import 'package:bloodlines/View/newsFeed/data/feedComponentData.dart';
import 'package:bloodlines/View/newsFeed/model/commentModel.dart';
import 'package:bloodlines/View/newsFeed/model/postMedia.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/View/newsFeed/view/post/postMediaWidget.dart';
import 'package:bloodlines/View/newsFeed/view/post/postWidget.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:flutter/material.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:comment_tree/comment_tree.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:like_button/like_button.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:rich_text_view/rich_text_view.dart';

class PostDetails extends StatefulWidget {
  PostDetails(
      {Key? key,
      required this.result,
      required this.index,
      this.fromDetails = false,
      this.fromGroup = false,
      this.fromNotifications = false,
      this.fromSearch = false,
      this.postMedia})
      : super(key: key);
  PostModel result;
  bool fromNotifications;
  bool fromDetails;
  bool fromGroup;
  bool fromSearch;
  PostMedia? postMedia;
  int? index;

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  FeedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      child: Container(
        height: MediaQuery.of(context).size.height / 1.1,
        decoration: BoxDecoration(
          color: DynamicColors.primaryColorLight,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: GetBuilder<FeedController>(
          builder: (controller) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: kToolbarHeight),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            height: 20,
                          ),
                          widget.fromDetails == true
                              ? widget.postMedia == null
                                  ? Text(
                                      widget.result.content!,
                                      style: poppinsRegular(fontSize: 15),
                                    )
                                  : PostMediaWidget(
                                      postMedia: widget.postMedia!,
                                      index: widget.index!)
                              : PostClass(
                                  result: widget.result,
                                  index: widget.index!,
                                  fromBottom: true),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Comments",
                            style: poppinsRegular(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Obx(() {
                            if (controller.commentModel.value == null) {
                              return LoaderClass();
                            }
                            return CommentBuilder(
                              commentList:
                                  controller.commentModel.value!.results!.data!,
                              result: widget.result,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomField(result: widget.result),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BottomField extends StatefulWidget {
  BottomField({Key? key, this.result}) : super(key: key);
  PostModel? result;

  @override
  State<BottomField> createState() => _BottomFieldState();
}

class _BottomFieldState extends State<BottomField> {
  FeedController controller = Get.find();
  bool isComment = false;

  bool detected = false;

  int startIndexOfTag = 0;

  int endIndexOfTag = 0;
  FeedComponentData feedData = FeedComponentData();

  @override
  void initState() {
    controller.richTextController = RichTextController(
      patternMatchMap: {
        /// Returns every Hashtag with red color
        // RegExp(r"\B#[a-zA-Z0-9]+\b"): poppinsLight(color: Colors.purple),

        /// Returns every Mention with blue color and bold style.
        RegExp(r"\B@[a-zA-Z0-9]*([\s]{1}[a-zA-Z0-9]*)\b"): poppinsLight(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
        RegExp(r"\B@[a-zA-Z0-9]*[a-zA-Z0-9]\b"): poppinsLight(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),

        /// Returns every word after '!' with yellow color and italic style.
        // RegExp(r"\B![a-zA-Z0-9]+\b"):
        //     TextStyle(color: Colors.yellow, fontStyle: FontStyle.italic),
        // add as many expressions as you need!
      },

      ///! Assertion: Only one of the two matching options can be given at a time!
      onMatch: (List<String> matches) {
        // Do something with matches.
        //! P.S
        // as long as you're typing, the controller will keep updating the list.
      },
      regExpCaseSensitive: false,

      deleteOnBack: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller.fieldUpdate.value == true)
            SizedBox(
              height: 50,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: SizedBox(
                      width: 50,
                      child: Stack(
                        children: [
                          Container(
                              alignment: Alignment.centerRight,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    topLeft: Radius.circular(5)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          topLeft: Radius.circular(5)),
                                      border: Border.all(
                                          color: DynamicColors.primaryColor)),
                                  child: controller
                                          .commentNetworkImage.value.isNotEmpty
                                      ? OptimizedCacheImage(
                                          imageUrl: controller
                                              .commentNetworkImage.value)
                                      : controller.imageFile != null
                                          ? Image.file(
                                              File(controller.imageFile!.path),
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.fill,
                                            )
                                          : Container(),
                                ),
                              )),
                          InkWell(
                            onTap: () {
                              if (controller
                                  .commentNetworkImage.value.isNotEmpty) {
                                controller.commentNetworkImage.value = "";
                                controller.commentDelete = true;
                                controller.fieldUpdate(true);
                              } else {
                                controller.imageFile = null;
                              }
                              controller.fieldUpdate(false);
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: DynamicColors.primaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            // height: kToolbarHeight + 40,
            color: DynamicColors.primaryColorLight,
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: const EdgeInsets.only(
                    right: 10, left: 10, bottom: 20, top: 10),
                child: RichTextEditor(
                    padding: EdgeInsets.zero,
                    minLines: 1,
                    focusNode: controller.commentFocusNode,
                    fromPost: false,
                    textInputAction: TextInputAction.newline,
                    suggestionColor: DynamicColors.primaryColorLight,
                    backgroundColor: DynamicColors.lightTextColor,
                    maxLines: 4,
                    onChanged: (value) {
                      if (value.endsWith('@')) {
                        detected = true;
                        startIndexOfTag = value.length - 1;
                      }

                      if (detected == true) {
                        controller.mentioning.value =
                            value.substring(startIndexOfTag);
                      }

                      if ((detected == true && value.endsWith(' ')) ||
                          startIndexOfTag == 1) {
                        detected = false;
                        endIndexOfTag = value.length;
                      }

                      if (value.length < endIndexOfTag) {
                        detected = true;
                        endIndexOfTag = value.length;
                        startIndexOfTag = value.indexOf('@');
                      }
                      final reg =
                          RegExp(r"\B@[a-zA-Z0-9]*([\s]{1}[a-zA-Z0-9]*)\b")
                              .allMatches(controller.richTextController.text);
                      if (reg.isNotEmpty) {
                        for (var elements in reg) {
                          controller.usersList.any((element) {
                            if (elements.input
                                .contains("@${element.profile!.fullname}")) {
                              print(element.id);
                              if (!controller.mentionedCommentUsersIds
                                  .contains(element.id.toString())) {
                                controller.mentionedCommentUsersIds
                                    .add(element.id.toString());
                              }
                              return true;
                            } else {
                              controller.mentionedCommentUsersIds
                                  .remove(element.id.toString());
                            }
                            return false;
                          });
                        }
                      }
                    },
                    controller: controller.richTextController,
                    style: poppinsRegular(),
                    decoration: InputDecoration(
                      prefixIcon: CustomPopupMenu(
                        controller: controller.customPopupMenuController,
                        menuBuilder: feedData.popUpMenu,
                        horizontalMargin: 0,
                        showArrow: true,
                        barrierColor: Colors.transparent,
                        pressType: PressType.singleClick,
                        child: Icon(
                          Icons.camera_alt,
                          color: DynamicColors.primaryColor,
                          size: Utils.height(context) / 25,
                        ),
                      ),
                      hintText: "Add Comment",
                      hintStyle: poppinsLight(
                          color: DynamicColors.accentColor, fontSize: 15),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (controller.richTextController.text.isNotEmpty ||
                              controller.imageFile != null) {
                            if (isComment == false) {
                              isComment = true;
                              Future.delayed(Duration(seconds: 2), () {
                                isComment = false;
                              });
                              if (controller.commentId == null) {
                                controller.addComment(
                                  postId: widget.result!.id,
                                  // index,
                                );
                              } else {
                                controller.updateComment(widget.result!.id!);
                              }
                            } else {
                              BotToast.showText(text: "Please Wait !!");
                            }
                          } else {
                            BotToast.showText(
                                text: "Cannot send empty comment");
                          }
                        },
                        child: Icon(
                          Icons.send,
                          color: DynamicColors.primaryColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              width: 1, color: DynamicColors.primaryColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              width: 1, color: DynamicColors.primaryColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              width: 1, color: DynamicColors.primaryColor)),
                    ),
                    suggestionController: SuggestionController(
                      mentionSymbol: '@',
                      position: SuggestionPosition.top,
                      intialMentions: controller.mentionList,
                      mentionSuggestions: [
                        for (int i = 0; i < controller.usersList.length; i++)
                          if (controller.usersList[i].profile != null)
                            Mention(
                                id: controller.usersList[i].id.toString(),
                                imageURL: controller
                                    .usersList[i].profile!.profileImage!,
                                subtitle: '',
                                title:
                                    controller.usersList[i].profile!.fullname!),
                      ],
                      onSearchMention: (term) async {
                        return controller.mentionList;
                      },
                      onMentionSelected: (suggestion) {
                        controller.mentionedUsersIds.add(suggestion.id!);
                        controller.richTextController.text +=
                            "${suggestion.title}  ";
                        controller.richTextController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset:
                                    controller.richTextController.text.length));
                      },
                    ))),
          ),
        ],
      );
    });
  }
}

class CommentBuilder extends StatelessWidget {
  CommentBuilder({required this.commentList, required this.result});

  final List<CommentData> commentList;
  final PostModel result;
  final FeedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return commentList.isEmpty
        ? Center(
            child: Text(
              "No comments yet",
              style: poppinsBold(color: DynamicColors.primaryColor),
            ),
          )
        : Obx(() {
            if (controller.commentUpdate.value) {
              return buildListView();
            }
            return buildListView();
          });
  }

  Widget buildListView() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: kToolbarHeight + 10),
          physics: NeverScrollableScrollPhysics(),
          itemCount: commentList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            if (commentList[index].isReported == 1) {
              return Container();
            }
            return Padding(
                padding: const EdgeInsets.only(left: 8, right: 13, top: 14),
                child: CommentDesign(
                    commentData: commentList[index],
                    commentList: commentList,
                    result: result,
                    index: index));
          }),
    );
  }
}

class CommentDesign extends StatelessWidget {
  CommentDesign(
      {required this.commentData,
      this.firstReply = false,
      this.commentList,
      required this.result,
      required this.index});

  final FeedController controller = Get.find();
  final PostModel result;
  CommentData commentData;
  List<CommentData>? commentList;
  bool firstReply = false;
  int index;
  FeedComponentData feedData = FeedComponentData();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedController>(builder: (controller) {
      return CommentTreeWidget<CommentData, CommentData>(
        commentData,
        commentData.reply!,
        treeThemeData: TreeThemeData(
            lineColor: commentData.reply!.isEmpty
                ? Colors.transparent
                : DynamicColors.primaryColor.withOpacity(0.3),
            lineWidth: 2),
        avatarRoot: (context, data) =>data.user == null?PreferredSize(preferredSize: Size.fromHeight(0),child: Container(),

        ): PreferredSize(
          preferredSize: Size.fromRadius(12),
          child: GestureDetector(
            onTap: () {
              Utils.onNavigateTimeline(commentData.user!.id!);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: OptimizedCacheImage(
                  imageUrl: data.user!.profile!.profileImage!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        contentRoot: (context, data) {
          // controller.commentSocket(data.id, index);
          return GestureDetector(
            child: parent(
                context: context,
                data: data,
                like: Obx(() {
                  return LikeButton(
                    size: 20,
                    circleColor: CircleColor(
                        start: DynamicColors.liveColor,
                        end: DynamicColors.liveColor.withOpacity(0.5)),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: DynamicColors.liveColor.withOpacity(0.5),
                      dotSecondaryColor: DynamicColors.liveColor,
                    ),
                    onTap: (bool isLiked) async {
                      controller.commentLikeDislike(
                        commentID: data.id.toString(),
                        index: index,
                        reaction: isLiked == false ? "like" : "remove",
                      );
                      return isLiked;
                    },
                    likeBuilder: (bool isLiked) {
                      if (isLiked == true) {
                        return Image.asset(
                          "assets/like.png",
                          color: DynamicColors.primaryColorRed,
                        );
                      }
                      return Image.asset(
                        "assets/like.png",
                      );
                    },
                    isLiked: data.isLike!.value,
                    // likeCount: data.likeCount!.value == 0
                    //     ? null
                    //     : data.likeCount!.value,
                  );
                }),
                onDelete: () {
                  alertCustomMethod(context,
                      titleText: "Do you want to delete this comment?",
                      buttonText: "Yes",
                      buttonText2: "No",
                      theme: DynamicColors.primaryColor,
                      titleStyle: poppinsRegular(
                          fontSize: 20,
                          color: DynamicColors.primaryColor,
                          fontWeight: FontWeight.w200), click: () {
                    controller.commentId = data.id;
                    controller.deleteComment(result.id!);
                  }, click2: () {
                    Get.back();
                  });
                },
                onReport: () {
                  controller.reportPost(
                      postId: data.id,
                      type: "comment",
                      responseType: "post",
                      commentPostId: data.postId);
                },
                onEdit: () {
                  controller.commentId = data.id;
                  if (data.comment != null) {
                    controller.richTextController.text = data.comment!;
                  }
                  if (data.media != null) {
                    controller.commentNetworkImage.value = data.media!;
                    controller.fieldUpdate(false);
                    controller.fieldUpdate(true);
                  }
                  controller.commentFocusNode.requestFocus();
                },
                onReply: () {
                  controller.parentCommentID = data.id;
                  // if (data.user!.id != API().sp.read("id")) {
                  controller.onReplyTap('@${data.user!.profile!.fullname}');
                  // }
                }),
          );
        },
        avatarChild: (context, data) => PreferredSize(
          preferredSize: Size.fromRadius(12),
          child: GestureDetector(
            onTap: () {
              Utils.onNavigateTimeline(commentData.user!.id!);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: OptimizedCacheImage(
                  imageUrl: data.user!.profile!.profileImage!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        contentChild: (context, data) {
          int i = commentData.reply!.indexOf(data);
          print(i);

          // controller.commentSocket(data.id, index,
          //     replyIndex: commentData.reply!.indexOf(data));
          return GestureDetector(
            onLongPress: () {
              if (result.user!.id == Api.singleton.sp.read("id") ||
                  data.user!.id == Api.singleton.sp.read("id")) {
                Get.bottomSheet(Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: DynamicColors.primaryColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () {
                              // controller.deleteComment(data.id, index, data.)
                            },
                            leading: Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                            title: Text("Delete",
                                style: poppinsLight(color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
              }
            },
            child: recursive(
                data: data,
                context: context,
                like: Obx(() {
                  return LikeButton(
                    size: 20,
                    circleColor: CircleColor(
                        start: DynamicColors.liveColor,
                        end: DynamicColors.liveColor.withOpacity(0.5)),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: DynamicColors.liveColor.withOpacity(0.5),
                      dotSecondaryColor: DynamicColors.liveColor,
                    ),

                    onTap: (bool isLiked) async {
                      int rep = commentData.reply!.indexOf(data);
                      controller.commentLikeDislike(
                        commentID: data.id.toString(),
                        index: index,
                        replyIndex: commentData.reply!.indexOf(data),
                        reaction: isLiked == false ? "like" : "remove",
                      );
                      return isLiked;
                    },
                    likeBuilder: (bool isLiked) {
                      if (isLiked == true) {
                        return Image.asset(
                          "assets/like.png",
                          color: DynamicColors.primaryColorRed,
                        );
                      }
                      return Image.asset(
                        "assets/like.png",
                      );
                    },
                    isLiked: data.isLike!.value,
                    // likeCount: data.likeCount!.value == 0
                    //     ? null
                    //     : data.likeCount!.value,
                  );
                }),
                onReport: () {
                  controller.reportPost(
                      postId: data.id,
                      type: "comment",
                      responseType: "post",
                      commentPostId: data.postId);
                },
                onEdit: () {
                  controller.commentId = data.id;
                  if (data.parentId != 0) {
                    controller.parentCommentID = data.parentId;
                  }
                  if (data.comment != null) {
                    controller.richTextController.text = data.comment!;
                  }
                  if (data.media != null) {
                    controller.commentNetworkImage.value = data.media!;
                    controller.fieldUpdate(false);
                    controller.fieldUpdate(true);
                  }
                  controller.commentFocusNode.requestFocus();
                },
                onDelete: () {
                  alertCustomMethod(context,
                      titleText: "Do you want to delete this comment?",
                      buttonText: "Yes",
                      buttonText2: "No",
                      theme: DynamicColors.primaryColor,
                      titleStyle: poppinsRegular(
                          fontSize: 20,
                          color: DynamicColors.primaryColor,
                          fontWeight: FontWeight.w200), click: () {
                    controller.commentId = data.id;
                    if (data.parentId != 0) {
                      controller.parentCommentID = data.parentId;
                    }
                    controller.deleteComment(result.id!);
                  }, click2: () {
                    Get.back();
                  });
                },
                onReply: () {
                  int i = data.reply!.indexOf(data);
                  controller.parentCommentID = data.parentId;
                  controller.onReplyTap('@${data.user!.profile!.fullname}');
                }),
          );
        },
      );
    });
  }

  Widget recursive(
      {required CommentData data,
      required context,
      required onReport,
      required onReply,
      required Widget like,
      onEdit,
      onDelete,
      isReply = true}) {
    // if (data.user!.blockBy == true || data.user!.isBlock == true) {
    //   return Container();
    // }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
          ),
          decoration: BoxDecoration(
              color: DynamicColors.primaryColorLight,
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${data.user!.profile!.fullname}",
                style: poppinsRegular(
                    fontWeight: FontWeight.bold,
                    color: DynamicColors.primaryColor,
                    fontSize: 15),
              ),
              SizedBox(
                height: 4,
              ),
              data.media == null
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10)),
                      child: feedData.markdownBody(
                        data.comment,
                        context,
                        poppinsSemiBold(
                            fontSize: 15, color: DynamicColors.primaryColor),
                      ),
                    )
                  : data.comment == null
                      ? GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.photo,
                                arguments: {"image": data.media!});
                          },
                          child: OptimizedCacheImage(
                            imageUrl: data.media!,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.photo,
                                    arguments: {"image": data.media!});
                              },
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: OptimizedCacheImage(
                                  imageUrl: data.media!,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(10)),
                              child: feedData.markdownBody(
                                data.comment,
                                context,
                                poppinsSemiBold(
                                    fontSize: 15,
                                    color: DynamicColors.primaryColor),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
            ],
          ),
        ),

        ///like reply
        DefaultTextStyle(
          style: poppinsLight(
              color: Colors.grey[700], fontWeight: FontWeight.bold),
          child: Padding(
            padding: EdgeInsets.only(top: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                like,
                SizedBox(
                  width: 24,
                ),
                isReply == false
                    ? Container()
                    : InkWell(
                        onTap: onReply,
                        child: Text(
                          'Reply',
                          style: poppinsLight(
                              color: DynamicColors.borderGrey, fontSize: 13),
                        )),
                SizedBox(
                  width: data.user!.id == Api.singleton.sp.read("id") ? 15 : 0,
                ),
                data.user!.id == Api.singleton.sp.read("id")
                    ? InkWell(
                        onTap: onEdit,
                        child: Text(
                          'Edit',
                          style: poppinsLight(
                              color: DynamicColors.borderGrey, fontSize: 13),
                        ))
                    : Container(),
                SizedBox(
                  width: result.user!.id == Api.singleton.sp.read("id") ||
                          data.user!.id == Api.singleton.sp.read("id")
                      ? 15
                      : 0,
                ),
                result.user!.id == Api.singleton.sp.read("id") ||
                        data.user!.id == Api.singleton.sp.read("id")
                    ? InkWell(
                        onTap: onDelete,
                        child: Text(
                          'Delete',
                          style: poppinsLight(
                              color: DynamicColors.borderGrey, fontSize: 13),
                        ))
                    : Container(),
                SizedBox(
                  width: data.user!.id != Api.singleton.sp.read("id") ? 15 : 0,
                ),
                data.user!.id != Api.singleton.sp.read("id")
                    ? InkWell(
                        onTap: onReport,
                        child: Text(
                          'Report',
                          style: poppinsLight(
                              color: DynamicColors.borderGrey, fontSize: 13),
                        ))
                    : Container(),
                Spacer(),
                Obx(() => data.likes!.value.isEmpty
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          // controller.likesData = Rxn(LikesData());
                          // controller.likesInfo(
                          //     postID: data.id.toString(), fromComment: true);
                          // Get.toNamed(Routes.likeInfo);
                        },
                        child: Row(
                          children: [
                            Icon(
                              FontAwesome.heart,
                              size: 15,
                              color: Color(0xffd51820),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              data.likes!.value.length.toString(),
                              style: poppinsLight(fontSize: 15),
                            )
                          ],
                        ),
                      ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  String getUserID(String text) {
    controller.usersList.map((u) => u.id).toSet().forEach((userName) {
      text = userName.toString();
    });
    return text;
  }

  Widget parent(
      {required CommentData data,
      required context,
      required onReply,
      required onReport,
      onEdit,
      onDelete,
      required Widget like}) {
    if(data.user == null)return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: DynamicColors.primaryColorLight,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${data.user!.profile!.fullname}",
                style: poppinsRegular(
                    fontWeight: FontWeight.bold,
                    color: DynamicColors.primaryColor,
                    fontSize: 15),
              ),
              SizedBox(
                height: 4,
              ),
              data.media == null
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10)),
                      child:

                          // Text( data.comment!, style: poppinsSemiBold(
                          //     fontSize: 15, color: DynamicColors.primaryColor),),

                          feedData.markdownBody(
                        data.comment,
                        context,
                        poppinsSemiBold(
                            fontSize: 15, color: DynamicColors.primaryColor),
                      ),
                    )
                  : data.comment == null
                      ? GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              Routes.photo,
                              arguments: {
                                "image": data.media!,
                              },
                            );
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 10,
                              maxWidth: MediaQuery.of(context).size.width,
                              minHeight: 10,
                              maxHeight: MediaQuery.of(context).size.height / 5,
                            ),
                            // height: MediaQuery
                            //     .of(context)
                            //     .size
                            //     .height / 5,
                            // width: MediaQuery
                            //     .of(context)
                            //     .size.width/2 ,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: OptimizedCacheImage(
                                imageUrl: data.media!,
                                // fit: BoxFit.fitHeight,
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  Routes.photo,
                                  arguments: {
                                    "image": data.media!,
                                  },
                                );
                              },
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: OptimizedCacheImage(
                                  imageUrl: data.media!,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(10)),
                              child: feedData.markdownBody(
                                  data.comment,
                                  context,
                                  poppinsSemiBold(
                                      fontSize: 15,
                                      color: DynamicColors.primaryColor),
                                  selectable: false),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
            ],
          ),
        ),
        DefaultTextStyle(
          style: poppinsLight(
              color: Colors.grey[700], fontWeight: FontWeight.bold),
          child: Padding(
            padding: EdgeInsets.only(top: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                like,
                SizedBox(
                  width: 20,
                ),
                InkWell(
                    onTap: onReply,
                    child: Text(
                      'Reply',
                      style: poppinsLight(
                          color: DynamicColors.borderGrey, fontSize: 13),
                    )),
                SizedBox(
                  width: data.user!.id == Api.singleton.sp.read("id") ? 15 : 0,
                ),
                data.user!.id == Api.singleton.sp.read("id")
                    ? InkWell(
                        onTap: onEdit,
                        child: Text(
                          'Edit',
                          style: poppinsLight(
                              color: DynamicColors.borderGrey, fontSize: 13),
                        ))
                    : Container(),
                SizedBox(
                  width: result.user!.id == Api.singleton.sp.read("id") ||
                          data.user!.id == Api.singleton.sp.read("id")
                      ? 15
                      : 0,
                ),
                result.user!.id == Api.singleton.sp.read("id") ||
                        data.user!.id == Api.singleton.sp.read("id")
                    ? InkWell(
                        onTap: onDelete,
                        child: Text(
                          'Delete',
                          style: poppinsLight(
                              color: DynamicColors.borderGrey, fontSize: 13),
                        ))
                    : Container(),
                SizedBox(
                  width: data.user!.id != Api.singleton.sp.read("id") ? 15 : 0,
                ),
                data.user!.id != Api.singleton.sp.read("id")
                    ? InkWell(
                        onTap: onReport,
                        child: Text(
                          'Report',
                          style: poppinsLight(
                              color: DynamicColors.borderGrey, fontSize: 13),
                        ))
                    : Container(),
                Spacer(),
                Obx(() => data.likes!.value.isEmpty
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          // controller.likesData = Rxn(LikesData());
                          // controller.likesInfo(
                          //     postID: data.id.toString(), fromComment: true);
                          // Get.toNamed(Routes.likeInfo);
                        },
                        child: Row(
                          children: [
                            Icon(
                              FontAwesome.heart,
                              size: 15,
                              color: Color(0xffd51820),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              data.likes!.value.length.toString(),
                              style: poppinsLight(fontSize: 15),
                            )
                          ],
                        ),
                      ))
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
