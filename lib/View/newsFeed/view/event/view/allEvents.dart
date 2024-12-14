import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/view/event/view/eventItems.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/TextStyle.dart';

class AllEvents extends StatelessWidget {
  AllEvents({Key? key}) : super(key: key);

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
          "Events",
          style:
              poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
        ),
        elevation: 0,
      ),
      body: GetBuilder<FeedController>(builder: (controller) {
        return controller.events == null
            ? LoaderClass()
            : controller.events!.data!.isEmpty?
        Center(
          child: Text(
            "No Data",
            style: poppinsBold(fontSize: 25),
          ),
        )
            :SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.events!.data!.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            if( controller.events!.data![index].isReported == 1){
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
                                    data: controller.events!.data![index],
                                    myEvent: controller
                                                .events!.data![index].user!.id ==
                                            Api.singleton.sp.read("id")
                                        ? true
                                        : false,
                                    index: index,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
