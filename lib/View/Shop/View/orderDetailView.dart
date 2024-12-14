import 'dart:async';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/CustomAlert.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Shop/Data/shopController.dart';
import 'package:bloodlines/View/Shop/Model/orderDetailsModel.dart';
import 'package:bloodlines/View/readmore.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailView extends StatelessWidget {
  OrderDetailView({Key? key}) : super(key: key);
  final int id = Get.arguments["id"];
  ShopController controller = Get.find();
  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();
  Future<bool> onWillPop() async {
    controller.orderDetailsModel = null;
    Get.back();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:onWillPop,
      child: Scaffold(
        backgroundColor: DynamicColors.primaryColorLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: AppBarWidgets(
            onTap: (){
              onWillPop();
            },
          ),
          title: Text(
            "Order Details",
            style:
            poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
          ),
          elevation: 0,
        ),
        body: GetBuilder<ShopController>(
          initState: (c) {
            controller.getOrderDetails(id);
          },
          builder: (controller) {
            if (controller.orderDetailsModel == null) {
              return Center(
                child: LoaderClass(),
              );
            }
            if (controller.orderDetailsModel!.orderDetails!.isEmpty) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "My Orders",
                      style: montserratBold(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        shrinkWrap: true,
                        itemCount: controller.orderDetailsModel!.orderDetails!.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          OrderDetail data =
                          controller.orderDetailsModel!.orderDetails![index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Utils.height(context) / 5,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child:   GestureDetector(
                                        onTap:(){
                                          Get.toNamed(Routes.shopDetail,arguments: {
                                            "id":data.product!.id
                                          });
                                        },
                                        child: Container(
                                            height: Utils.height(context) / 5,
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
                                                borderRadius:
                                                BorderRadius.circular(5),
                                              ),
                                              child: OptimizedCacheImage(
                                                imageUrl: data.product!.image!,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap:(){
                                              Get.toNamed(Routes.shopDetail,arguments: {
                                                "id":data.product!.id
                                              });
                                            },
                                            child: Text(
                                              data.product!.name!,
                                              style:
                                              montserratSemiBold(fontSize: 14),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "\$${(double.parse(data.product!.price.toString().split("\$")[1])*data.qty!).toString()}",
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: montserratExtraBold(
                                                fontSize: 14,
                                                color: DynamicColors
                                                    .primaryColorRed),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: data.variations!.length,
                                              itemBuilder: (context,aIndex){
                                                return Row(
                                                  children: [
                                                    Text(
                                                      "${data.variations![aIndex].cartAttribute!.name!} : ",
                                                      style:
                                                      montserratSemiBold(fontSize: 14),
                                                    ),
                                                    SizedBox(width: 10,),

                                                    Text(
                                                      data.variations![aIndex].name!,
                                                      style:
                                                      montserratBold(fontSize: 16),
                                                    ),

                                                  ],
                                                );
                                              }),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Text(
                                                "Quantity: ",
                                                style: montserratBold(fontSize: 16),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                data.qty!.toString(),
                                                style: montserratBold(),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),

                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            //   SizedBox(height: 10,),
                            //   Text(
                            //     "Description",
                            //     style: montserratBold(),
                            //   ),
                            //   SizedBox(
                            //     height: 10,
                            //   ),
                            //   ReadMoreText(data.product!.description??"",moreStyle: poppinsRegular(color: DynamicColors.primaryColorRed,fontSize: 15),lessStyle: poppinsRegular(color: DynamicColors.primaryColorRed,fontSize: 15),style:  poppinsRegular(fontSize: 15),),
                            //   // Text(
                            //   //   data.product!.description??"",
                            //   //   style: poppinsRegular(),
                            //   // ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          );
                        }),
                    Text(
                      "Delivery Location",
                      style: montserratBold(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
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
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.location_pin,
                                color: DynamicColors.primaryColorRed,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        controller.orderDetailsModel!.addressData == null
                            ? SizedBox(
                            width: Utils.width(context) / 1.4,
                            child: Text(
                              "No Address",
                              style: montserratSemiBold(fontSize: 14),
                            ))
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: Utils.width(context) / 1.4,
                              child: Text(
                                controller.orderDetailsModel!.addressData!
                                    .shippingAddress!.streetAddress!,
                                style: montserratSemiBold(fontSize: 14),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: Utils.width(context) / 1.4,
                              child: Text(
                                "${controller.orderDetailsModel!.addressData!.shippingAddress!.zipcode},  ${controller.cartModel!.data!.addressData!.shippingAddress!.city == null ? '' : '${controller.cartModel!.data!.addressData!.shippingAddress!.city},'} ${controller.cartModel!.data!.addressData!.shippingAddress!.state == null ? '' : '${controller.cartModel!.data!.addressData!.shippingAddress!.state},'} ${controller.cartModel!.data!.addressData!.shippingAddress!.county}",
                                style: montserratSemiBold(
                                    fontSize: 12,
                                    color: DynamicColors.accentColor
                                        .withOpacity(0.4)),
                              ),
                            ),


                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
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
                            minMaxZoomPreference: MinMaxZoomPreference(0, 11),
                            initialCameraPosition: CameraPosition(
                              target: LatLng(double.parse(controller.cartModel!.data!.addressData!
                                  .shippingAddress!.latitude!),
                                  double.parse(controller.cartModel!.data!.addressData!
                                      .shippingAddress!.longitude!)),
                              zoom: 17.4746,
                            ),
                            onTap: (a) async {
                              if (Platform.isAndroid) {
                                final AndroidIntent intent = AndroidIntent(
                                    action: 'action_view',
                                    data: Uri.encodeFull(
                                        "https://www.google.com/maps/dir/?api=1&destination=${controller.cartModel!.data!.addressData!
                                            .shippingAddress!.latitude},${controller.cartModel!.data!.addressData!
                                            .shippingAddress!.longitude}&dir_action=navigate"),
                                    package: 'com.google.android.apps.maps');
                                intent.launch();
                              } else {
                                String url =
                                    "https://www.google.com/maps/dir/?api=1&destination=${controller.cartModel!.data!.addressData!
                                    .shippingAddress!.latitude},${controller.cartModel!.data!.addressData!
                                    .shippingAddress!.longitude}&dir_action=navigate";
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }
                            },
                            circles: {
                              Circle(
                                circleId: CircleId("id"),
                                center: LatLng(double.parse(controller.cartModel!.data!.addressData!
                                    .shippingAddress!.latitude!),
                                    double.parse(controller.cartModel!.data!.addressData!
                                        .shippingAddress!.longitude!)),
                                radius: 50,
                                strokeWidth: 1,
                                strokeColor: Colors.green,
                                fillColor: Colors.green.withOpacity(0.2),
                              ),
                            },
                            markers: {
                              Marker(
                                  markerId: MarkerId('1'),
                                  position: LatLng(
                                      double.parse(controller.cartModel!.data!.addressData!
                                          .shippingAddress!.latitude!),
                                      double.parse(controller.cartModel!.data!.addressData!
                                          .shippingAddress!.longitude!)))
                            },
                            zoomControlsEnabled: false,
                            zoomGesturesEnabled: false,
                            onMapCreated: (GoogleMapController controller) {
                              _mapController.complete(controller);
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Order Info",
                      style: montserratBold(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Sub - total",
                          style: montserratSemiBold(
                              fontSize: 14, color: DynamicColors.accentColor),
                        ),
                        Spacer(),
                        Text(
                          controller.orderDetailsModel!.subTotalAmount!,
                          style: montserratSemiBold(
                              fontSize: 16, color: DynamicColors.textColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Shipping",
                          style: montserratSemiBold(
                              fontSize: 14, color: DynamicColors.accentColor),
                        ),
                        Spacer(),
                        Text(
                          controller.orderDetailsModel!.shipping!,
                          style: montserratSemiBold(
                              fontSize: 16, color: DynamicColors.textColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Sale tax",
                          style: montserratSemiBold(
                              fontSize: 14, color: DynamicColors.accentColor),
                        ),
                        Spacer(),
                        Text(
                          controller.orderDetailsModel!.salesTax!,
                          style: montserratSemiBold(
                              fontSize: 16, color: DynamicColors.textColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text(
                          "Total Amount",
                          style: montserratBold(
                              fontSize: 20, color: DynamicColors.textColor),
                        ),
                        Spacer(),
                        Text(
                          controller.orderDetailsModel!.totalAmount!,
                          style: montserratBold(
                              fontSize: 20, color: DynamicColors.primaryColorRed),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
