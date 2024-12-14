// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/Groups/Model/groupModel.dart';
import 'package:bloodlines/View/Groups/View/groupDetails/groupInviteList.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/view/event/components/eventWidget.dart';
import 'package:bloodlines/View/newsFeed/view/post/postDetails.dart';
import 'package:bloodlines/View/newsFeed/view/post/postWidget.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';

import 'package:fluttericon/iconic_icons.dart';
import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class GroupItemsClass extends StatelessWidget {
  FeedController controller = Get.find();
  GroupItemsClass(
      {Key? key,
      required this.model,
      this.premium = false,
      this.myGroup = false,
      this.joined = false})
      : super(key: key);

  GroupData model;
  bool premium;
  bool myGroup;
  bool joined;

  final settings = RestrictedPositions(
    maxCoverage: 0.5,
    minCoverage: 0.2,
    align: StackAlign.left,
  );

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: DynamicColors.primaryColorLight.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child:
            GestureDetector(
              onTap: (){
                Get.toNamed(Routes.photo,arguments: {"image":model.photo!,"type":"network"});
              },
              child: OptimizedCacheImage(
                imageUrl:
                model.photo!,
                width: Utils.width(context),
                height: Utils.height(context) /6,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // locationMethod(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    model.name!,
                    style: poppinsRegular(fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: width / 1.8,
                        child: WidgetStack(
                          positions: settings,
                          stackedWidgets: [
                            for (var n = 0; n < model.groupMembers!.length; n++)
                              model.groupMembers![n].user == null?Container():   GestureDetector(
                                onTap: (){
                                  Utils.onNavigateTimeline(model.groupMembers![n].user!.id!);
                                },
                                child: Container(
                                  width: 50,height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: DynamicColors.accentColor)
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: OptimizedCacheImage(imageUrl:model.groupMembers![n].user!.profile!.profileImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),


                                //
                                // Container(
                                //   width: 50,height: 50,
                                //     decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       border: Border.all(color: DynamicColors.primaryColorRed)
                                //     ),
                                //     child: ClipRRect(
                                //       borderRadius: BorderRadius.circular(100),
                                //       child: Image.network(
                                //         model.groupMembers![n].user!.profile!.profileImage!,
                                //         fit: BoxFit.cover,
                                //       ),
                                //     )),
                              ),
                          ],
                          buildInfoWidget: (surplus) {
                            return SizedBox.shrink();
                          },
                        ),
                      ),
                      //
                      Spacer(),
                      // SizedBox(
                      //   width: 10,
                      // ),
                     model.isJoined != "joined"?Container(): CustomButton(
                        text: "+ Invite",
                        isLong: false,
                        onTap: () {
                          Get.bottomSheet(
                            SizedBox(
                                height: Utils.height(context) / 1.2,
                                child: GroupInviteClass(
                                  id: model.id!,
                                )),
                            isScrollControlled: true,
                            enableDrag: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30))),
                          );
                        },
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        borderColor: DynamicColors.primaryColorRed,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        style: poppinsRegular(
                            fontSize: 10, color: DynamicColors.primaryColorRed),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  locationMethod(),
                  SizedBox(
                    height: 10,
                  ),
                  premium == true
                      ? CustomButton(
                          onTap: () {
                            Get.bottomSheet(
                              SubscribeBottomSheet(data: model,),
                              isScrollControlled: true,
                              enableDrag: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30))),
                            );
                          },
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          borderColor: DynamicColors.primaryColorRed,
                          color: DynamicColors.whiteColor,
                          borderRadius: BorderRadius.circular(5),
                          style: poppinsRegular(
                              fontSize: 10,
                              color: DynamicColors.primaryColorRed),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image.asset(
                                "assets/subscribe.png",
                                height: 15,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                               model.isJoined == "joined"?"Subscribed": "Subscribe",
                                style: montserratRegular(
                                    fontSize: 12,
                                    color: DynamicColors.primaryColorRed),
                              ),
                            ],
                          ),
                        )
                      : joined == true
                          ? CustomButton(
                              text: "Joined",
                              onTap: () {
                                // if (formKey.currentState!.validate()) {}
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              borderColor: Colors.transparent,
                              color: DynamicColors.primaryColorRed
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                              style: poppinsRegular(
                                  fontSize: 10,
                                  color: DynamicColors.primaryColorRed),
                            )
                          : myGroup == true
                              ? CustomButton(
                                  text: "Edit",
                                  onTap: () {
                                    // if (formKey.currentState!.validate()) {}
                                  },
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  borderColor: Colors.transparent,
                                  color: DynamicColors.primaryColorRed
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(5),
                                  style: poppinsRegular(
                                      fontSize: 10,
                                      color: DynamicColors.primaryColorRed),
                                )
                              : CustomButton(
                                  text: "Join Group",
                                  onTap: () {
                                    controller.groupAcceptOrRejectRequest(model.id!, "join");
                                    // if (formKey.currentState!.validate()) {}
                                  },
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  borderColor: Colors.transparent,
                                  color: DynamicColors.primaryColorRed
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(5),
                                  style: poppinsRegular(
                                      fontSize: 10,
                                      color: DynamicColors.primaryColorRed),
                                ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: DynamicColors.textColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Description",
                    style: poppinsSemiBold(color: DynamicColors.primaryColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    model.description!,
                    style: poppinsRegular(
                        color: DynamicColors.textColor, fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: DynamicColors.textColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            premium == true && model.isJoined != "joined" ? premiumWidget() : postWidget()
          ]),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget postWidget(){
    if( controller.groupPosts == null){
      return Container();
    }
    return ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: controller.groupPosts!.postModel!.length,
        itemBuilder: (context,index){
      return PostClass(result: controller.groupPosts!.postModel![index], index: index,fromGroup: true,);
    });
  }

  Widget premiumWidget() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: DynamicColors.primaryColorRed)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Image.asset("assets/group.png",
                    height: 20, color: DynamicColors.primaryColorRed),
              )),
          SizedBox(
            height: 20,
          ),
          Text(
            "Premium Group",
            style: montserratSemiBold(fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Subscribe to view group posts",
            style: montserratRegular(fontSize: 14),
          )
        ],
      ),
    );
  }

  Row locationMethod() {
    return Row(
      children: [
        Text(
          "${model.groupMembers!.length} members",
          style: poppinsSemiBold(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        Spacer(),
        premium == true
            ? Text(
                "10 posts daily",
                style:
                    poppinsSemiBold(fontSize: 12, fontWeight: FontWeight.w400),
              )
            : Row(
                children: [
                  Icon(
                    Iconic.clock,
                    color: Colors.redAccent,
                    size: 13,
                  ),
                  Text(
                    DateFormat("EEE-dd-MM-yy | HH:mm").format(model.createdAt!),
                    // "Sat-25-10-22 | 16:25:00",
                    style: poppinsLight(
                        fontSize: 12,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }

  Widget interestedBottom() {
    return Wrap(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          child: Container(
            decoration: BoxDecoration(
              color: DynamicColors.primaryColorLight,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        height: 5,
                        width: 70,
                        decoration: BoxDecoration(
                            color: DynamicColors.primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextWidget("Going", "365"),
                    SizedBox(
                      height: 20,
                    ),
                    TextWidget("Interested", "1k"),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SubscribeBottomSheet extends StatelessWidget {
  const SubscribeBottomSheet({Key? key,this.data}) : super(key: key);
  final GroupData? data;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          child: Container(
            decoration: BoxDecoration(
              color: DynamicColors.primaryColorLight,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    Center(
                      child: Text(
                        "Subscriber Benefits",
                        style: montserratBold(fontSize: 24),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Monthly Subscription",
                          style: montserratBold(fontSize: 20),
                        ),
                        Spacer(),
                        Text(
                          "\$ 1.99",
                          style: montserratBold(
                              fontSize: 20,
                              color: DynamicColors.primaryColorRed),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "1. Lorem ipsum dolor sit amet, consetetur sadipscing",
                      style: poppinsRegular(fontSize: 12),
                    ),
                    Text(
                      "2. sed diam nonumy eirmod tempor invidunt utaccusam et justo duo dolores et ea rebum.",
                      style: poppinsRegular(fontSize: 12),
                    ),
                    Text(
                      "3. dolore magna aliquyam erat, sed diam voluptuao",
                      style: poppinsRegular(fontSize: 12),
                    ),
                    Text(
                      "4. eos et accusam et justo duo dolores et ea rebum.",
                      style: poppinsRegular(fontSize: 12),
                    ),
                    Text(
                      "5. clita kasd gubergren, no sea takimata sanctus est",
                      style: poppinsRegular(fontSize: 12),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: CustomButton(
                        text:data!.isJoined == "joined"?"Subscribed": "Subscribe",
                        isLong: false,
                        onTap: () {
                          if(data!.isJoined != "joined"){
                            Get.toNamed(Routes.paymentMethod);
                          }
                        },
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        borderColor: DynamicColors.primaryColorRed,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        style: poppinsRegular(
                            fontSize: 14, color: DynamicColors.primaryColorRed),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
