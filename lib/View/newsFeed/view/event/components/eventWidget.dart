import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/CustomAlert.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/model/eventsModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(this.title, this.subtitle, {super.key});

  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 16),
        ),
        Text(
          subtitle,
          style: poppinsRegular(fontSize: 15),
        ),
      ],
    );
  }
}

class EventBottomSheet extends StatelessWidget {
    EventBottomSheet({super.key, required this.result});
  final EventsData result;
  FeedController controller = Get.find();

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
                      height: 10,
                    ),
                    TextWidget("Event Info", result.description!),
                    SizedBox(
                      height: 20,
                    ),
                    TextWidget("Created Date",
                        DateFormat("dd-MMMM-yyyy").format(result.eventDate!)),
                    SizedBox(
                      height: 20,
                    ),
                    TextWidget("Close Date",
                        DateFormat("dd-MMMM-yyyy").format(result.eventDate!)),
                    SizedBox(
                      height: 30,
                    ),
                 result.user!.id != Api.singleton.sp.read("id")? CustomButton(
                   padding: EdgeInsets.symmetric(
                       vertical: 10, horizontal: 20),
                   color: DynamicColors.liveColor,
                   text: "Report Event",
                   onTap: () {
                     Get.back();
                     controller.reportPost(postId: result.id,type: "event");
                   },
                   borderColor: DynamicColors.liveColor,
                   style: poppinsSemiBold(
                       color: DynamicColors.whiteColor, fontSize: 16),
                 ):   CustomButton(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      color: DynamicColors.liveColor,
                      text: "Edit Event",
                      onTap: () {
                        Get.back();
                      Get.toNamed(Routes.addEvent,arguments: {"data":result});
                      },
                      borderColor: DynamicColors.liveColor,
                      style: poppinsSemiBold(
                          color: DynamicColors.whiteColor, fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    result.user!.id != Api.singleton.sp.read("id")?Container():   CustomButton(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      color: DynamicColors.liveColor,
                      text: "Delete Event",
                      onTap: () {
                        Get.back();
                        alertCustomMethod(context,
                            theme: DynamicColors.primaryColor,
                            titleText: "Do you want to delete this event?",
                            click: () {
                              Get.back();
                              controller.deleteEvent(result.id!);
                            }, click2: () {
                              Get.back();
                            }, buttonText: "Yes", buttonText2: "No");
                      },
                      borderColor: DynamicColors.liveColor,
                      style: poppinsSemiBold(
                          color: DynamicColors.whiteColor, fontSize: 16),
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
