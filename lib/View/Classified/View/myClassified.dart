import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/View/Classified/Data/classifiedController.dart';
import 'package:bloodlines/View/Classified/View/classifiedDetails/productAndServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MyClassified extends StatelessWidget {
  MyClassified({Key? key}) : super(key: key);

  ClassifiedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: AppBarWidgets(
          isCardType: true,
        ),
        centerTitle: true,
        title: Text(
          "My Classified",
          style: montserratBold(),
        ),
      ),
      body: GetBuilder<ClassifiedController>(builder: (controller) {
        if(controller.myClassifiedAdModel == null){
          return Center(
            child: LoaderClass(),
          );
        }
        if(controller.myClassifiedAdModel!.data!.isEmpty){
          return Center(
            child: Text(
              "No Ad Found",
              style: poppinsBold(fontSize: 25),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ProductAndServices(
              classifiedAdDataList: controller.myClassifiedAdModel!.data!),
        );
      }),
    );
  }
}
