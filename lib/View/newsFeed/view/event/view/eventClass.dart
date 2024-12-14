import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/View/newsFeed/model/eventsModel.dart';
import 'package:bloodlines/View/newsFeed/view/event/components/eventWidget.dart';
import 'package:bloodlines/View/newsFeed/view/event/view/eventItems.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventClass extends StatefulWidget {
  EventClass({Key? key}) : super(key: key);

  @override
  State<EventClass> createState() => _EventClassState();
}

class _EventClassState extends State<EventClass> {
  bool myEvent = Get.arguments["myEvent"] ?? false;

  bool fromDetails = Get.arguments["fromDetails"] ?? false;

  EventsData data = Get.arguments["data"];

  int index = Get.arguments["index"];

  final FeedController controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.eventsData = data;
  }

  Future<bool> onWillPop() async {
    controller.eventsData = null;
    Get.back();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: GetBuilder<FeedController>(builder: (controller) {
        return Scaffold(
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
              myEvent == false ? "Event Details" : "My Event",
              style: poppinsSemiBold(
                  color: DynamicColors.primaryColor, fontSize: 28),
            ),
            elevation: 0,
            actions: [
              AppBarWidgets(
                height: 50,
                width: 50,
                onTap: () {
                  // if (controller.eventsData!.user!.id ==
                  //     Api.singleton.sp.read("id")) {
                  //   Get.bottomSheet(EventBottomSheet(
                  //     result: controller.eventsData!,
                  //   ), enableDrag: true,
                  //     isScrollControlled: true,
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.only(
                  //             topRight: Radius.circular(30),
                  //             topLeft: Radius.circular(30))),);
                  // }

                  Get.bottomSheet(EventBottomSheet(
                    result: controller.eventsData!,
                  ), enableDrag: true,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30))),);
                },
                color: DynamicColors.primaryColorRed,
                assetImage: "assets/icons/info.png",
                size: 20,
                margin: 2,
                padding: EdgeInsets.all(8),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                EventItemsClass(
                    fromDetails: true,
                    myEvent: myEvent,
                    data: controller.eventsData!,
                    index: index),
              ],
            ),
          ),
        );
      }),
    );
  }
}
