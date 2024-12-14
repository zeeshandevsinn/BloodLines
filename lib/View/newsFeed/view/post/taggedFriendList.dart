// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/CircleImage.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaggedFriendListScreen extends StatelessWidget {
  final FeedController controller = Get.find();

  List<UserModel>? taggedFriend = Get.arguments["list"];

  @override
  Widget build(BuildContext context) {
    double heights = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: DynamicColors.primaryColorLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: AppBarWidgets(),
          title: Text(
            "Tagged List",
            style:
            poppinsLight(fontSize: 28, color: DynamicColors.primaryColor),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: heights / 45,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Tagged Friends",
                            style: poppinsBold(
                                color: DynamicColors.textColor,
                                fontSize: heights / 25))
                      ],
                    )),
                SizedBox(
                  height: heights / 45,
                ),
                SingleChildScrollView(
                  child: GetBuilder<FeedController>(builder: (controller) {
                    return ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: taggedFriend!.length,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          UserModel result = taggedFriend![index];
                          if(result.isReported == 1){
                            return Container();
                          }
                          return GestureDetector(
                            onTap: () {
                              Utils.onNavigateTimeline(result.id!);

                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  CircleImage(
                                    customHeight: 24,
                                    imageString: result.profile!
                                        .profileImage!,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${result.profile!.fullname}",
                                    style: poppinsBold(
                                      fontSize: 20,
                                      // fontWeight: FontWeight.w100,
                                      color: DynamicColors.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }),
                )
              ],
            ),
          ),
        ));
  }
}
