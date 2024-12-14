// ignore_for_file: must_be_immutable, invalid_use_of_protected_member

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/View/Pedigree/Data/pedigreeController.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class TagPostPedigree extends StatelessWidget {
  TagPostPedigree({Key? key}) : super(key: key);
  FeedController controller = Get.find();
  PedigreeController pedigreeController = Get.put(PedigreeController());

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
          "Tag Pedigree",
          style:
          poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 28),
        ),
        elevation: 0,
      ),
      body: GetBuilder<PedigreeController>(
          initState: (a){
            pedigreeController.getAllPedigrees();
          },
          builder: (pedigreeController) {
        if (pedigreeController.pedigreeModel == null) {
          return Center(
            child: LoaderClass(),
          );
        }
        if (pedigreeController.pedigreeModel!.data!.isEmpty) {
          return Center(
            child: Text(
              "No Data",
              style: poppinsBold(fontSize: 25),
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount:pedigreeController.pedigreeModel!.data!.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    PedigreeSearchData user = pedigreeController.pedigreeModel!.data![index];
                    if (controller.taggedPedigree
                        .any((element) => element.id == user.id)) {
                      user.isTagSelected!.value = true;
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child:
                              SizedBox(
                                child: OptimizedCacheImage(
                                  imageUrl:
                                  user.photos![0].photo!,
                                  fit: BoxFit.cover,
                                ),
                              ),

                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "${user.ownerName} ",
                                  style: poppinsRegular(
                                      fontSize: 12, color: DynamicColors.primaryColor)),
                              TextSpan(
                                  text: user.beforeNameTitle == null
                                      ? ""
                                      : "${user.beforeNameTitle!.toUpperCase()} ",
                                  style: poppinsRegular(
                                      fontSize: 12, color: DynamicColors.primaryColorRed)),
                              TextSpan(
                                  text: "${user.dogName} ",
                                  style: poppinsRegular(
                                      fontSize: 12, color: DynamicColors.primaryColor)),
                              TextSpan(
                                  text: user.afterNameTitle == null
                                      ? ""
                                      : "${user.afterNameTitle!.toUpperCase()} ",
                                  style: poppinsRegular(
                                      fontSize: 12, color: DynamicColors.primaryColor)),
                            ]),
                          ),
                          Spacer(),
                          Obx(() {
                            return InkWell(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)),
                              onTap: () {
                                user.isTagSelected!.value =
                                !user.isTagSelected!.value;
                                if (user.isTagSelected!.value == true) {
                                  controller.taggedPedigreeList.add(user.id!);
                                  controller.taggedPedigree.add(user);
                                } else {
                                  controller.taggedPedigreeList.removeWhere(
                                          (element) => element == user.id);
                                  controller.taggedPedigree.value.removeWhere(
                                          (element) => element.id == user.id);
                                  print(controller.taggedUser.value);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: user.isTagSelected!.value == false
                                        ? DynamicColors.accentColor
                                        : DynamicColors.primaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.check,
                                    color: DynamicColors.whiteColor,
                                    size: 15,
                                  ),
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    );
                  }),
            ],
          ),
        );
      }),
    );
  }
}
