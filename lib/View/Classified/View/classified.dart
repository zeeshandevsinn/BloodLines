import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/Classified/Data/classifiedController.dart';
import 'package:bloodlines/View/Classified/View/classifiedDetails/productAndServices.dart';
import 'package:bloodlines/View/Timeline/View/timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Classified extends StatelessWidget {
  Classified({Key? key}) : super(key: key);
  RxInt tab = 0.obs;
  ClassifiedController controller = Get.put(ClassifiedController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClassifiedController>(builder: (controller) {
      if (controller.classifiedAdModel == null &&controller.forShowingClassifiedCategoriesModel == null ) {
        return Center(
          child: LoaderClass(),
        );
      }
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              controller.forShowingClassifiedCategoriesModel == null
                  ? Container()
                  : Row(
                      children: controller
                          .forShowingClassifiedCategoriesModel!.data!
                          .map((e) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Obx(() {
                            return CustomTabBarClass(
                              onTap: () {
                                if (tab.value != e.id!) {
                                  controller.classifiedAdModel = null;
                                  controller.update();
                                }

                                tab.value = e.id!;
                                controller.getClassifiedAds(id: e.id!);
                              },
                              title: e.title!,
                              tabValue: tab.value,
                              value: e.id!,
                            );
                          }),
                        ),
                      );
                    }).toList()

                      // Expanded(
                      //     flex: 3,
                      //     child: Obx(() {
                      //       return CustomTabBarClass(
                      //         onTap: () {
                      //           tab.value = 1;
                      //         },
                      //         title: "Adults",
                      //         tabValue: tab.value,
                      //         value: 1,
                      //       );
                      //     })),
                      // Expanded(
                      //     flex: 3,
                      //     child: Obx(() {
                      //       return CustomTabBarClass(
                      //         onTap: () {
                      //           tab.value = 2;
                      //         },
                      //         title: "Studs",
                      //         tabValue: tab.value,
                      //         value: 2,
                      //       );
                      //     })),
                      // Expanded(
                      //     flex: 5,
                      //     child: Obx(() {
                      //       return CustomTabBarClass(
                      //         onTap: () {
                      //           tab.value = 3;
                      //         },
                      //         title: "Products & Services",
                      //         tabValue: tab.value,
                      //         value: 3,
                      //       );
                      //     })),

                      ),
              SizedBox(
                height: 20,
              ),
              controller.classifiedAdModel == null?
                  Padding(
                    padding:  EdgeInsets.only(top: Utils.height(context)/4),
                    child: Center(child: LoaderClass(),),
                  )
                  :   controller.classifiedAdModel!.data!.isEmpty?
              Padding(
                padding:  EdgeInsets.only(top: Utils.height(context)/4),
                child: Center(
                  child: Text(
                    "No Ad Found",
                    style: poppinsBold(fontSize: 25),
                  ),
                ),
              )
                  :     ProductAndServices(
                  classifiedAdDataList: controller.classifiedAdModel!.data!),
              // Obx(() {
              //   return IndexedStack(
              //     index: tab.value,
              //     children: [
              //       ProductAndServices(
              //           productAndServicesList: productAndServicesList),
              //       ProductAndServices(
              //           productAndServicesList: productAndServicesList),
              //       ProductAndServices(
              //           productAndServicesList: productAndServicesList),
              //       ProductAndServices(
              //           productAndServicesList: productAndServicesList),
              //     ],
              //   );
              // })
            ],
          ),
        ),
      );
    });
  }
}
