import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Shop/Data/shopController.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderConfirmation extends StatefulWidget {
  OrderConfirmation({Key? key}) : super(key: key);

  @override
  State<OrderConfirmation> createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  FeedController controller = Get.find();
  ShopController sController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sController.getCart();

  }

  Future<bool> onWillPop()async{
    controller.tabIndex.value = 5;
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
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff44D749), width: 3),
                      shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Icon(
                      Icons.check,
                      size: 70,
                      color: Color(0xff44D749),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Order Confirmed",
                style: montserratSemiBold(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Your order has been placed successfully.",
                textAlign: TextAlign.center,
                style: montserratRegular(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
