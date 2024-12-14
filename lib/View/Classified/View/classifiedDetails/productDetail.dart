// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/CustomAlert.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/Chat/controller/chatController.dart';
import 'package:bloodlines/View/Classified/Data/classifiedController.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Classified/Model/classifiedAdModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as form;
import 'package:map_location_picker/map_location_picker.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetail extends StatelessWidget {
  ProductDetail({Key? key}) : super(key: key);
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  ClassifiedController controller = Get.find();
  ChatController chatController = Get.find();
  final RxInt _current = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColors.primaryColorLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: AppBarWidgets(isCardType: true),
        title: Text(
          "Classifieds Details",
          style:
              poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 20),
        ),
        elevation: 0,
        actions: [
         AppBarWidgets(
                  height: 50,
                  width: 50,
                  isCardType: true,
                  onTap: () {
                    Get.bottomSheet(AdBottomSheet(
                      result: controller.classifiedAdData!,
                    ));
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
      body: GetBuilder<ClassifiedController>(builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          width: Utils.width(context),
                          child: CarouselSlider.builder(
                              itemCount: controller
                                  .classifiedAdData!.classifiedPhotos!.length,
                              itemBuilder: (BuildContext context, int i,
                                      int pageViewIndex) =>
                                  InkWell(
                                    highlightColor: DynamicColors.primaryColor
                                        .withOpacity(0.1),
                                    onTap: () {
                                      Get.toNamed(Routes.photo, arguments: {
                                        "image": controller.classifiedAdData!
                                            .classifiedPhotos![i].photo!
                                      });
                                    },
                                    child: Container(
                                      
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          image: DecorationImage(
                                              image:
                                                  OptimizedCacheImageProvider(
                                                controller
                                                    .classifiedAdData!
                                                    .classifiedPhotos![i]
                                                    .photo!,
                                              ),
                                              alignment: Alignment.center,
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                              options: CarouselOptions(
                                initialPage: 0,
                                enableInfiniteScroll: false,
                                reverse: false,
                                autoPlay: false,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: false,
                                aspectRatio: 16 / 9,
                                viewportFraction: 1,
                                onPageChanged: (value, reason) {
                                  _current.value = value;
                                },
                                scrollDirection: Axis.horizontal,
                              )),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: controller.classifiedAdData!
                                        .classifiedPhotos!.length ==
                                    1
                                ? Container()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: controller
                                        .classifiedAdData!.classifiedPhotos!
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      return Obx(() {
                                        return Container(
                                          width: 6.0,
                                          height: 6.0,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: (Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                      : DynamicColors
                                                          .primaryColorRed)
                                                  .withOpacity(_current.value ==
                                                          entry.key
                                                      ? 0.9
                                                      : 0.4)),
                                        );
                                      });
                                    }).toList(),
                                  )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      controller.classifiedAdData!.title!,
                      style: montserratSemiBold(color: DynamicColors.textColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "\$${controller.classifiedAdData!.price}",
                          // "from \$${controller.classifiedAdData!.price}/hr",
                          style: montserratSemiBold(
                              color: DynamicColors.primaryColorRed),
                        ),
                        Spacer(),
                        controller.classifiedAdData!.location == null
                            ? Container()
                            : Row(
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color: DynamicColors.accentColor,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  SizedBox(
                                    width: Utils.width(context) / 3,
                                    child: Text(
                                      controller.classifiedAdData!.location ??
                                          "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: montserratRegular(
                                          color: DynamicColors.textColor,
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: DynamicColors.accentColor),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          controller.classifiedAdData!.category!.title!,
                          style: montserratRegular(
                            color: DynamicColors.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: DynamicColors.accentColor,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status",
                      style: montserratBold(color: DynamicColors.textColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      controller.classifiedAdData!.status!.capitalize!,
                      style: montserratRegular(
                          color: DynamicColors.textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w100),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Description",
                      style: montserratBold(color: DynamicColors.textColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      controller.classifiedAdData!.description!,
                      style: montserratRegular(
                          color: DynamicColors.textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w100),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Ad Poster",
                      style: montserratBold(color: DynamicColors.textColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: OptimizedCacheImage(
                            imageUrl: controller
                                .classifiedAdData!.user!.profile!.profileImage!,
                            height: 60,
                            width: 60,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          controller.classifiedAdData!.user!.id ==
                                  Api.singleton.sp.read("id")
                              ? "You"
                              : controller
                                  .classifiedAdData!.user!.profile!.fullname!,
                          style: montserratSemiBold(
                              color: DynamicColors.textColor, fontSize: 16),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Utils.onNavigateTimeline(
                                controller.classifiedAdData!.user!.id!);
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                  child: Text(
                                controller.classifiedAdData!.user!.id ==
                                        Api.singleton.sp.read("id")
                                    ? "View Timeline"
                                    : "View Profile",
                                style: poppinsSemiBold(
                                    color: DynamicColors.primaryColor,
                                    fontSize: 12),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    controller.classifiedAdData!.location == null
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Location",
                                style: montserratBold(
                                    color: DynamicColors.textColor),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                controller.classifiedAdData!.location ?? "",
                                style: montserratRegular(
                                    color: DynamicColors.textColor,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: Utils.height(context) / 5,
                                child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: GoogleMap(
                                      minMaxZoomPreference:
                                          MinMaxZoomPreference(0, 11),
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                            double.parse(controller
                                                .classifiedAdData!.latitude!),
                                            double.parse(controller
                                                .classifiedAdData!.longitude!)),
                                        zoom: 17.4746,
                                      ),
                                      onTap: (a) async {
                                        if (Platform.isAndroid) {
                                          final AndroidIntent intent = AndroidIntent(
                                              action: 'action_view',
                                              data: Uri.encodeFull(
                                                  "https://www.google.com/maps/dir/?api=1&destination=${controller.classifiedAdData!.latitude},${controller.classifiedAdData!.longitude}&dir_action=navigate"),
                                              package:
                                                  'com.google.android.apps.maps');
                                          intent.launch();
                                        } else {
                                          String url =
                                              "https://www.google.com/maps/dir/?api=1&destination=${controller.classifiedAdData!.latitude},${controller.classifiedAdData!.longitude}&dir_action=navigate";
                                          if (await canLaunchUrl(
                                              Uri.parse(url))) {
                                            await launchUrl(Uri.parse(url));
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        }
                                      },
                                      circles: {
                                        Circle(
                                          circleId: CircleId("id"),
                                          center: LatLng(
                                              double.parse(controller
                                                  .classifiedAdData!.latitude!),
                                              double.parse(controller
                                                  .classifiedAdData!
                                                  .longitude!)),
                                          radius: 50,
                                          strokeWidth: 1,
                                          strokeColor: Colors.green,
                                          fillColor:
                                              Colors.green.withOpacity(0.2),
                                        ),
                                      },
                                      markers: {
                                        Marker(
                                            markerId: MarkerId('1'),
                                            position: LatLng(
                                                double.parse(controller
                                                    .classifiedAdData!
                                                    .latitude!),
                                                double.parse(controller
                                                    .classifiedAdData!
                                                    .longitude!)))
                                      },
                                      zoomControlsEnabled: false,
                                      zoomGesturesEnabled: false,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _mapController.complete(controller);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    controller.classifiedAdData!.user!.id ==
                            Api.singleton.sp.read("id")
                        ? Container()
                        : Center(
                            child: CustomButton(
                              color: DynamicColors.whiteColor,
                              isLong: false,
                              onTap: () {
                                chatController.userData =
                                    controller.classifiedAdData!.user!;
                                Get.toNamed(Routes.chatScreen, arguments: {
                                  "user": controller.classifiedAdData!.user!,
                                  "id": controller.classifiedAdData!.user!.id,
                                });
                              },
                              borderRadius: BorderRadius.circular(4),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              borderColor: DynamicColors.blueColor,
                              style: montserratSemiBold(
                                  color: DynamicColors.blueColor),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/icons/chat.png",
                                    height: 15,
                                    color: DynamicColors.blueColor,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Chat with seller",
                                    style: montserratRegular(
                                        fontSize: 14,
                                        color: DynamicColors.blueColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Api.singleton.sp.read("id") ==
                      controller.classifiedAdData!.user!.id
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 90),
                      child: GestureDetector(
                        onTap: () async {
                          var map = {
                            "status":
                                controller.classifiedAdData!.status == "active"
                                    ? "deactive"
                                    : "active",
                          };

                          form.FormData formData = form.FormData.fromMap(map);
                          print(formData);

                          form.Response response = await Api.singleton.post(
                              formData,
                              'classified/update?id=${controller.classifiedAdData!.id}');
                          if (response.statusCode == 200) {
                            controller.getClassifiedDetails(
                                controller.classifiedAdData!.id!);
                            controller.getMyClassifiedAds();
                            BotToast.showText(
                                text: "Status updated successfully");
                          }
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: DynamicColors.primaryColorRed,
                              border: Border.all(
                                color: DynamicColors.primaryColorRed,
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                                child: Text(
                              controller.classifiedAdData!.status == "active"
                                  ? "Deactivate"
                                  : "Activate",
                              style: poppinsSemiBold(
                                  color: DynamicColors.whiteColor,
                                  fontSize: 12),
                            )),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class AdBottomSheet extends StatelessWidget {
  AdBottomSheet({Key? key, required this.result}) : super(key: key);
  ClassifiedAdData result;
  ClassifiedController controller = Get.find();

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

                result.user!.id == Api.singleton.sp.read("id")?Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      color: DynamicColors.liveColor,
                      text: "Edit Classified",
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.newClassifiedAd,
                            arguments: {"data": result});
                      },
                      borderColor: DynamicColors.liveColor,
                      style: poppinsSemiBold(
                          color: DynamicColors.whiteColor, fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      color: DynamicColors.liveColor,
                      text: "Delete Classified",
                      onTap: () {
                        Get.back();
                        alertCustomMethod(context,
                            theme: DynamicColors.primaryColor,
                            titleText: "Do you want to delete this classified?",
                            click: () {
                              Get.back();
                              controller.deleteClassified(
                                  result.id!, result.categoryId!);
                            }, click2: () {
                              Get.back();
                            }, buttonText: "Yes", buttonText2: "No");
                      },
                      borderColor: DynamicColors.liveColor,
                      style: poppinsSemiBold(
                          color: DynamicColors.whiteColor, fontSize: 16),
                    ),
                  ],
                ):    Column(    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          color: DynamicColors.liveColor,
                          text: "Report Classified",
                          onTap: () {
                            Get.back();
                            alertCustomMethod(context,
                                theme: DynamicColors.primaryColor,
                                titleText: "Do you want to report this classified?",
                                click: () {
                              Get.back();
                              controller.reportClassified(
                                  postId:   result.id!, categoryId:result.categoryId!);
                            }, click2: () {
                              Get.back();
                            }, buttonText: "Yes", buttonText2: "No");
                          },
                          borderColor: DynamicColors.liveColor,
                          style: poppinsSemiBold(
                              color: DynamicColors.whiteColor, fontSize: 16),
                        ),
                      ],
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
