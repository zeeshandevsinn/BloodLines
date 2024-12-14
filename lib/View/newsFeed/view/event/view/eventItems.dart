// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/model/eventsModel.dart';
import 'package:bloodlines/View/newsFeed/view/event/components/eventWidget.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';

import 'package:fluttericon/iconic_icons.dart';
import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class EventItemsClass extends StatefulWidget {
  EventItemsClass({
    super.key,
    this.fromDetails = false,
    this.myEvent = false,
    this.fromFeeds = false,
    this.type = "all",
    required this.data,
    required this.index,
  });
  bool fromDetails;
  bool fromFeeds;
  bool myEvent;
  String type;
  int index;
  EventsData data;

  @override
  State<EventItemsClass> createState() => _EventItemsClassState();
}

class _EventItemsClassState extends State<EventItemsClass> {
  final settings = RestrictedPositions(
    maxCoverage: 0.5,
    minCoverage: 0.2,
    align: StackAlign.left,
  );

  final FeedController _controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.eventsData = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;

    if(_controller.eventsData!.isReported == 1){
      return Container();
    }

    return Container(
      color: DynamicColors.primaryColorLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
            EdgeInsets.symmetric(
                horizontal: widget.fromDetails == false ? 0 : 10),
            child: GestureDetector(
              onTap: () {
                if (widget.fromDetails == false) {
                  Get.toNamed(Routes.eventClass, arguments: {
                    "myEvent": false,
                    "data": widget.data,
                    "index": widget.index,
                    "fromDetails": true
                  });
                } else {
                  Get.toNamed(Routes.photo, arguments: {
                    "image": widget.data.cover!,
                  });
                }
              },
              child: Stack(
                children: [
                  SizedBox(
                    height: Utils.height(context) / 4,
                    width: double.infinity,
                    child: OptimizedCacheImage(
                      imageUrl:           widget.data.cover!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  widget.fromDetails == true
                      ? SizedBox.shrink()
                      : Positioned(
                    top: 15,
                    right: 15,
                    child:  AppBarWidgets(
                      height: 50,
                      width: 50,
                      decorationColor: Colors.white38,
                      onTap: () {
                        // if (widget.data.user!.id ==
                        //     Api.singleton.sp.read("id")) {
                        //   Get.bottomSheet(EventBottomSheet(
                        //     result: widget.data,
                        //   ),  enableDrag: true,
                        //     isScrollControlled: true,
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.only(
                        //             topRight: Radius.circular(30),
                        //             topLeft: Radius.circular(30))),);
                        // }
                        Get.bottomSheet(EventBottomSheet(
                          result: widget.data,
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
                  )
                ],
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
                  widget.fromDetails == true
                      ? SizedBox.shrink()
                      : locationMethod(context),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.data.title!,
                    style: poppinsRegular(fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GetBuilder<FeedController>(builder: (controller) {
                    return Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: width / 1.9,
                          child: WidgetStack(
                            positions: settings,
                            stackedWidgets: [
                              for (var n = 0; n <
                                  widget.data.eventMembers!.length; n++)
                                    if(widget.data.eventMembers![n].status == "going")
                                      Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: 1,
                                                  color: DynamicColors.primaryColor)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: OptimizedCacheImage(
                                              imageUrl: widget.data.eventMembers![n].user!
                                                  .profile!
                                                  .profileImage!,
                                              fit: BoxFit.cover,
                                            ),


                                          ))
                            ],
                            buildInfoWidget: (surplus) {
                              return SizedBox.shrink();
                            },
                          ),
                        ),
                        widget.data.membersGoing == 0
                            ? Container()
                            : InkWell(
                          onTap: () {
                            Get.bottomSheet(interestedBottom());
                          },
                          child: Text(
                            "(${widget.data.membersGoing}) Going",
                            style: poppinsSemiBold(
                                fontWeight: FontWeight.w400,
                                color: DynamicColors.primaryColor,
                                fontSize: 13),
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 3,
                        ),
                        CustomButton(
                          text: "+ Invite",
                          isLong: false,
                          onTap: () {
                         Get.toNamed(Routes.eventInviteList,arguments: {
                           "myEvent":widget.myEvent,
                           "id":widget.data.id
                         });
                          },
                          padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          borderColor: DynamicColors.primaryColorRed,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                          style: poppinsRegular(
                              fontSize: 10,
                              color: DynamicColors.primaryColorRed),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  widget.fromDetails == false
                      ? SizedBox.shrink()
                      : locationMethod(context),
                ],
              ),
            ),
            widget.fromDetails == false
                ? SizedBox.shrink()
                : Padding(
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
                    style: poppinsSemiBold(
                        color: DynamicColors.primaryColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.data.description!,
                    style: poppinsRegular(
                        color: DynamicColors.textColor, fontSize: 14),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Event Host",
                    style: poppinsSemiBold(
                        color: DynamicColors.primaryColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 50,
                        child: OptimizedCacheImage(
                          imageUrl:   widget.data.user!.profile!.profileImage!,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.data.user!.id == Api.singleton.sp.read("id")?"You":     widget.data.user!.profile!.fullname!,
                        style: poppinsRegular(
                            color: DynamicColors.textColor, fontSize: 15),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Utils.onNavigateTimeline(widget.data.user!.id!);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: DynamicColors.primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: Center(
                                child: Text(
                                  "View Profile",
                                  style: poppinsSemiBold(
                                      color: DynamicColors.primaryColor,
                                      fontSize: 12),
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ]),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 4, right: 10, left: 10),
              child: widget.myEvent == true
                  ? widget.fromDetails == false
                  ? InkWell(
                onTap: () {
                  Get.toNamed(Routes.eventClass, arguments: {
                    "myEvent": true,
                    "data": widget.data,
                    "index": widget.index,
                    "fromDetails": widget.fromDetails
                  });
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: DynamicColors.primaryColorRed,
                      border: Border.all(
                        color: DynamicColors.primaryColorRed,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                      child: Text(
                        "View",
                        style: poppinsSemiBold(
                            color: DynamicColors.primaryColorLight,
                            fontSize: 14),
                      )),
                ),
              )
                  : Container()
                  : widget.data.user!.id == Api.singleton.sp.read("id")?
              Container():Obx(() =>
         widget.data.eventStatus!.value != "not going"
                  ? InkWell(
                onTap: () {
                  _controller.interestedOrGoing(
                      index: widget.index,
                      eventId: widget.data.id.toString(),
                      eventStatus: widget.data.eventStatus!.value,
                      fromDetails: widget.fromDetails, type: widget.type,
                    fromFeeds: widget.fromFeeds,
                  );
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: DynamicColors.primaryColorRed,
                      border: Border.all(
                        color: DynamicColors.primaryColorRed,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                      child: Text(
                        widget.data.eventStatus!.value.capitalize!,
                        style: poppinsSemiBold(
                            color: DynamicColors.primaryColorLight,
                            fontSize: 14),
                      )),
                ),
              )
                  : Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: InkWell(
                      onTap: () {
                        _controller.interestedOrGoing(
                            index: widget.index,
                            eventId: widget.data.id.toString(),
                            status: "interested",
                            eventStatus: widget.data.eventStatus!.value,
                            fromDetails: widget.fromDetails,
                          type: widget.type,
                          fromFeeds: widget.fromFeeds,);
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: DynamicColors.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                            child: Text(
                              "Interested",
                              style: poppinsSemiBold(
                                  color: DynamicColors.primaryColor,
                                  fontSize: 14),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 5,
                    child: InkWell(
                      onTap: () {
                        _controller.interestedOrGoing(
                            index: widget.index,
                            eventId: widget.data.id.toString(),
                            status: "going",
                            eventStatus: widget.data.eventStatus!.value,
                            fromDetails: widget.fromDetails,
                          type: widget.type,
                          fromFeeds: widget.fromFeeds,);
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: DynamicColors.primaryColorRed,
                            border: Border.all(
                              color: DynamicColors.primaryColorRed,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                            child: Text(
                              "Going",
                              style: poppinsBold(
                                  color: DynamicColors.primaryColorLight,
                                  fontSize: 14),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),)
          ),
          SizedBox(
            height: 10,
          ),
          // Divider(
          //   thickness: 2,
          // ),
          // SizedBox(
          //   height: 5,
          // ),
        ],
      ),
    );
  }

  Widget locationMethod(context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.data.location == null?Container():  Row(
              children: [
                Icon(
                  Icons.location_pin,
                  color: DynamicColors.primaryColorRed,
                  size: 16,
                ),
                SizedBox(
                  width: Utils.width(context)/1.2,
                  child: Text(
                    widget.data.location!,
                    style: poppinsLight(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),


          ],
        ),
        SizedBox(height: 5,),
        Row(
          children: [
            Icon(
              Iconic.clock,
              color: DynamicColors.primaryColorRedDark,
              size: 15,
            ),
            SizedBox(width: 1,),
            Text(
              "${DateFormat("EEE").format(widget.data.eventDate!)} ${DateFormat(
                  "MMM-dd-yyyy").format(widget.data.eventDate!)} | ${widget.data
                  .eventTime}",
              style: poppinsLight(
                  fontSize: 14,
                  color: DynamicColors.primaryColorRedDark,
                  fontWeight: FontWeight.w800),
            ),
          ],
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
