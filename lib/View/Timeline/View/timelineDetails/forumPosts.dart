import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Forum/Model/forumDetailsModel.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/view/post/textPost.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimelineForum extends StatelessWidget {
  TimelineForum({Key? key, required this.forumList}) : super(key: key);
  final List<ForumDetailsData> forumList;
  FeedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: forumList.length,
        itemBuilder: (context, index) {
          ForumDetailsData forumDetailsData = forumList[index];
          return GestureDetector(
            onTap: () {
              controller.getTopicDetails(forumList[index].id!);
              Get.toNamed(Routes.forumRespond, arguments: {
                "model": forumDetailsData,
                "forumId": forumList[index].id!,
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                      forumDetailsData: forumDetailsData,
                      topicId: forumList[index].id!,
                    )),
              ),
            ),
          );
        });
  }
}
