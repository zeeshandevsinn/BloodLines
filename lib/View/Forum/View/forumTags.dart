// ignore_for_file: invalid_use_of_protected_member

import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Pedigree/Data/pedigreeController.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/userModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class ForumTagPeople extends StatelessWidget {
  ForumTagPeople({Key? key}) : super(key: key);
  FeedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: AppBarWidgets(
          isCardType: true,
        ),
        title: Text(
          "Tag People",
          style: montserratSemiBold(fontSize: 16),
        ),
      ),
      body: GetBuilder<FeedController>(builder: (controller) {
        if (controller.followings == null) {
          return Center(
            child: LoaderClass(),
          );
        }
        if (controller.followings!.data!.isEmpty) {
          return Center(
            child: Text(
              "No Data",
              style: poppinsBold(fontSize: 25),
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: controller.followings!.data!.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    UserModel user = controller.followings!.data![index].users!;
                    if (controller.forumTaggedUser
                        .any((element) => element.id == user.id)) {
                      user.isTagSelected!.value = true;
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: SizedBox(
                                child: OptimizedCacheImage(
                                  imageUrl: user.profile!.profileImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            user.profile!.fullname!,
                            style: poppinsRegular(),
                          ),
                          Spacer(),
                          Obx(() {
                            return InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              onTap: () {
                                user.isTagSelected!.value =
                                    !user.isTagSelected!.value;
                                if (user.isTagSelected!.value == true) {
                                  controller.forumTaggedUserList.add(user.id!);
                                  controller.forumTaggedUser.add(user);
                                  controller.update();
                                } else {
                                  controller.forumTaggedUserList.removeWhere(
                                      (element) => element == user.id);
                                  controller.forumTaggedUser.value.removeWhere(
                                      (element) => element.id == user.id);
                                  controller.update();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: user.isTagSelected!.value == false
                                        ? DynamicColors.accentColor
                                        : DynamicColors.primaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.check,
                                    color: DynamicColors.whiteColor,
                                    size: 15,
                                  ),
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    );
                  }),
            ],
          ),
        );
      }),
    );
  }
}

class ForumTagPedigree extends StatelessWidget {
  ForumTagPedigree({Key? key}) : super(key: key);
  FeedController controller = Get.find();
  PedigreeController pedigreeController = Get.find();
  final RxInt _current = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: AppBarWidgets(
          isCardType: true,
        ),
        title: Text(
          "Tag Pedigree",
          style: montserratSemiBold(fontSize: 16),
        ),
      ),
      body: GetBuilder<PedigreeController>(builder: (pedigreeController) {
        if (pedigreeController.pedigreeModel == null) {
          return Center(
            child: LoaderClass(),
          );
        }
        if (pedigreeController.pedigreeModel!.data!.isEmpty) {
          return Center(
            child: Text(
              "No Data",
              style: poppinsBold(fontSize: 25),
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: pedigreeController.pedigreeModel!.data!.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    PedigreeSearchData pedigreeData =
                        pedigreeController.pedigreeModel!.data![index];
                    if (controller.forumTaggedPedigreeList
                        .any((element) => element.id == pedigreeData.id)) {
                      pedigreeData.isSelected!.value = true;
                    }
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.pedigreeTree,
                            arguments: {"id": pedigreeData.id});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          children: [
                            pedigreeData.photos == null ||
                                    pedigreeData.photos!.isEmpty
                                ? Container()
                                : SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Stack(children: [
                                      SizedBox(
                                        height: 60,
                                        child: CarouselSlider.builder(
                                            itemCount:
                                                pedigreeData.photos!.length,
                                            itemBuilder: (BuildContext context,
                                                    int i, int pageViewIndex) =>
                                                InkWell(
                                                  highlightColor: DynamicColors
                                                      .primaryColor
                                                      .withOpacity(0.1),
                                                  onTap: () {
                                                    Get.toNamed(Routes.photo,
                                                        arguments: {
                                                          "image": pedigreeData
                                                              .photos![i].photo!
                                                        });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                        image: DecorationImage(
                                                            image:
                                                                OptimizedCacheImageProvider(
                                                              pedigreeData
                                                                  .photos![i]
                                                                  .photo!,
                                                            ),
                                                            alignment: Alignment
                                                                .topCenter,
                                                            fit: BoxFit.cover)),
                                                  ),
                                                ),
                                            options: CarouselOptions(
                                              initialPage: 0,
                                              enableInfiniteScroll: false,
                                              reverse: false,
                                              autoPlay: false,
                                              autoPlayInterval:
                                                  Duration(seconds: 3),
                                              autoPlayAnimationDuration:
                                                  Duration(milliseconds: 800),
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              enlargeCenterPage: false,
                                              aspectRatio: 16 / 9,
                                              viewportFraction: 1,
                                              onPageChanged: (value, reason) {
                                                _current.value = value;
                                              },
                                              scrollDirection: Axis.horizontal,
                                            )),
                                      ),
                                      Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Obx(() {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: pedigreeData.photos!
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                return Container(
                                                  width: 6.0,
                                                  height: 6.0,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 4.0),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: (Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                              : DynamicColors
                                                                  .primaryColorRed)
                                                          .withOpacity(
                                                              _current.value ==
                                                                      entry.key
                                                                  ? 0.9
                                                                  : 0.4)),
                                                );
                                              }).toList(),
                                            );
                                          })),
                                    ])),
                            SizedBox(
                              width: 10,
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "${pedigreeData.ownerName} ",
                                    style: poppinsRegular(
                                        fontSize: 12,
                                        color: DynamicColors.primaryColor)),
                                TextSpan(
                                    text: pedigreeData.beforeNameTitle == null
                                        ? ""
                                        : "${pedigreeData.beforeNameTitle!.toUpperCase()} ",
                                    style: poppinsRegular(
                                        fontSize: 12,
                                        color: DynamicColors.primaryColorRed)),
                                TextSpan(
                                    text: "${pedigreeData.dogName} ",
                                    style: poppinsRegular(
                                        fontSize: 12,
                                        color: DynamicColors.primaryColor)),
                                TextSpan(
                                    text: pedigreeData.afterNameTitle == null
                                        ? ""
                                        : "${pedigreeData.afterNameTitle!.toUpperCase()} ",
                                    style: poppinsRegular(
                                        fontSize: 12,
                                        color: DynamicColors.primaryColor)),
                              ]),
                            ),
                            Spacer(),
                            Obx(() {
                              return InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                onTap: () {
                                  pedigreeData.isSelected!.value =
                                      !pedigreeData.isSelected!.value;
                                  if (pedigreeData.isSelected!.value == true) {
                                    controller.forumPedigreeList
                                        .add(pedigreeData.id!);
                                    controller.forumTaggedPedigreeList
                                        .add(pedigreeData);
                                    controller.update();
                                  } else {
                                    controller.forumPedigreeList.removeWhere(
                                        (element) =>
                                            element == pedigreeData.id);
                                    controller.forumTaggedPedigree.value
                                        .removeWhere((element) =>
                                            element.id == pedigreeData.id);
                                    controller.update();
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: pedigreeData.isSelected!.value ==
                                              false
                                          ? DynamicColors.accentColor
                                          : DynamicColors.primaryColor),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.check,
                                      color: DynamicColors.whiteColor,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        );
      }),
    );
  }
}
