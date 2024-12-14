// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/View/newsFeed/view/post/postMoreDetails.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarouselSliderDetails extends StatefulWidget {
  CarouselSliderDetails({Key? key}) : super(key: key);

  @override
  State<CarouselSliderDetails> createState() => _CarouselSliderDetailsState();
}

class _CarouselSliderDetailsState extends State<CarouselSliderDetails> {
  final PostModel result = Get.arguments["result"];

  // final int positionalIndex = Get.arguments["positionalIndex"];
  final bool fromSearch = Get.arguments["fromSearch"] ?? false;

  final bool fromBottom = Get.arguments["fromBottom"] ?? false;
  final bool fromSave = Get.arguments["fromSave"] ?? false;
  final bool fromTimeline = Get.arguments["fromTimeline"] ?? false;
  final bool fromGroup = Get.arguments["fromGroup"] ?? false;
  final bool fromDetails = Get.arguments["fromDetails"] ?? false;
  final bool fromFriendTimeline = Get.arguments["fromFriendTimeline"] ?? false;
  final int index = Get.arguments["index"];

  final FeedController controller = Get.find();

  @override
  void initState() {
    controller.postModelData = result;
    super.initState();
    if (Get.arguments["fromNotification"] != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedController>(builder: (controller) {
      return Scaffold(
        backgroundColor: DynamicColors.primaryColorLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: AppBarWidgets(
            onTap: (){
              Get.back();
            },
          ),
          title: Text(
            "Post Details",
            style: poppinsSemiBold(
                color: DynamicColors.primaryColor, fontSize: 28),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PostMoreDetails(
            result: result,
            index: index,
            fromGroup: fromGroup,
            fromDetails: true,
            fromSearch: fromSearch,
            fromBottom: fromBottom,
            fromSave: fromSave,
            fromTimeline: fromTimeline,
            fromFriendTimeline: fromFriendTimeline,
          ),
        ),
      );
    });
  }
}
