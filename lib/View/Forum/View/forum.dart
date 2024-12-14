import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/Forum/Model/forumModel.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Forum extends StatelessWidget {
  Forum({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedController>(builder: (controller) {
      if(controller.forumModel == null){
        return Center(
          child: LoaderClass(),
        );
      }
      if(controller.forumModel!.data!.data!.isEmpty){
        return Center(
          child: Text(
            "No Data",
            style: poppinsBold(fontSize: 25),
          ),
        );
      }
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Forums",
                  style: montserratSemiBold(fontSize: 24),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: controller.forumModel!.data!.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        controller.getAllTopic(controller.forumModel!.data!.data![index].id!);
                        Get.toNamed(Routes.forumDetails,
                            arguments: {"forum": controller.forumModel!.data!.data![index]});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300]!,
                                blurRadius: 10.0,
                              ),
                            ],
                          ),
                          child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset(
                                      "assets/forum/1.png",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      SizedBox(
                                        width: Utils.width(context) / 1.6,
                                        child: Text(
                                          controller.forumModel!.data!.data![index].title!,
                                          style: montserratSemiBold(
                                              fontSize: 20),
                                        ),
                                      ),
                                      Text(
                                        "${controller.forumModel!.data!.data![index].forumsCount} Questions",
                                        style: montserratBold(
                                            fontSize: 12,
                                            color: DynamicColors
                                                .primaryColorRed),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      );
    });
  }
}
