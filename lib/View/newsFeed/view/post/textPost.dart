import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/CustomAlert.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/dividerClass.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Forum/Model/forumDetailsModel.dart';
import 'package:bloodlines/View/Forum/View/placeholder.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/readmore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:shimmer/shimmer.dart';

class TextPost extends StatelessWidget {
  const TextPost(
      {super.key,
      this.title =
          "Healthy puppy body temperature is 38.5 degrees -39.5 degrees, normal?",
      this.profileImage = "assets/profile/2.png",
      this.name = "Ernest Guzman",
      this.description =
          "A healthy puppy's body temperature ranges from 38 to 39 degrees, and is slightly higher in the afternoon. The temperature difference between day and night is generally less than 1 degree. A healthy puppy's body temperature ranges from 38 to 39 degrees, and is slightly higher in the afternoon. The temperature difference between day and night is generally less than 1 degree",
      this.radius = 0,
      this.likes = "113 Likes",
      this.forumDetailsData,
      required this.topicId,
      this.respond = "50 Answers"});
  final String title;
  final String profileImage;
  final String name;
  final String description;
  final double? radius;
  final String likes;
  final String respond;
  final int topicId;
  final ForumDetailsData? forumDetailsData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        color: DynamicColors.primaryColorLight,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: Utils.width(context) / 1.3,
                  child: Text(
                    forumDetailsData!.title!,
                    style: montserratRegular(fontSize: 17),
                  ),
                ),
                Spacer(),
               GestureDetector(
                        onTap: () {
                          Get.bottomSheet(BottomSheetTopicEdit(
                              result: forumDetailsData!, topicId: topicId));
                        },
                        child: Icon(Icons.more_vert)),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              forumDetailsData!.content ?? "",
              style: montserratRegular(fontSize: 13),
            ),
            // DividerClass(),
            SizedBox(
              height: 15,
            ),
            forumDetailsData!.media == null
                ? Container()
                : Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.toNamed(Routes.photo,arguments: {
                            "image":forumDetailsData!.media!,
                          });
                        },
                        child: OptimizedCacheImage(
                            imageUrl: forumDetailsData!.media!,
                            fit: BoxFit.cover,
                            width: Utils.width(context),
                            height: Utils.height(context) / 4),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
            forumDetailsData!.responses!.isEmpty
                ? Container()
                : Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                                image: NetworkImage(forumDetailsData!
                                    .responses![0]
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
                        forumDetailsData!
                            .responses![0].user!.profile!.fullname!,
                        style: montserratRegular(fontSize: 12),
                      ),
                    ],
                  ),
            SizedBox(
              height: forumDetailsData!.responses!.isEmpty ? 0 : 10,
            ), //Look at all
            ReadMoreText(
              forumDetailsData!.responses!.isEmpty
                  ? ""
                  : forumDetailsData!.responses![0].content!,
              style: montserratRegular(
                  fontSize: 14, color: DynamicColors.accentColor),
              moreStyle: montserratRegular(
                  fontSize: 14, color: DynamicColors.primaryColorRed),
              lessStyle: montserratRegular(
                  fontSize: 14, color: DynamicColors.primaryColorRed),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  forumDetailsData!.responses!.isEmpty
                      ? "0 likes"
                      : "${forumDetailsData!.responses![0].totalLikes!.toString()} ${forumDetailsData!.responses![0].totalLikes == 1 ? 'like' : 'likes'}",
                  style: montserratLight(
                      fontSize: 12,
                      color: DynamicColors.accentColor.withOpacity(0.6)),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "${forumDetailsData!.responses!.length.toString()} ${forumDetailsData!.responses!.length == 1 ? 'response' : 'responses'}",
                  style: montserratLight(
                      fontSize: 12,
                      color: DynamicColors.accentColor.withOpacity(0.6)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetTopicEdit extends StatelessWidget {
  BottomSheetTopicEdit({super.key, required this.result, required this.topicId});
  ForumDetailsData result;
  int topicId;
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
                          titleText: "Do you want to report this topic?",
                          click: () {
                            Get.back();
                            controller.reportPost(postId:result.id!, type: "topic",commentPostId: topicId);
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
                          "Report Topic",
                          style: poppinsRegular(
                              color: DynamicColors.textColor,
                              fontSize: Utils.height(context) / 60),
                        )
                      ],
                    ),
                  ),
                ),
                result.user!.id != Api.singleton.sp.read("id")?Container():     SizedBox(
                  height: 15,
                ),
                result.user!.id != Api.singleton.sp.read("id")?Container():     Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      // controller.deleteTopic(result.id!,topicId);

                      alertCustomMethod(context,
                          theme: DynamicColors.primaryColor,
                          titleText: "Do you want to delete this topic?",
                          click: () {
                        Get.back();
                        controller.deleteTopic(result.id!, topicId);
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
                          "Delete Topic",
                          style: poppinsRegular(
                              color: DynamicColors.textColor,
                              fontSize: Utils.height(context) / 60),
                        )
                      ],
                    ),
                  ),
                ),
                result.user!.id != Api.singleton.sp.read("id")?Container():     Divider(
                  color: DynamicColors.textColor,
                  height: 15,
                ),
                result.user!.id != Api.singleton.sp.read("id")?Container():     Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.createTopic,
                          arguments: {"model": result, "id": topicId});
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
                          "Edit Topic",
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
