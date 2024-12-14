import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/View/Account/View/accountTabs/order.dart';
import 'package:bloodlines/View/Account/View/accountTabs/referal.dart';
import 'package:bloodlines/View/Account/View/accountTabs/subscription.dart';
import 'package:bloodlines/View/Timeline/View/timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Account extends StatelessWidget {
  Account({Key? key}) : super(key: key);
  RxInt tab = 0.obs;

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
          "Account Orders & Subscriptions",
          style: poppinsSemiBold(
            color: DynamicColors.primaryColor,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Obx(() {
                      return CustomTabBarClass(
                        onTap: () {
                          tab.value = 0;
                        },
                        title: "Referral Reward",
                        tabValue: tab.value,
                        value: 0,
                      );
                    })),
                Expanded(
                    flex: 3,
                    child: Obx(() {
                      return CustomTabBarClass(
                        onTap: () {
                          tab.value = 1;
                        },
                        title: "Orders",
                        tabValue: tab.value,
                        value: 1,
                      );
                    })),
                Expanded(
                    flex: 3,
                    child: Obx(() {
                      return CustomTabBarClass(
                        onTap: () {
                          tab.value = 2;
                        },
                        title: "Subscriptions Plan",
                        tabValue: tab.value,
                        value: 2,
                      );
                    })),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Obx(() {
              return IndexedStack(
                index: tab.value,
                children: [
                  Referral(),
                  Order(),
                  Subscription(),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
