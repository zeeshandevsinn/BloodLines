import 'dart:io';

import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/Forum/Model/forumDetailsModel.dart';
import 'package:bloodlines/View/Forum/Model/forumModel.dart';
import 'package:bloodlines/View/Forum/View/placeholder.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/view/post/textPost.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ForumDetails extends StatelessWidget {
  ForumDetails({super.key});
  ForumModelData model = Get.arguments["forum"];
  FeedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Utils.height(context) / 5,
              child: Stack(
                children: [
                  Image.asset(
                    "assets/forum/forumCover.png",
                    fit: BoxFit.fill,
                    width: Utils.width(context),
                  ),
                  Positioned(
                      top: Platform.isIOS ? 30 : 20,
                      left: 10,
                      child: AppBarWidgets(
                        margin: 0,
                        width: 60,height: 60,
                        decorationColor: Colors.black87,
                        color: DynamicColors.whiteColor,
                      )),
                  Positioned(
                    bottom: 10,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Utils.width(context) / 1.6,
                          child: Text(
                            model.title!,
                            style: montserratSemiBold(
                                fontSize: 20, color: DynamicColors.whiteColor),
                          ),
                        ),
                        Text(
                          "${model.forumsCount} Questions",
                          style: montserratBold(
                              fontSize: 12, color: DynamicColors.whiteColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              color: DynamicColors.blueColor.withOpacity(0.3),
              text: "Create Topic",
              onTap: (){
                Get.toNamed(Routes.createTopic,arguments: {
                  "id":model.id
                });
              },
              isLong: false,
              borderRadius: BorderRadius.circular(2),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              borderColor: Colors.transparent,
              style: montserratSemiBold(color: DynamicColors.blueColor),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: DynamicColors.accentColor,
            ),
        GetBuilder<FeedController>(builder: (controller){
          return  controller.topicModel == null?   Shimmer.fromColors(
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
          ):
          ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount:   controller.topicModel!.data!.data!.length,
              itemBuilder: (context, index) {
                ForumDetailsData forumDetailsData =  controller.topicModel!.data!.data![index];
                if(forumDetailsData.isReported == 1){
                  return Container();
                }
                return GestureDetector(
                  onTap: () {
                    controller.getTopicDetails(controller.topicModel!.data!.data![index].id!);
                    Get.toNamed(Routes.forumRespond, arguments: {
                      "model": forumDetailsData,
                      "forumId": model.id,
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
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
                          child: TextPost(
                            forumDetailsData:forumDetailsData,
                            topicId:model.id!
                          )),
                    ),
                  ),
                );
              });
        })

          ],
        ),
      ),
    );
  }
}
