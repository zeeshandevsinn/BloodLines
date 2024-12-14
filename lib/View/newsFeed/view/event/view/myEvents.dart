import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/View/newsFeed/view/event/view/eventItems.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/Timeline/View/timeline.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Routes/app_pages.dart';

class MyEvents extends StatelessWidget {
  MyEvents({Key? key}) : super(key: key);

  FeedController controller = Get.find();

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
          "My Events",
          style:
              poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
        ),
        elevation: 0,
        actions: [
          AppBarWidgets(
            // height: 50,
            // width: 50,
            leftPadding: 0,
            onTap: () {
              Get.toNamed(Routes.searchClass);
            },
            color: DynamicColors.primaryColor,
            icon: Octicons.search,
            size: 20,
            margin: 2,
            // padding: EdgeInsets.all(8),
          ),
          SizedBox(
            width: 10,
          ),
          AppBarWidgets(
            // height: 50,
            // width: 50,
            leftPadding: 0,
            onTap: () {
              Get.toNamed(Routes.addEvent);
            },
            color: DynamicColors.primaryColor,
            icon: Icons.add_circle,
            size: 25,
            margin: 2,
            // padding: EdgeInsets.all(8),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: GetBuilder<FeedController>(builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                EventTabBarClass(),
                SizedBox(
                  height: 30,
                ),
                Obx(() {
                  return IndexedStack(
                    index: controller.eventTabIndex.value,
                    children: [
                      controller.createdEvents == null?LoaderClass():
                      controller.createdEvents!.data!.isEmpty?
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/4),
                        child: Center(
                          child: Text(
                            "No Data",
                            style: poppinsBold(fontSize: 25),
                          ),
                        ),
                      ):

                      ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.createdEvents!.data!.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            if(controller.createdEvents!.data![index].isReported == 1){
                              return Container();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: EventItemsClass(
                                    myEvent: true,
                                    data: controller.createdEvents!.data![index],
                                      index:index
                                  ),
                                ),
                              ),
                            );
                          }),
                      controller.attendingEvents == null?LoaderClass():
                      controller.attendingEvents!.data!.isEmpty?
                      Center(
                        child: Text(
                          "No Data",
                          style: poppinsBold(fontSize: 25),
                        ),
                      ):

                      ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.attendingEvents!.data!.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: EventItemsClass(
                                    data: controller.attendingEvents!.data![index],
                                      index:index
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  );
                })
              ],
            ),
          ),
        );
      }),
    );
  }
}

class EventTabBarClass extends StatelessWidget {
  EventTabBarClass({
    Key? key,
  }) : super(key: key);

  FeedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Obx(() {
                  return CustomTabBarClass(
                    onTap: () {
                      controller.eventTabIndex.value = 0;
                    },
                    title: "Created Events",
                    tabValue: controller.eventTabIndex.value,
                    value: 0,
                  );
                })),
            Expanded(
                flex: 3,
                child: Obx(() {
                  return CustomTabBarClass(
                    onTap: () {
                      controller.eventTabIndex.value = 1;
                    },
                    title: "Attending Events",
                    tabValue: controller.eventTabIndex.value,
                    value: 1,
                  );
                })),
          ],
        ),
      ),
    );
  }
}
