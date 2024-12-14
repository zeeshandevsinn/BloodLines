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
import 'package:bloodlines/View/Shop/Model/cardList.dart';
import 'package:bloodlines/View/Shop/Model/cartModel.dart';
import 'package:bloodlines/View/readmore.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  ShopController controller = Get.find();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColors.primaryColorLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: AppBarWidgets(),
        title: Text(
          "Shop",
          style:
              poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
        ),
        elevation: 0,
      ),
      body: GetBuilder<ShopController>(
        initState: (c) {
          controller.getCardList();
          controller.getCart();
        },
        builder: (controller) {
          if (controller.cartModel == null) {
            return Center(
              child: LoaderClass(),
            );
          }
          if (controller.cartModel!.data!.cart!.isEmpty) {
            return Center(
              child: Text(
                "Cart is empty",
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
                    "My Cart",
                    style: montserratBold(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      shrinkWrap: true,
                      itemCount: controller.cartModel!.data!.cart!.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        CartData data =
                            controller.cartModel!.data!.cart![index];
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
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(Routes.shopDetail,
                                            arguments: {
                                              "id": data.product!.id
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
                                          child: Card(
                                            surfaceTintColor:
                                                DynamicColors.primaryColorLight,
                                            color:
                                                DynamicColors.primaryColorLight,
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
                                          onTap: () {
                                            Get.toNamed(Routes.shopDetail,
                                                arguments: {
                                                  "id": data.product!.id
                                                });
                                          },
                                          child: Text(
                                            data.product!.name!,
                                            style: montserratSemiBold(
                                                fontSize: 14),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "\$${(double.parse(data.product!.price.toString().split("\$")[1]) * data.qty!.value).toString()}",
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
                                        ListView.builder(
                                            keyboardDismissBehavior:
                                                ScrollViewKeyboardDismissBehavior
                                                    .onDrag,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: data.variations!.length,
                                            itemBuilder: (context, aIndex) {
                                              return Row(
                                                children: [
                                                  Text(
                                                    "${data.variations![aIndex].cartAttribute!.name!} : ",
                                                    style: montserratSemiBold(
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    data.variations![aIndex]
                                                        .name!,
                                                    style: montserratSemiBold(
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              );
                                            }),
                                        Spacer(),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (data.qty!.value > 0) {
                                                  data.qty!.value =
                                                      data.qty!.value - 1;
                                                  controller.updateCart(
                                                      data.id!,
                                                      data.qty!.value,
                                                      index);
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: DynamicColors
                                                            .primaryColor)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Icon(Entypo.minus,
                                                      color: DynamicColors
                                                          .primaryColor),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Obx(() {
                                              return Text(
                                                data.qty!.value.toString(),
                                                style: montserratBold(),
                                              );
                                            }),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (data.qty!.value <
                                                    data.stock!.qty!.value) {
                                                  data.qty!.value =
                                                      data.qty!.value + 1;
                                                  controller.updateCart(
                                                      data.id!,
                                                      data.qty!.value,
                                                      index);
                                                } else {
                                                  BotToast.showText(
                                                      text:
                                                          "You cannot add more than stock");
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: DynamicColors
                                                            .primaryColorRed)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Icon(Icons.add,
                                                      color: DynamicColors
                                                          .primaryColorRed),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                controller.deleteCart(data.id!);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: DynamicColors
                                                        .accentColor
                                                        .withOpacity(0.3)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.asset(
                                                    "assets/delete.png",
                                                    height: 15,
                                                    width: 15,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Text(
                            //   "Description",
                            //   style: montserratBold(),
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // ReadMoreText(data.product!.description??"",moreStyle: poppinsRegular(color: DynamicColors.primaryColorRed,fontSize: 15),lessStyle: poppinsRegular(color: DynamicColors.primaryColorRed,fontSize: 15),style:  poppinsRegular(fontSize: 15),),
                            //
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
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.addressList);
                    },
                    child: Row(
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
                          child: Card(
                            surfaceTintColor: DynamicColors.primaryColorLight,
                            color: DynamicColors.primaryColorLight,
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
                        controller.cartModel!.data!.addressData == null
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
                                      controller.cartModel!.data!.addressData!
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
                                      "${controller.cartModel!.data!.addressData!.shippingAddress!.zipcode},  ${controller.cartModel!.data!.addressData!.shippingAddress!.city == null ? '' : '${controller.cartModel!.data!.addressData!.shippingAddress!.city},'} ${controller.cartModel!.data!.addressData!.shippingAddress!.state == null ? '' : '${controller.cartModel!.data!.addressData!.shippingAddress!.state},'} ${controller.cartModel!.data!.addressData!.shippingAddress!.county}",
                                      style: montserratSemiBold(
                                          fontSize: 12,
                                          color: DynamicColors.accentColor
                                              .withOpacity(0.4)),
                                    ),
                                  ),
                                ],
                              ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: DynamicColors.textColor,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  controller.cartModel!.data!.addressData == null
                      ? Container()
                      : SizedBox(
                          height: Utils.height(context) / 5,
                          child: Card(
                            surfaceTintColor: DynamicColors.primaryColorLight,
                            color: DynamicColors.primaryColorLight,
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
                                          .cartModel!
                                          .data!
                                          .addressData!
                                          .shippingAddress!
                                          .latitude!),
                                      double.parse(controller
                                          .cartModel!
                                          .data!
                                          .addressData!
                                          .shippingAddress!
                                          .longitude!)),
                                  zoom: 17.4746,
                                ),
                                onTap: (a) async {
                                  if (Platform.isAndroid) {
                                    final AndroidIntent intent = AndroidIntent(
                                        action: 'action_view',
                                        data: Uri.encodeFull(
                                            "https://www.google.com/maps/dir/?api=1&destination=${controller.cartModel!.data!.addressData!.shippingAddress!.latitude},${controller.cartModel!.data!.addressData!.shippingAddress!.longitude}&dir_action=navigate"),
                                        package:
                                            'com.google.android.apps.maps');
                                    intent.launch();
                                  } else {
                                    String url =
                                        "https://www.google.com/maps/dir/?api=1&destination=${controller.cartModel!.data!.addressData!.shippingAddress!.latitude},${controller.cartModel!.data!.addressData!.shippingAddress!.longitude}&dir_action=navigate";
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
                                    center: LatLng(
                                        double.parse(controller
                                            .cartModel!
                                            .data!
                                            .addressData!
                                            .shippingAddress!
                                            .latitude!),
                                        double.parse(controller
                                            .cartModel!
                                            .data!
                                            .addressData!
                                            .shippingAddress!
                                            .longitude!)),
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
                                          double.parse(controller
                                              .cartModel!
                                              .data!
                                              .addressData!
                                              .shippingAddress!
                                              .latitude!),
                                          double.parse(controller
                                              .cartModel!
                                              .data!
                                              .addressData!
                                              .shippingAddress!
                                              .longitude!)))
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
                    "Payment Method",
                    style: montserratBold(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.paymentMethod);
                    },
                    child: Row(
                      children: [

                        creditCardCheck(),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: DynamicColors.textColor,
                        )
                      ],
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
                        controller.cartModel!.data!.subTotalAmount!,
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
                        controller.cartModel!.data!.shipping!,
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
                        controller.cartModel!.data!.salesTax!,
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
                        "Total to pay",
                        style: montserratBold(
                            fontSize: 20, color: DynamicColors.textColor),
                      ),
                      Spacer(),
                      Text(
                        controller.cartModel!.data!.totalAmount!,
                        style: montserratBold(
                            fontSize: 20, color: DynamicColors.primaryColorRed),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text:
                          "CHECKOUT (${controller.cartModel!.data!.totalAmount})",
                      onTap: () {
                        alertCustomMethod(context,
                            theme: DynamicColors.primaryColor,
                            titleText: "Do you want to place order?",
                            click: () {
                          Get.back();
                          if (controller.cartModel!.data!.addressData != null) {
                            if(cardId != null){
                              controller.confirmOrder(
                                  controller.cartModel!.data!.addressData!
                                      .shippingAddress!.id!,
                                  controller.cartModel!.data!.addressData!
                                      .billingAddress!.id!,
                                  cardId!);
                            }else{
                              BotToast.showText(text: "Please add payment details");
                            }
                          } else {
                            BotToast.showText(text: "Please add address");
                          }
                        }, click2: () {
                          Get.back();
                        }, buttonText: "Yes", buttonText2: "No");
                      },
                      padding: EdgeInsets.symmetric(vertical: 13),
                      style: montserratBold(
                          fontSize: 16, color: DynamicColors.primaryColorRed),
                      color: DynamicColors.primaryColorRed.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5),
                      borderColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: "Clear Cart",
                      onTap: () {
                        controller.emptyCart();
                      },
                      padding: EdgeInsets.symmetric(vertical: 13),
                      style: montserratBold(
                          fontSize: 16, color: DynamicColors.whiteColor),
                      color: DynamicColors.primaryColorRed,
                      borderRadius: BorderRadius.circular(5),
                      borderColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  String? cardId;

  Widget buildCreditCardWidget(String brand,String cardNumber,String expMonth,String expYear,String type,String id) {
    if(id != "0"){
      cardId = id;
    }
    return Row(
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
          child: Card(
            surfaceTintColor: DynamicColors.primaryColorLight,
            color: DynamicColors.primaryColorLight,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(getCardImage(brand),height: 25,)
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
             "$brand",
              style: montserratSemiBold(fontSize: 14),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "**** $cardNumber       $expMonth/${expYear.substring(expYear.length - 2)}",
              style: montserratSemiBold(
                  fontSize: 12, color: DynamicColors.accentColor.withOpacity(0.4)),
            ),
          ],
        ),
      ],
    );
  }

  // String getCardType(value) {
  //   switch (value) {
  //     case "Visa":
  //       return "4242";
  //     case "Discover":
  //       return "6542";
  //     case "MasterCard":
  //       return "5442";
  //     case "AmericanExpress":
  //       return "3737";
  //     default:
  //       return "4242";
  //   }
  // }
  String getCardImage(value){
    switch(value){
      case "Visa":
        return "assets/shop/visa.png";
      case "Discover":
        return "assets/shop/discover.png";
      case "MasterCard":
        return "assets/shop/logo.png";
      case "AmericanExpress":
        return "assets/shop/american-express.png";
      default:
        return "assets/shop/card.png";
    }
  }

  Widget creditCardCheck() {
    if (controller.cardListModel != null) {
      if (controller.cardListModel!.data!.data!.isEmpty) {
        return Text("No Card",style: poppinsRegular(color: DynamicColors.primaryColor,fontSize: 15),);
      }
      CardDetails details = controller.cardListModel!.data!.data!
          .singleWhere((e) => e.isDefault == 1);
      return buildCreditCardWidget(
        details.brand??"",
          details.last4!,
          details.expMonth.toString(),
          details.expYear.toString(),
          details.funding.toString().capitalizeFirst!,
          details.id!,
      );
    } else {
      return Text("No Card",style: poppinsRegular(color: DynamicColors.primaryColor,fontSize: 15),);
    }
  }
}
