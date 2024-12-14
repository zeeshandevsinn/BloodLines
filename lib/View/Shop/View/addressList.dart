import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Shop/Data/shopController.dart';
import 'package:bloodlines/View/Shop/Model/addressModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressList extends StatelessWidget {
  AddressList({super.key});
  ShopController controller = Get.find();


  Future<bool> onWillPop()async{
    controller.getCart();
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
            "Address",
            style:
            poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
          ),
          elevation: 0,
        ),
        body: GetBuilder<ShopController>(
            initState: (c){
              controller.getAddressList();
            },
            builder: (controller) {
          if (controller.addressListModel == null) {
            return Center(
                child: LoaderClass()
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CustomButton(
                      text: "Add New Address",
                      onTap: () {
                        Get.toNamed(Routes.addAddress);
                      },
                      isLong: false,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      borderRadius: BorderRadius.circular(5),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      color: DynamicColors.primaryColorRed,
                      borderColor: DynamicColors.primaryColorRed,
                      style: montserratSemiBold(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: DynamicColors.whiteColor),
                    ),
                  ),
                  SizedBox(height: 20,),
                  controller.addressListModel!.data!.isEmpty ?
                  Padding(
                    padding: EdgeInsets.only(top: Utils.height(context) / 4),
                    child: Center(
                      child: Text(
                        "No Data",
                        style: poppinsBold(fontSize: 25),
                      ),
                    ),
                  )
                      : ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.addressListModel!.data!.length,
                      itemBuilder: (context, index) {
                        ShippingAddress shipping = controller.addressListModel!
                            .data![index].shippingAddress!;
                        ShippingAddress billing = controller.addressListModel!
                            .data![index].billingAddress!;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Obx(() {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: shipping.defaultAddress!.value== 0?DynamicColors.primaryColorLight:DynamicColors.primaryColorRed),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[300]!,
                                    blurRadius: 10.0,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Text(
                                          "Shipping Details",
                                          style: poppinsBold(fontSize: 15),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                            onTap: (){
                                              Get.bottomSheet(BottomSheetAddressEdit(result: shipping,billing:billing));
                                            },
                                            child: Icon(Icons.more_vert,))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),

                                    AddressWidget(shipping: shipping),
                                    SizedBox(height: 10,),
                                    Text(
                                      "Billing Details",
                                      style: poppinsBold(fontSize: 15),
                                    ),


                                    SizedBox(
                                      height: 10,
                                    ),
                                    AddressWidget(shipping: billing),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: CustomButton(
                                        text: "Go to map",
                                        onTap: () async{
                                          if (Platform.isAndroid) {
                                            final AndroidIntent intent = AndroidIntent(
                                                action: 'action_view',
                                                data: Uri.encodeFull(
                                                    "https://www.google.com/maps/search/?api=1&query=${shipping.latitude},${shipping.longitude}"),
                                                package: 'com.google.android.apps.maps');
                                            intent.launch();
                                          } else {
                                            String url =
                                                "https://www.google.com/maps/search/?api=1&query=${shipping.latitude},${shipping.longitude}";
                                            if (await canLaunchUrl(Uri.parse(url))) {
                                          await launchUrl(Uri.parse(url));
                                          } else {
                                          throw 'Could not launch $url';
                                          }
                                        }
                                        },
                                        isLong: false,
                                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                        borderRadius: BorderRadius.circular(5),
                                        margin: EdgeInsets.symmetric(vertical: 10),
                                        color: DynamicColors.primaryColorRed,
                                        borderColor: DynamicColors.primaryColorRed,
                                        style: montserratSemiBold(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: DynamicColors.whiteColor),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    shipping.defaultAddress!.value== 1?
                                    Center(
                                      child: Text("Default Address",style: poppinsBold(color: DynamicColors.primaryColorRed),),
                                    )
                                        :  Center(
                                      child: CustomButton(
                                        text: "Set as default",
                                        onTap: () {
                                          controller.changeDefaultAddress(shipping.id!);
                                        },
                                        isLong: false,
                                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                        borderRadius: BorderRadius.circular(5),
                                        margin: EdgeInsets.symmetric(vertical: 10),
                                        color: DynamicColors.primaryColorRed,
                                        borderColor: DynamicColors.primaryColorRed,
                                        style: montserratSemiBold(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: DynamicColors.whiteColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      })
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class AddressWidget extends StatelessWidget {
  AddressWidget({
    super.key,
    required this.shipping,
  });

  final ShippingAddress shipping;
  ShopController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Name: ",
              style: poppinsLight(fontSize: 12),),
            Text("${shipping.firstName} ${shipping
                .lastName}",
              style: poppinsLight(fontSize: 12),),
          ],
        ),

        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text("Contact: ",
              style: poppinsLight(fontSize: 12),),
            Text("${shipping.contact}",
              style: poppinsLight(fontSize: 12),),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Address: ",
              style: poppinsLight(fontSize: 12),),
            SizedBox(
              width: Utils.width(context)/1.4,
              child: Text("${shipping.streetAddress}",
                style: poppinsLight(fontSize: 12),),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Location: ",
              style: poppinsLight(fontSize: 12),),
            SizedBox(
              width: Utils.width(context)/1.4,
              child: Text("${shipping.city == null ? '' : '${shipping.city},'} ${shipping
                  .state == null ? '' : '${shipping.state},'} ${shipping.county}",
                style: poppinsLight(fontSize: 12),),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text("Zip Code: ",
              style: poppinsLight(fontSize: 12),),
            Text("${shipping.zipcode}",
              style: poppinsLight(fontSize: 12),),
          ],
        ),

      ],
    );
  }
}


class BottomSheetAddressEdit extends StatelessWidget {
  BottomSheetAddressEdit({super.key,required this.result,required this.billing});
  final ShopController controller = Get.find();
  ShippingAddress result;
  ShippingAddress billing;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: Utils.width(context),
          decoration: BoxDecoration(
              color: DynamicColors.primaryColorLight,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black.withOpacity(0.9),
                  blurRadius: 10,
                ),
              ]),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Container(
                    height: 5,
                    width: Utils.width(context) / 8,
                    color: DynamicColors.primaryColor,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      controller.deleteAddress(
                          result.id!);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: DynamicColors.primaryColor,
                          size: Utils.height(context) / 50,
                        ),
                        SizedBox(
                          width: Utils.width(context) / 30,
                        ),
                        Text(
                          "Delete Address",
                          style: poppinsRegular(
                              color: DynamicColors.textColor,
                              fontSize: Utils.height(context) / 60),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: DynamicColors.textColor,
                  height: 15,
                ),
                 Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.addAddress,arguments: {
                        "shipping":result,
                        "billing":billing,
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          color: DynamicColors.primaryColor,
                          size: Utils.height(context) / 50,
                        ),
                        SizedBox(
                          width: Utils.width(context) / 30,
                        ),
                        Text(
                          "Edit Address",
                          style: poppinsRegular(
                              color: DynamicColors.textColor,
                              fontSize: Utils.height(context) / 60),
                        )
                      ],
                    ),
                  ),
                ),


                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

