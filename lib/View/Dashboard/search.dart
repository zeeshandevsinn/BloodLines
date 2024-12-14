// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Dummy.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/textField.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Classified/View/classifiedDetails/productAndServices.dart';
import 'package:bloodlines/View/Groups/Model/groupModel.dart';
import 'package:bloodlines/View/Groups/View/groupDetails/myGroups.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/model/eventsModel.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/View/newsFeed/view/event/view/eventItems.dart';
import 'package:bloodlines/View/newsFeed/view/post/postDetails.dart';
import 'package:bloodlines/View/newsFeed/view/post/postMoreDetails.dart';
import 'package:bloodlines/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class SearchClass extends StatelessWidget {
  SearchClass({Key? key}) : super(key: key);
  RxList<String> tags = <String>[].obs;
  FeedController controller = Get.find();

  searchHit() {
    if (controller.searchTextController.text.isNotEmpty) {
      controller.getSearchedData(isProgressShow: true);
    }
  }

  List<String> selection = [
    "Posts",
    "Pedigree",
    "Peoples",
    "Groups",
    "Events",
    "Classified",
  ];

  String select(String value) {
    switch (value) {
      case "Posts":
        return "post";
      case "Pedigree":
        return "pedigree";
      case "Groups":
        return "group";
      case "Events":
        return "event";
      case "Classified":
        return "classified";
      default:
        return "user";
    }
  }


  Widget searchCheck(context, String value) {
    switch (value) {
      case "post":
        if(controller.searchedUsersList.value!.postData == null){
          return Padding(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 4),
              child: LoaderClass()
          );
        }
        if (controller.searchedUsersList.value!.postData!.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 4),
              child: Text(
                "No Data",
                style: poppinsBold(fontSize: 25),
              ),
            ),
          );
        }
        return ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.searchedUsersList.value!.postData!.length,
            itemBuilder: (context, index) {
              PostModel model = controller.searchedUsersList.value!
                  .postData![index];

              return PostMoreDetails(
                result: model, index: index,fromSearch: true,);
            });
      case "pedigree":
        if(controller.searchedUsersList.value!.pedigreeData == null){
          return Padding(
            padding: EdgeInsets.only(top: MediaQuery
                .of(context)
                .size
                .height / 4),
            child: LoaderClass()
          );
        }
        if (controller.searchedUsersList.value!.pedigreeData!.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 4),
              child: Text(
                "No Data",
                style: poppinsBold(fontSize: 25),
              ),
            ),
          );
        }
        return ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.searchedUsersList.value!.pedigreeData!.length,
            itemBuilder: (context, index) {
              PedigreeSearchData model = controller.searchedUsersList.value!
                  .pedigreeData![index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.pedigreeTree, arguments: {
                    "id": model.id
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: DynamicColors.accentColor)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: OptimizedCacheImage(
                            imageUrl:model.photos!.isEmpty?dummyProfile: model.photos![0].photo!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "${model.ownerName} ",
                                  style: poppinsRegular(
                                      fontSize: 12, color: DynamicColors.primaryColor)),
                              TextSpan(
                                  text: model.beforeNameTitle == null
                                      ? ""
                                      : "${model.beforeNameTitle!.toUpperCase()} ",
                                  style: poppinsRegular(
                                      fontSize: 12, color: DynamicColors.primaryColorRed)),
                              TextSpan(
                                  text: "${model.dogName} ",
                                  style: poppinsRegular(
                                      fontSize: 12, color: DynamicColors.primaryColor)),
                              TextSpan(
                                  text: model.afterNameTitle == null
                                      ? ""
                                      : "${model.afterNameTitle!.toUpperCase()} ",
                                  style: poppinsRegular(
                                      fontSize: 12, color: DynamicColors.primaryColorRed)),
                            ]),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      case "group":
        if(controller.searchedUsersList.value!.groupData == null){
          return Padding(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 4),
              child: LoaderClass()
          );
        }
        if (controller.searchedUsersList.value!.groupData!.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 4),
              child: Text(
                "No Data",
                style: poppinsBold(fontSize: 25),
              ),
            ),
          );
        }
        return ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.searchedUsersList.value!.groupData!.length,
            itemBuilder: (context, index) {
              GroupData model = controller.searchedUsersList.value!
                  .groupData![index];
              return GroupDataWidget(data: model);
            });
      case "event":
        if(controller.searchedUsersList.value!.eventData == null){
          return Padding(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 4),
              child: LoaderClass()
          );
        }
        if (controller.searchedUsersList.value!.eventData!.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 4),
              child: Text(
                "No Data",
                style: poppinsBold(fontSize: 25),
              ),
            ),
          );
        }
        return ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.searchedUsersList.value!.eventData!.length,
            itemBuilder: (context, index) {
              EventsData model = controller.searchedUsersList.value!
                  .eventData![index];
              return EventItemsClass(data: model, index: index);
            });

      case "classified":
        if(controller.searchedUsersList.value!.classifiedData == null){
          return Padding(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 4),
              child: LoaderClass()
          );
        }
        if (controller.searchedUsersList.value!.classifiedData!.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 4),
              child: Text(
                "No Data",
                style: poppinsBold(fontSize: 25),
              ),
            ),
          );
        }
        return ListResult(
            type: "classified");
      default:
        if(controller.searchedUsersList.value!.userData == null){
          return Padding(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 4),
              child: LoaderClass()
          );
        }
        if (controller.searchedUsersList.value!.userData!.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 4),
              child: Text(
                "No Data",
                style: poppinsBold(fontSize: 25),
              ),
            ),
          );
        }
        return ListResult(
            type: "user");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                height: Platform.isIOS ? 50 : 40,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      filled: true,
                      isUnderLineBorder: false,
                      controller: controller.searchTextController,
                      mainPadding: EdgeInsets.zero,
                      padding: EdgeInsets.only(left: 10, top: 12),
                      radius: 5,
                      hint: "Something search here",
                      isBorder: true,
                      isTransparentBorder: true,
                      fillColor: Colors.grey[200]!,
                      onFieldSubmitted: (value) {
                        searchHit();
                      },
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      "Cancel",
                      style: montserratSemiBold(
                          color: DynamicColors.primaryColorRed),
                    ),
                  )
                ],
              ),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: selection.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 2),
                itemBuilder: (context, index) {
                  return Obx(() {
                    return LikeButton(
                      onTap: (a) {
                        controller.searchFilters.value = index;
                        controller.searchValue = select(selection[index]);
                        searchHit();
                        return Future.value(true);
                      },

                      circleColor: CircleColor(
                          start: DynamicColors.primaryColor,
                          end: DynamicColors.primaryColor.withOpacity(0.5)),
                      bubblesColor: BubblesColor(
                          dotPrimaryColor: DynamicColors.primaryColor,
                          dotSecondaryColor:
                          DynamicColors.primaryColor.withOpacity(0.5)),
                      size: Utils.width(context) / 3.5,
                      likeBuilder: (bool isLiked) {
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller.searchFilters.value == index
                                  ? DynamicColors.primaryColor
                                  : Colors.transparent,
                              border: Border.all(
                                color: controller.searchFilters.value == index
                                    ? Colors.transparent
                                    : DynamicColors.primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              selection[index],
                              style: poppinsLight(
                                  fontSize: 12,
                                  color: controller.searchFilters.value == index
                                      ? DynamicColors.primaryColorLight
                                      : DynamicColors.primaryColor),
                            ),
                          ),
                        );
                      },
                      isLiked:
                      controller.searchFilters.value == index ? true : false,
                      // likeCount: likeCount,
                    );
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              Obx(() {
                if(controller.searchedUsersList.value == null){
                  return Container();
                }
                return searchCheck(context, controller.searchValue);
              })
            ],
          ),
        ),
      ),
    );
  }
}

class ListResult extends StatelessWidget {
  ListResult({
    super.key,
    required this.type,
  });

  final FeedController controller = Get.find();
  String type;

  @override
  Widget build(BuildContext context) {
    if (type == "classified") {
      return ProductAndServices(
          classifiedAdDataList:
          controller.searchedUsersList.value!.classifiedData ?? []);
    }
    if (controller.searchedUsersList.value!.userData!.isEmpty) {
      return Center(
        child: Text(
          "No Data",
          style: poppinsBold(fontSize: 25),
        ),
      );
    }
    return ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: controller.searchedUsersList.value!.userData!.length,
        itemBuilder: (context, index) {
          UserModel user = controller.searchedUsersList.value!.userData![index];
          if (user.profile == null) {
            return Container();
          }
          return GestureDetector(
            onTap: () {
              Utils.onNavigateTimeline(
                user.id!,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
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
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.profile!.fullname!,
                        style: poppinsRegular(fontSize: 15),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
