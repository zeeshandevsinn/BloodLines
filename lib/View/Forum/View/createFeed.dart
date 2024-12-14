import 'dart:io';

import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/textFieldComponent.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Forum/Model/forumDetailsModel.dart';
import 'package:bloodlines/View/newsFeed/data/feedComponentData.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class CreateTopic extends StatefulWidget {
  CreateTopic({Key? key}) : super(key: key);

  @override
  State<CreateTopic> createState() => _CreateTopicState();
}

class _CreateTopicState extends State<CreateTopic> {
  FeedController controller = Get.find();

  final formKey = GlobalKey<FormState>();
  String? coverImage;
  int id = Get.arguments["id"];
  ForumDetailsData? model = Get.arguments["model"];
  FeedComponentData feedData = FeedComponentData();
  String? dataImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (model != null) {
      controller.forumContent.text = model!.content!;
      controller.forumTitle.text = model!.title!;
      dataImage = model!.media;
    }
  }

  Future<bool> onWillPop() async {
    controller.eventSelectList.clear();
    controller.forumContent.clear();
    controller.forumTitle.clear();
    Get.back();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: DynamicColors.primaryColorLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: AppBarWidgets(
            onTap: () {
              onWillPop();
            },
          ),
          title: Text(
            "Create Topic",
            style: poppinsSemiBold(
                color: DynamicColors.primaryColor, fontSize: 24),
          ),
          elevation: 0,
        ),
        body: GetBuilder<FeedController>(builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dataImage == null
                        ? controller.files == null
                            ? GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  feedData.bottomSheet(context,
                                      fromAddEvent: true);
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/dummyCover.png",
                                      fit: BoxFit.fill,
                                      height: Utils.height(context) / 5,
                                      width: double.infinity,
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color:
                                                    DynamicColors.primaryColor,
                                                shape: BoxShape.circle),
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Add Topic Photo",
                                            style: montserratRegular(
                                                fontSize: 20,
                                                color:
                                                    DynamicColors.accentColor),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ))
                            : Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(Routes.photo, arguments: {
                                        "image": controller.files!.path,
                                        "type": "file"
                                      });
                                    },
                                    child: Image.file(
                                      File(
                                        controller.files!.path,
                                      ),
                                      width: double.infinity,
                                      height: Utils.height(context) / 5,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.files = null;
                                        controller.update();
                                      },
                                      child: Icon(
                                        Entypo.cancel_circled,
                                        color: DynamicColors.primaryColorRed,
                                      ),
                                    ),
                                  )
                                ],
                              )
                        : Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.photo, arguments: {
                                    "image": dataImage,
                                    "type": "network"
                                  });
                                },
                                child: OptimizedCacheImage(
                                  imageUrl: dataImage!,
                                  width: Utils.width(context),
                                  height: Utils.height(context) / 5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    dataImage = null;
                                    controller.update();
                                  },
                                  child: Icon(
                                    Entypo.cancel_circled,
                                    color: DynamicColors.primaryColorRed,
                                  ),
                                ),
                              )
                            ],
                          ),
                    SizedBox(
                      height: kToolbarHeight / 2,
                    ),
                    TextFieldComponent(
                        title: "Topic",
                        maxLines: 5,
                        hint: "Live Show",
                        controller: controller.forumTitle),
                    SizedBox(
                      height: kToolbarHeight / 2,
                    ),
                    TextFieldComponent(
                        title: "Content",
                        maxLines: 5,
                        hint: "Live Show",
                        controller: controller.forumContent),
                    SizedBox(
                      height: kToolbarHeight / 2,
                    ),
                    Center(
                      child: CustomButton(
                        text: model != null ? "Update" : "Create",
                        isLong: false,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            if (model == null) {
                              controller.createTopic(id);
                            } else {
                              controller.createTopic(model!.id!,
                                  isUpdate: true, topicId: id);
                            }
                          }
                          // Get.toNamed(Routes.profiling2);
                        },
                        padding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 40),
                        color: DynamicColors.primaryColorRed,
                        borderColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        style: poppinsSemiBold(
                            color: DynamicColors.primaryColorLight),
                      ),
                    ),
                    SizedBox(
                      height: kToolbarHeight / 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
