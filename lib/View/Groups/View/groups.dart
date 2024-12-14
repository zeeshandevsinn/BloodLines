import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/View/Groups/View/groupDetails/createdGroups.dart';
import 'package:bloodlines/View/Groups/View/groupDetails/joinedGroups.dart';
import 'package:bloodlines/View/Groups/View/groupDetails/myGroups.dart';
import 'package:bloodlines/View/Timeline/View/timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Groups extends StatelessWidget {
  Groups({Key? key}) : super(key: key);
  RxInt tab = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColors.primaryColorLight,
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
                        title: "All Groups",
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
                        title: "My Joined Groups",
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
                        title: "My Created Groups",
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
                  AllGroups(),
                  JoinedGroups(),
                  CreatedGroups(),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
