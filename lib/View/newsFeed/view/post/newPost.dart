// ignore_for_file: invalid_use_of_protected_member, must_be_immutable

import 'dart:io';

import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/dividerClass.dart';
import 'package:bloodlines/Components/dropDownClass.dart';
import 'package:bloodlines/Components/imageBottomSheet.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/SingletonPattern/singletonUser.dart';
import 'package:bloodlines/View/Groups/Model/groupModel.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:bloodlines/View/newsFeed/data/postCreationData.dart';
import 'package:bloodlines/View/newsFeed/model/feelingModel.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/userModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:video_compress/video_compress.dart';

Rx<PostLocation?> postLocation = Rxn<PostLocation>();

class NewPost extends StatefulWidget {
  NewPost(
      {Key? key,
      this.fromShare = false,
      this.isUpdate = false,
      this.fromGroup = false,
      this.parentPostId,
      this.groupData,
      this.newData})
      : super(key: key);
  bool fromShare;
  bool fromGroup;
  int? parentPostId;
  bool isUpdate;
  GroupData? groupData;
  PostModel? newData;

  @override
  State<NewPost> createState() => _NewPostState();
}

RxDouble progress = (0.0).obs;
RxDouble chatProgress = (0.0).obs;

class _NewPostState extends State<NewPost> {
  FeedController controller = Get.find();
  PostCreationData feedData = PostCreationData();
  Subscription? _subscription;
  RxBool isVisible = false.obs;

  UserModel user = SingletonUser.singletonClass.getUser!;
  bool fromVault = false;

  Rx<FeelingClass?>? feelings = Rxn<FeelingClass>();

  RxString deeds = "".obs;

  PostModel? data;

  GroupData? groupData;

  int textColor = DynamicColors.accentColor.withOpacity(0.1).value;

  groupHit(value) async {
    controller.audience.value = value;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _subscription = VideoCompress.compressProgress$.subscribe((progresss) {
      debugPrint('progress: $progresss');
      progress.value = progresss;
      if (progresss >= 100) {
        BotToast.closeAllLoading();
        Future.delayed(Duration(seconds: 1), () {
          controller.update();
        });
      }
    });
    if (widget.groupData != null) {
      groupData = widget.groupData;
    } else if (Get.arguments != null) {
      groupData = Get.arguments["group"];
      if (groupData != null) {
        groupHit("group");
      }
    }
    postLocation = Rxn<PostLocation>();
    controller.postTextController = RichTextController(
      patternMatchMap: {
        /// Returns every Mention with blue color and bold style.
        RegExp(r"\B@[a-zA-Z0-9]*([\s]{1}[a-zA-Z0-9]*)\b"): poppinsLight(
          fontWeight: FontWeight.w800,
          color: Colors.blue,
        ),
      },

      ///! Assertion: Only one of the two matching options can be given at a time!
      onMatch: (List<String> matches) {},
      deleteOnBack: true,
    );

    if (widget.fromShare == false) {
      if (Get.arguments != null) {
        if (Get.arguments["fromGroup"] != null) {
          widget.fromGroup = Get.arguments["fromGroup"];
          widget.groupData = Get.arguments["groupData"];
          groupHit("group");
        }
        if (Get.arguments["data"] != null) {
          data = Get.arguments["data"];
          if (data!.group != null) {
            groupData = data!.group;
          }
          if (data!.location != null) {
            if (data!.location!.address != null) {
              postLocation.value = data!.location;
            }
          }
          groupHit(data!.audience);
          if (data!.tag != null) {
            controller.taggedUser.value.addAll(data!.tag!.people!);
            controller.taggedPedigree.value.addAll(data!.tag!.pedigrees!);
            for (int i = 0; i < controller.taggedUser.value.length; i++) {
              controller.taggedUserList.add(controller.taggedUser.value[i].id!);
              UserModel user = controller.taggedUser.value[i];
              user.isTagSelected!.value = true;
            }
            for (int i = 0; i < controller.taggedPedigree.value.length; i++) {
              controller.taggedPedigreeList
                  .add(controller.taggedPedigree.value[i].id!);
              PedigreeSearchData user = controller.taggedPedigree.value[i];
              user.isTagSelected!.value = true;
            }
          }
          controller.postTextController.text = data!.content ?? "";
          controller.backgroundColor.value = data!.backgroundColor == "0"
              ? DynamicColors.primaryColorLight.value
              : int.parse(data!.backgroundColor!);
          int feelingIndex = feelingList.indexWhere(
              (element) => element.name!.toLowerCase() == data!.postActivity);
          if (feelingIndex != -1) {
            feelings!.value = feelingList[feelingIndex];
          } else {
            int index = activityList.indexWhere(
                (element) => element.name!.toLowerCase() == data!.postActivity);
            if (index != -1) {
              feelings!.value = activityList[index];
            }
          }
          if (data!.location!.address != null) {
            postLocation.value = data!.location!;
          }

          if (data!.media!.isNotEmpty) {
            controller.tempList = data!.media!;
          }
        }
      }
    } else {
      if (widget.isUpdate == true) {
        data = widget.newData;
        controller.postTextController.text = data!.content ?? "";
        controller.backgroundColor.value = data!.backgroundColor == "0"
            ? DynamicColors.primaryColorLight.value
            : int.parse(data!.backgroundColor!);
        int feelingIndex = feelingList
            .indexWhere((element) => element.name == data!.postActivity);
        if (feelingIndex != -1) {
          feelings!.value = feelingList[feelingIndex];
        } else {
          int index = activityList
              .indexWhere((element) => element.name == data!.postActivity);
          if (index != -1) {
            feelings!.value = activityList[feelingIndex];
          }
        }
        if (data!.location!.address != null) {
          postLocation.value = PostLocation(address: data!.location!.address);
        }
      }
    }
  }

  Future<bool> onWillPop() async {
    controller.audience.value = "public";
    controller.postTextController.clear();
    controller.mentionedUsersIds.clear();
    controller.tempList.clear();
    controller.taggedUser.clear();
    controller.taggedUserList.clear();
    controller.taggedPedigree.clear();
    controller.taggedPedigreeList.clear();
    feelings = Rxn<FeelingClass>();
    postLocation = Rxn<PostLocation>();
    controller.backgroundColor.value = DynamicColors.primaryColorLight.value;
    Get.back();
    return true;
  }

  RxBool isLongBottom = false.obs;

  List<String> list = [
    "Public",
    "Followers of followers",
    "Followers only",
    "Group"
  ];

  @override
  void dispose() {
    super.dispose();
    _subscription?.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: onWillPop,
      child: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        return Container(
          color: DynamicColors.primaryColorLight,
          child: Scaffold(
            resizeToAvoidBottomInset: !widget.fromShare,
            backgroundColor: DynamicColors.primaryColorLight,
            bottomSheet: KeyboardVisibilityBuilder(
              builder: (context, isKeyboardVisible) {
                if (widget.fromShare == true) {
                  return SizedBox(
                      height: kToolbarHeight, child: postButton(isLong: true));
                }
                return Obx(() => isLongBottom.value == true
                    ? isKeyboardVisible == false
                        ? longBottomSheetWidget(width, height, controller)
                        : rowBottom(height, width,
                            isKeyboardVisible: isKeyboardVisible)
                    : rowBottom(height, width,
                        isKeyboardVisible: isKeyboardVisible));
              },
            ),
            appBar: widget.fromShare == true
                ? PreferredSize(
                    preferredSize: Size.fromHeight(2), child: Container())
                : AppBar(
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    title: Text(
                      "New Post",
                      style: montserratSemiBold(fontSize: 24),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    leading: AppBarWidgets(
                      onTap: () {
                        onWillPop();
                      },
                    ),
                    actions: [postButton()],
                  ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: SizedBox(
                            height: 50,
                            child: OptimizedCacheImage(
                              imageUrl: user.profile!.profileImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GetBuilder<FeedController>(builder: (controller) {
                          return Obx(() {
                            return SizedBox(
                              width: width / 1.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(children: feelingsSpan()),
                                  ),
                                ],
                              ),
                            );
                          });
                        }),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: DropDownClass(
                            list: list,
                            hint: "Public",
                            initialValue: getGroupName(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            style: poppinsRegular(fontSize: 10),
                            validationError: "",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: DynamicColors.accentColor
                                        .withOpacity(0.5),
                                    width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: DynamicColors.accentColor
                                        .withOpacity(0.5),
                                    width: 1)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: DynamicColors.accentColor
                                        .withOpacity(0.5),
                                    width: 1)),
                            listener: (value) async {
                              if (value == "Followers only") {
                                controller.audience.value = "followers";
                              } else if (value == "Followers of followers") {
                                controller.audience.value =
                                    "followers_of_followers";
                              } else if (value == "Public") {
                                controller.audience.value = "public";
                              } else {
                                controller.audience.value = "group";
                                final resp = await controller.getJoinedGroups();
                                if (resp!.data!.isNotEmpty) {
                                  groupData = resp.data![0].group;
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Obx(() {
                          if (controller.audience.value == "group") {
                            if (controller.joinedGroups!.data!.isEmpty) {
                              return Container();
                            }
                            return Expanded(
                              flex: 1,
                              child: GetBuilder<FeedController>(
                                  builder: (controller) {
                                if (controller.joinedGroups == null) {
                                  return Container();
                                }

                                return GroupDropDownClass(
                                  list: controller.joinedGroups!.data!,
                                  hint: "Public",
                                  initialValue: groupData == null
                                      ? controller.joinedGroups!.data![0].group
                                      : controller.joinedGroups!.data!
                                          .singleWhere((e) {
                                          if (groupData != null) {
                                            return e.group!.id == groupData!.id;
                                          }
                                          return false;
                                        }).group,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 5),
                                  style: poppinsRegular(fontSize: 10),
                                  validationError: "",
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: DynamicColors.accentColor
                                              .withOpacity(0.5),
                                          width: 1)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: DynamicColors.accentColor
                                              .withOpacity(0.5),
                                          width: 1)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: DynamicColors.accentColor
                                              .withOpacity(0.5),
                                          width: 1)),
                                  listener: (value) {
                                    groupData = value;
                                    print(groupData);
                                  },
                                );
                              }),
                            );
                          }
                          return Container();
                        }),
                        Spacer(),
                        GetBuilder<FeedController>(builder: (logic) {
                          return controller.tempList.isNotEmpty
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    Color pickerColor = Color(0xff443a49);

                                    Get.bottomSheet(
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          height: Utils.height(context) / 1.5,
                                          child: Column(
                                            children: [
                                              ColorPicker(
                                                pickerColor: pickerColor,
                                                onColorChanged: (Color color) {
                                                  pickerColor = color;
                                                  controller.backgroundColor
                                                      .value = color.value;
                                                  String c = color.toString();

                                                  print(c);
                                                },
                                              ),
                                              CustomButton(
                                                isLong: false,
                                                text: "Clear",
                                                style: poppinsRegular(
                                                    color: DynamicColors
                                                        .primaryColorLight),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 5),
                                                onTap: () {
                                                  Get.back();
                                                  controller.backgroundColor
                                                          .value =
                                                      DynamicColors
                                                          .primaryColorLight
                                                          .value;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        enableDrag: true,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white);
                                  },
                                  child: Image.asset(
                                    "assets/newPost/colorPicker.png",
                                    height: 40,
                                  ),
                                );
                        }),
                      ],
                    ),
                    DividerClass(
                      color: DynamicColors.accentColor,
                    ),
                    textField(),
                    SizedBox(
                      height: 20,
                    ),
                    GetBuilder<FeedController>(
                      builder: (controller) {
                        return controller.tempList.isEmpty
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: SizedBox(
                                  width: width,
                                  height: 100,
                                  child: imageListWidget(controller),
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Padding postButton({bool isLong = false}) {
    if (widget.fromShare == false) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: CustomButton(
          text: Get.arguments == null
              ? "Post"
              : Get.arguments["data"] == null
                  ? "Post"
                  : "Update",
          isLong: isLong,
          onTap: () {
            if (controller.postTextController.text.isEmpty &&
                controller.tempList.isEmpty) {
              BotToast.showText(text: "Post is empty");
            } else {
              if (controller.audience.value == "group" &&
                  controller.joinedGroups != null &&
                  controller.joinedGroups!.data!.isEmpty) {
                BotToast.showText(
                    text:
                        "You are not in any group!! Please select another field");
              } else {
                if (controller.tempList
                    .any((element) => element.media == null)) {
                  BotToast.showText(text: "Please Wait Until Video Compress");
                } else {
                  controller.createPost(
                      feelingClass: feelings!.value,
                      groupData: groupData,
                      isUpdate: data == null ? false : true,
                      postID: data == null ? null : data!.id,
                      deleteMediaId: controller.deletedFileIds);
                }
              }
            }

            // Get.toNamed(Routes.completeProfile);
          },
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
          color: DynamicColors.primaryColorRed,
          borderColor: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          style: poppinsSemiBold(
              color: DynamicColors.primaryColorLight, fontSize: 15),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: CustomButton(
        text: "Share",
        isLong: true,
        onTap: () {
          if (controller.audience.value == "group" && groupData == null) {
            BotToast.showText(
                text:
                    "You haven't joined or select any groups so you cannot share post in a group");
          } else {
            if (controller.audience.value == "group" && groupData != null) {
              controller.sharePost(
                postId: data?.id,
                type: "group",
                groupId: groupData!.id,
                parentID: widget.parentPostId,
                isUpdate: widget.isUpdate,
              );
            } else {
              controller.sharePost(
                postId: data?.id,
                parentID: widget.parentPostId,
                isUpdate: widget.isUpdate,
              );
            }
          }
        },
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        color: DynamicColors.primaryColorRed,
        borderColor: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        style: poppinsSemiBold(
            color: DynamicColors.primaryColorLight, fontSize: 15),
      ),
    );
  }

  longBottomSheetWidget(width, height, FeedController controller) {
    return Wrap(
      children: [
        Container(
          width: width,
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
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Center(
                    child: InkWell(
                  onTap: () {
                    isLongBottom.value = false;
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: DynamicColors.primaryColor,
                  ),
                )),
                SizedBox(
                  height: 15,
                ),
                widget.fromShare == true
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 4),
                        child: InkWell(
                          onTap: () {
                            bottomSheet(context);
                          },
                          child: Row(
                            children: [
                              ImageIcon(
                                AssetImage("assets/newPost/photo.png"),
                                color: DynamicColors.primaryColorRed,
                                size: height / 40,
                              ),
                              SizedBox(
                                width: width / 30,
                              ),
                              Text(
                                "Photo/Video",
                                style: poppinsRegular(
                                    color: DynamicColors.textColor,
                                    fontSize: height / 60),
                              )
                            ],
                          ),
                        ),
                      ),
                Divider(
                  color: DynamicColors.textColor,
                  height: 15,
                ),
                widget.fromShare == true
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 4),
                        child: InkWell(
                          onTap: () {
                            controller.getTaggedList();
                            Get.toNamed(Routes.tagFriend)!
                                .then((value) => controller.update());
                          },
                          child: Row(
                            children: [
                              ImageIcon(
                                AssetImage("assets/newPost/tag.png"),
                                color: DynamicColors.primaryColorRed,
                                size: height / 40,
                              ),
                              SizedBox(
                                width: width / 30,
                              ),
                              Text(
                                "Tag Peoples",
                                style: poppinsRegular(
                                    color: DynamicColors.textColor,
                                    fontSize: height / 60),
                              )
                            ],
                          ),
                        ),
                      ),
                widget.fromShare == true
                    ? Container()
                    : Divider(
                        color: DynamicColors.textColor,
                        height: 15,
                      ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.feelingsActivity)!.then((value) {
                        if (value != null) {
                          feelings!.value = value as FeelingClass;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage("assets/newPost/feeling.png"),
                          color: DynamicColors.primaryColorRed,
                          size: height / 40,
                        ),
                        SizedBox(
                          width: width / 30,
                        ),
                        Text(
                          "Feeling/ Activity",
                          style: poppinsRegular(
                              color: DynamicColors.textColor,
                              fontSize: height / 60),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: DynamicColors.textColor,
                  height: 15,
                ),
                widget.fromShare == true
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 4),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.tagPostPedigree)!
                                .then((value) => controller.update());
                          },
                          child: Row(
                            children: [
                              ImageIcon(
                                AssetImage("assets/newPost/dog.png"),
                                color: DynamicColors.primaryColorRed,
                                size: height / 40,
                              ),
                              SizedBox(
                                width: width / 30,
                              ),
                              Text(
                                "Tag Dog Pedigree",
                                style: poppinsRegular(
                                    color: DynamicColors.textColor,
                                    fontSize: height / 60),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                widget.fromShare == true
                    ? Container()
                    : Divider(
                        color: DynamicColors.textColor,
                        height: 15,
                      ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.postMapLocation)!.then((value) async {
                        if (value != null) {
                          postLocation.value = value as PostLocation;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage("assets/newPost/checkIn.png"),
                          color: DynamicColors.primaryColorRed,
                          size: height / 40,
                        ),
                        SizedBox(
                          width: width / 30,
                        ),
                        Text(
                          "Check-ins",
                          style: poppinsRegular(
                              color: DynamicColors.textColor,
                              fontSize: height / 60),
                        ),
                        Spacer(),
                        Obx(() {
                          if (postLocation.value != null) {
                            return InkWell(
                                onTap: () {
                                  postLocation.value = null;
                                },
                                child: Icon(
                                  Icons.close,
                                  color: DynamicColors.primaryColor,
                                  size: 20,
                                ));
                          }
                          return Container();
                        })
                      ],
                    ),
                  ),
                ),
                widget.fromShare == false
                    ? Container()
                    : SizedBox(
                        height: 10,
                      ),
                widget.fromShare == false
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: postButton(isLong: true),
                      ),
                widget.fromShare == true
                    ? Container()
                    : Divider(
                        color: DynamicColors.textColor,
                        height: 15,
                      ),
                widget.fromShare == true
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 4),
                        child: InkWell(
                          onTap: () {
                            feedData.getAudio();
                          },
                          child: Row(
                            children: [
                              ImageIcon(
                                AssetImage("assets/newPost/music.png"),
                                color: DynamicColors.primaryColorRed,
                                size: height / 40,
                              ),
                              SizedBox(
                                width: width / 30,
                              ),
                              Text(
                                "Post Music",
                                style: poppinsRegular(
                                    color: DynamicColors.textColor,
                                    fontSize: height / 60),
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

  Column rowBottom(double height, double width, {isKeyboardVisible}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isKeyboardVisible == true
            ? Container()
            : Center(
                child: InkWell(
                onTap: () {
                  isLongBottom.value = true;
                },
                child: Icon(
                  Icons.keyboard_arrow_up_sharp,
                  color: DynamicColors.primaryColor,
                ),
              )),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.fromShare == false)
                  SizedBox(
                    height: 50,
                    width: 40,
                    child: Stack(
                      children: [
                        Positioned(
                            bottom: 10,
                            child: InkWell(
                              onTap: () {
                                bottomSheet(context);
                              },
                              child: ImageIcon(
                                AssetImage("assets/newPost/photo.png"),
                                color: DynamicColors.primaryColor,
                                size: height / 40,
                              ),
                            )),
                      ],
                    ),
                  ),
                if (widget.fromShare == false && widget.fromGroup == false)
                  SizedBox(
                    height: 50,
                    width: 40,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 10,
                          child: InkWell(
                            onTap: () {
                              controller.getTaggedList();
                              Get.toNamed(Routes.tagFriend)!
                                  .then((value) => controller.update());
                            },
                            child: ImageIcon(
                              AssetImage("assets/newPost/tag.png"),
                              color: DynamicColors.primaryColor,
                              size: height / 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.fromShare == false && widget.fromGroup == false)
                  SizedBox(
                    height: 50,
                    width: 40,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 10,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.tagPostPedigree)!
                                  .then((value) => controller.update());
                            },
                            child: ImageIcon(
                              AssetImage("assets/newPost/dog.png"),
                              color: DynamicColors.primaryColor,
                              size: height / 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 50,
                  width: 40,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 10,
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.feelingsActivity)!.then((value) {
                              if (value != null) {
                                feelings!.value = value as FeelingClass;
                              }
                            });
                          },
                          child: ImageIcon(
                            AssetImage("assets/newPost/feeling.png"),
                            color: DynamicColors.primaryColor,
                            size: height / 40,
                          ),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Obx(() {
                            if (feelings!.value != null) {
                              return InkWell(
                                  onTap: () {
                                    feelings!.value = null;
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: DynamicColors.primaryColor,
                                    size: 20,
                                  ));
                            }
                            return Container();
                          })),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 40,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 10,
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.postMapLocation)!
                                .then((value) async {
                              if (value != null) {
                                postLocation.value = value as PostLocation;
                              }
                            });
                          },
                          child: ImageIcon(
                            AssetImage("assets/newPost/checkIn.png"),
                            color: DynamicColors.primaryColor,
                            size: height / 40,
                          ),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Obx(() {
                            if (postLocation.value != null) {
                              return InkWell(
                                  onTap: () {
                                    postLocation.value = null;
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: DynamicColors.primaryColor,
                                    size: 20,
                                  ));
                            }
                            return Container();
                          })),
                    ],
                  ),
                ),
                if (widget.fromShare == false)
                  SizedBox(
                    height: 50,
                    width: 40,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 10,
                          child: InkWell(
                            onTap: () {
                              feedData.getAudio();
                            },
                            child: ImageIcon(
                              AssetImage("assets/newPost/music.png"),
                              color: DynamicColors.primaryColor,
                              size: height / 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.fromShare == true) postButton(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  bottomSheet(
    context,
  ) {
    ImageBottomSheet.bottomSheet(
      context,
      onCameraTap: () async {
        Navigator.of(context).pop();
        mediaBottomSheet(context);
        // Get.toNamed(Routes.cameraFilters);
      },
      onGalleryTap: () {
        Navigator.of(context).pop();
        feedData.imgFromGallery();
        // mediaBottomSheet(context,fromGallery:true);
      },
    );
  }

  mediaBottomSheet(context, {bool fromGallery = false}) {
    ImageBottomSheet.bottomSheet(
      context,
      camera: "Image",
      gallery: "Video",
      onCameraTap: () async {
        Navigator.of(context).pop();
        if (fromGallery == false) {
          feedData.imgFromCamera();
        } else {
          feedData.imgFromGallery();
        }

        // Get.toNamed(Routes.cameraFilters);
      },
      onGalleryTap: () {
        Navigator.of(context).pop();
        feedData.videoFromCamera(fromGallery: fromGallery);
      },
    );
  }

  List<TextSpan> feelingsSpan() {
    return [
      TextSpan(
          text: user.profile!.fullname!.capitalize,
          style: poppinsSemiBold(fontSize: 15)),
      feelings!.value == null
          ? TextSpan()
          : TextSpan(
              text: " is ",
              style: poppinsSemiBold(
                  color: DynamicColors.accentColor.withOpacity(0.6),
                  fontSize: 15)),
      feelings!.value == null
          ? TextSpan()
          : feelings!.value!.type == "Feeling"
              ? TextSpan(
                  text: "feeling ",
                  style: poppinsRegular(
                      color: DynamicColors.accentColor.withOpacity(0.6),
                      fontSize: 15))
              : TextSpan(),
      feelings!.value == null
          ? TextSpan()
          : TextSpan(
              text: "${feelings!.value!.name}",
              style:
                  poppinsBold(color: DynamicColors.primaryColor, fontSize: 15)),
      postLocation.value == null
          ? TextSpan()
          : feelings!.value != null
              ? TextSpan()
              : TextSpan(
                  text: " is",
                  style: poppinsRegular(
                      color: DynamicColors.accentColor.withOpacity(0.6),
                      fontSize: 15)),
      postLocation.value == null
          ? TextSpan()
          : TextSpan(
              text: " at ",
              style: poppinsRegular(
                  color: DynamicColors.accentColor.withOpacity(0.6),
                  fontSize: 15)),
      postLocation.value == null
          ? TextSpan()
          : TextSpan(
              text: "${postLocation.value!.address}",
              style:
                  poppinsBold(color: DynamicColors.primaryColor, fontSize: 15)),
      controller.taggedUser.value.isEmpty
          ? TextSpan()
          : postLocation.value != null
              ? TextSpan()
              : feelings!.value != null
                  ? TextSpan()
                  : TextSpan(
                      text: " is",
                      style: poppinsRegular(
                          color: DynamicColors.accentColor.withOpacity(0.6),
                          fontSize: 15)),
      controller.taggedUser.value.isEmpty
          ? TextSpan()
          : TextSpan(
              text: " with ",
              style: poppinsRegular(
                  color: DynamicColors.accentColor.withOpacity(0.6),
                  fontSize: 15)),
      controller.taggedUser.value.isEmpty
          ? TextSpan()
          : TextSpan(
              text: getUsers(),
              style:
                  poppinsBold(color: DynamicColors.primaryColor, fontSize: 15)),
      controller.taggedPedigree.value.isEmpty
          ? TextSpan()
          : TextSpan(
              text: controller.taggedUser.value.isEmpty
                  ? " with pedigrees "
                  : " and with pedigrees ",
              style: poppinsRegular(
                  color: DynamicColors.accentColor.withOpacity(0.6),
                  fontSize: 15)),
      controller.taggedPedigree.value.isEmpty
          ? TextSpan()
          : TextSpan(
              text: getPedigree(),
              style:
                  poppinsBold(color: DynamicColors.primaryColor, fontSize: 15)),
    ];
  }

  String getUsers() {
    return controller.taggedUser.value.length == 1
        ? controller.taggedUser.value[0].profile!.fullname!
        : controller.taggedUser.value.length == 2
            ? "${controller.taggedUser.value[0].profile!.fullname!} and ${controller.taggedUser.value[1].profile!.fullname!}"
            : "${controller.taggedUser.value[0].profile!.fullname!} and ${controller.taggedUser.value.length - 1} Others";
  }

  String getPedigree() {
    return controller.taggedPedigree.value.length == 1
        ? controller.taggedPedigree.value[0].dogName!
        : controller.taggedPedigree.value.length == 2
            ? "${controller.taggedPedigree.value[0].dogName!} and ${controller.taggedPedigree.value[1].dogName!}"
            : "${controller.taggedPedigree.value[0].dogName!} and ${controller.taggedPedigree.value.length - 1} Others";
  }

  bool detected = false;
  int startIndexOfTag = 0;
  int endIndexOfTag = 0;
  bool isComment = false;

  Widget textField() {
    return Obx(() {
      return RichTextEditor(
          maxLines: controller.backgroundColor.value ==
                  DynamicColors.primaryColorLight.value
              ? null
              : 8,
          fromPost: true,
          autoFocus: widget.fromShare,
          suggestionColor: DynamicColors.primaryColorLight,
          backgroundColor: DynamicColors.lightTextColor,
          expands: false,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          padding: EdgeInsets.zero,
          textAlign: TextAlign.start,
          minLines: null,
          style: poppinsRegular(
            fontSize: 20,
            color: (DynamicColors.whiteColor.value -
                        controller.backgroundColor.value) <=
                    6400000
                ? DynamicColors.black
                : DynamicColors.whiteColor,
          ),
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent)),
            filled: true,
            fillColor: Color(controller.backgroundColor.value),

            // ==
            //     DynamicColors.primaryColorDark.value
            // ? Color(controller.backgroundColor.value)
            // : Color(controller.backgroundColor.value).withOpacity(0.9),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent)),
            hintText: "What's on your mind?",
            hintStyle: poppinsSemiBold(
                fontSize: 18,
                color: DynamicColors.accentColor.withOpacity(0.8)),
          ),
          onChanged: (value) {
            if (value.endsWith('@')) {
              detected = true;
              startIndexOfTag = value.length - 1;
            }

            if (detected == true) {
              controller.mentioning.value = value.substring(startIndexOfTag);
              print(controller.mentioning.value);
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
            final reg = RegExp(r"\B@[a-zA-Z0-9]*([\s]{1}[a-zA-Z0-9]*)\b")
                .allMatches(controller.postTextController.text);
            if (reg.isNotEmpty) {
              for (var elements in reg) {
                controller.usersList.any((element) {
                  if (elements.input
                      .contains("@${element.profile!.fullname}")) {
                    print(element.id);
                    if (!controller.mentionedUsersIds
                        .contains(element.id.toString())) {
                      controller.mentionedUsersIds.add(element.id.toString());
                    }
                    return true;
                  } else {
                    controller.mentionedUsersIds.remove(element.id.toString());
                  }
                  return false;
                });
              }
            }
          },
          controller: controller.postTextController,
          suggestionController: SuggestionController(
            mentionSymbol: '@',
            intialMentions: controller.mentionList,
            position: SuggestionPosition.top,
            mentionSuggestions: [
              // for (int i = 0; i < controller.friendList!.results!.length; i++)
              //   Mention(
              //       id: controller.friendList!.results![i].id.toString(),
              //       imageURL: controller.friendList!.results![i].profileNormal!
              //           .normalProfileMeta!.profileImage!,
              //       subtitle: '',
              //       title:
              //       '${controller.friendList!.results![i].profileNormal!.normalProfileMeta!.name}'),
            ],
            onSearchMention: (term) async {
              return controller.mentionList;
            },
            onMentionSelected: (suggestion) {
              controller.mentionedUsersIds.add(suggestion.id!);
              controller.postTextController.text += "${suggestion.title} ";
              controller.postTextController.selection =
                  TextSelection.fromPosition(TextPosition(
                      offset: controller.postTextController.text.length));
            },
          ));
    });
  }

  ListView imageListWidget(FeedController controller) {
    return ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.zero,
        itemCount: controller.tempList.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: SizedBox(
              width: 100,
              child: Stack(
                children: [
                  controller.tempList[index].mediaType == "image"
                      ? GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.photo, arguments: {
                              "image": controller.tempList[index].media,
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: DynamicColors.primaryColor),
                                image: DecorationImage(
                                    image: controller.tempList[index].id == null
                                        ? FileImage(File(controller
                                            .tempList[index].media
                                            .toString()))
                                        : NetworkImage(controller
                                            .tempList[index].media
                                            .toString()) as ImageProvider,
                                    fit: BoxFit.cover)),
                          ),
                        )
                      : Container(),
                  controller.tempList[index].mediaType == "video"
                      ? GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.videoPlayerClass, arguments: {
                              "url": controller.tempList[index].media,
                              "type": controller.tempList[index].id == null
                                  ? "file"
                                  : "network",
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: DynamicColors.primaryColor),
                                image: DecorationImage(
                                    image: controller.tempList[index].id == null
                                        ? FileImage(File(controller
                                            .tempList[index].thumbnail
                                            .toString()))
                                        : NetworkImage(controller
                                            .tempList[index].thumbnail
                                            .toString()) as ImageProvider,
                                    fit: BoxFit.cover)),
                            child: Center(
                              child: controller.tempList[index].media == null
                                  ? CircularProgressIndicator(
                                      color: DynamicColors.primaryColor,
                                    )
                                  : Container(
                                      width: 30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: DynamicColors.primaryColor,
                                              width: 2)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Icon(
                                            FontAwesome5.play,
                                            size: 15,
                                            color: DynamicColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        )
                      : Container(),
                  controller.tempList[index].mediaType == "audio"
                      ? GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.audioPlayerClass, arguments: {
                              "url": controller.tempList[index].media,
                              "type": controller.tempList[index].id == null
                                  ? "file"
                                  : "network",
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: DynamicColors.primaryColor),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.music_note,
                                size: 35,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        if (controller.tempList[index].id == null) {
                          controller.tempList.removeAt(index);
                          // controller.fileList.removeAt(index);
                          controller.update();
                        } else {
                          controller.deletedFileIds
                              .add(controller.tempList[index].id.toString());
                          controller.tempList.removeAt(index);
                          controller.update();
                        }
                        controller.imageUpdate.value =
                            !controller.imageUpdate.value;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black54, shape: BoxShape.circle),
                        child: Center(
                            child: Icon(
                          Icons.close,
                          color: DynamicColors.whiteColor,
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  String getGroupName() {
    switch (controller.audience.value) {
      case "public":
        return "Public";
      case "followers_of_followers":
        return "Followers of followers";
      case "followers":
        return "Followers only";
      default:
        return "Group";
    }
  }
}
