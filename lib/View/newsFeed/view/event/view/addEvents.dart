import 'dart:io';

import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/textFieldComponent.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/newsFeed/data/feedComponentData.dart';
import 'package:bloodlines/View/newsFeed/model/eventsModel.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/view/event/view/eventInviteList.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/web_symbols_icons.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/textField.dart';
import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class AddEvent extends StatefulWidget {
  AddEvent({Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  FeedController controller = Get.find();

  FeedComponentData feedData = FeedComponentData();

  final formKey = GlobalKey<FormState>();

  EventsData? data = Get.arguments == null ? null : Get.arguments["data"];

  String? coverImage;
  RxBool remove = false.obs;

  @override
  void initState() {
    controller.files = null;
    super.initState();
    if (data != null) {

      if(data!.cover != checkImageUrl("event")){
        coverImage = data!.cover;
      }
      controller.eventName.text = data!.title!;
      controller.eventDescription.text = data!.description!;
      controller.eventDate.value.text =
          DateFormat("yyy-MM-dd").format(data!.eventDate!);

      int d = int.parse(data!.eventTime!.split(":").first);
      String isAm = data!.eventTime!.split(" ").last;
      String time;
      if (isAm == "PM") {
        var las = data!.eventTime!.split(":").last;
        var split = las
            .split(" ")
            .first;
        time = "${d + 12}:$split";
      } else {
        time = data!.eventTime!.split(" ").first;
      }


      controller.eventTime.value.text = DateFormat("HH:mm").format(
          DateTime.parse(
              "${DateFormat("yyy-MM-dd").format(data!.eventDate!)}T$time"));
      controller.eventLocation.text = data!.location??"";
    }
  }

  Future<bool> onWillPop() async {
    controller.eventSelectList.clear();
    Get.back();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
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
            "New Event",
            style:
            poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
          ),
          elevation: 0,
        ),
        body: GetBuilder<FeedController>(builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: Utils.height(context) / 5,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: controller.files != null
                            ? Stack(
                          children: [
                            Image.file(
                              File(controller.files!.path),
                              fit: BoxFit.fill,
                              height: Utils.height(context) / 5,
                              width: double.infinity,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, top: 5),
                                child: InkWell(
                                  onTap: () {
                                    controller.files = null;
                                    controller.update();
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: DynamicColors.whiteColor,
                                          shape: BoxShape.circle),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Icon(
                                          Icons.close,
                                          color: DynamicColors.primaryColor,
                                        ),
                                      )),
                                ),
                              ),
                            )
                          ],
                        )
                            : InkWell(
                          onTap: () {
                            feedData.bottomSheet(context,
                                fromAddEvent: true);
                          },
                          child: Stack(
                            children: [
                              coverImage != null
                                  ?
                              SizedBox(
                                height: Utils.height(context) / 5,
                                width: double.infinity,
                                child: OptimizedCacheImage(
                                  imageUrl:  coverImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : Image.asset(
                                "assets/dummyCover.png",
                                fit: BoxFit.fill,
                                height: Utils.height(context) / 5,
                                width: double.infinity,
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: DynamicColors.primaryColor,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Add Cover Photo",
                                      style: montserratRegular(
                                          fontSize: 20,
                                          color: DynamicColors.accentColor),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldComponent(
                        title: "Event Title",
                        hint: "Live Show",
                        controller: controller.eventName),
                    TextFieldComponent(
                        title: "Event Description",
                        hint: "Lorem ipsum dolor sit amet, consetetur.",
                        controller: controller.eventDescription),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Event Date",
                      style:
                      poppinsLight(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    Obx(() {
                      return CustomTextField(
                        controller: controller.eventDate.value,
                        mainPadding: EdgeInsets.zero,
                        hint: "04 / 25 / 2023",
                        readOnly: true,
                        suffixIcon: InkWell(
                          onTap: () {
                            feedData.selectDate(context);
                          },
                          child: Icon(
                            Linecons.calendar,
                            color: DynamicColors.primaryColorRed,
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Time",
                      style:
                      poppinsLight(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    Obx(() {
                      return CustomTextField(
                        controller: controller.eventTime.value,
                        mainPadding: EdgeInsets.zero,
                        readOnly: true,
                        hint: "02:25:00",
                        suffixIcon: InkWell(
                          onTap: () {
                            feedData.selectTime(context);
                          },
                          child: Icon(
                            WebSymbols.clock,
                            color: DynamicColors.primaryColorRed,
                          ),
                        ),
                      );
                    }),
                    TextFieldComponent(
                        title: "Location",
                        hint: "Cineplex Cinema UK",
                        fromPedigree: true,
                        readOnly: true,
                        controller: controller.eventLocation,
                        suffix: InkWell(
                          onTap: () {
                            feedData.determinePositions();
                          },
                          child: Icon(
                            Icons.location_pin,
                            color: DynamicColors.primaryColorRed,
                          ),
                        )),
                    SizedBox(
                      height: kToolbarHeight / 2,
                    ),
                    controller.eventSelectList.isEmpty ? Container() : SizedBox(
                      height: 80,
                      child: Obx(() {
                        if(remove.value){
                          return buildListView(controller);
                        }
                        return buildListView(controller);
                      }),
                    ),
                    SizedBox(
                      height: kToolbarHeight / 2,
                    ),
                    Center(
                      child: CustomButton(
                        text: "Select Friends to Invite",
                        isLong: false,
                        onTap: () {
                          Get.bottomSheet(
                            SizedBox(
                                height: Utils.height(context) / 1.2,
                                child: EventInviteList()),
                            isScrollControlled: true,
                            enableDrag: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30))),
                          );
                          // if (formKey.currentState!.validate()) {}
                          // Get.toNamed(Routes.profiling2);
                        },
                        padding:
                        EdgeInsets.symmetric(vertical: 7, horizontal: 40),
                        color: DynamicColors.whiteColor,
                        borderColor: DynamicColors.primaryColorRed,
                        borderRadius: BorderRadius.circular(5),
                        style:
                        poppinsSemiBold(color: DynamicColors.primaryColorRed),
                      ),
                    ),
                    SizedBox(
                      height: kToolbarHeight,
                    ),
                    Center(
                      child: CustomButton(
                        text: data != null ? 'Update' : "Create",
                        isLong: false,
                        onTap: () {

                          if (formKey.currentState!.validate()) {
                             controller.createEvent(
                                  id: data == null ? null : data!.id);
                          }
                          // Get.toNamed(Routes.profiling2);
                        },
                        padding:
                        EdgeInsets.symmetric(vertical: 7, horizontal: 40),
                        color: DynamicColors.primaryColorRed,
                        borderColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        style: poppinsSemiBold(
                            color: DynamicColors.primaryColorLight),
                      ),
                    ),
                    SizedBox(
                      height: kToolbarHeight / 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  ListView buildListView(FeedController controller) {
    return ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        itemCount: controller.eventSelectList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Stack(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: DynamicColors.primaryColorRed),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: OptimizedCacheImage(
                      imageUrl: controller.eventSelectList[index].profile!.profileImage!,
                      fit: BoxFit.cover,
                    )
                  ),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                        onTap: () {
                          controller.eventSelectList.removeAt(index);
                          remove(!remove.value);
                        },
                        child: Icon(FontAwesome.cancel_circled,
                          color: DynamicColors.primaryColorRed,))),

              ],
            ),
          );
        });
  }
}


