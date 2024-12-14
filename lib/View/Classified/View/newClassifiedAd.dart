import 'dart:io';

import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/dropDownClass.dart';
import 'package:bloodlines/Components/textFieldComponent.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/Chat/view/delegate.dart';
import 'package:bloodlines/View/Classified/Data/classifiedController.dart';
import 'package:bloodlines/View/Classified/Model/categoryModel.dart';
import 'package:bloodlines/View/Classified/Model/classifiedAdModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

// ignore: must_be_immutable
class NewClassifiedAd extends StatefulWidget {
  NewClassifiedAd({Key? key}) : super(key: key);

  @override
  State<NewClassifiedAd> createState() => _NewClassifiedAdState();
}

class _NewClassifiedAdState extends State<NewClassifiedAd> {
  ClassifiedController controller = Get.find();

  ClassifiedCategoriesData? dropValue;

  final formKey = GlobalKey<FormState>();

  ClassifiedAdData? result = Get.arguments == null? null : Get.arguments["data"];

  String ?week;
  int? id;

  String? cover;
  List<String> weekList = [
    "1 Week",
    "2 Weeks",
    "3 Weeks",
    "4 Weeks",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(result != null){
      controller.classifiedPhotos.clear();
      id = result!.id!;
      controller.titleController.text = result!.title!;
      controller.descriptionController.text =result!.description!;
      controller.priceController.text = result!.price!;
      if(result!.location != null){
        controller.locationController.text = result!.location!;
        controller.lat = result!.latitude!;
        controller.long = result!.longitude!;
      }
      if(result!.classifiedPhotos!.isNotEmpty){
        controller.classifiedPhotos = result!.classifiedPhotos!;
      }
      int index = controller.classifiedCategoriesModel!.data!.indexWhere((element) => element.id == result!.categoryId);
      dropValue =  controller.classifiedCategoriesModel!.data![index];

    }
  }

  @override
  Widget build(BuildContext context) {
    // BotToast.closeAllLoading();
    return Scaffold(
      backgroundColor: DynamicColors.primaryColorLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: AppBarWidgets(),
        title: Text(
          "New Classified Ad",
          style:
              poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
        ),
        elevation: 0,
      ),
      body: GetBuilder<ClassifiedController>(builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key:formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: Utils.height(context) /4.5,
                    width: double.infinity,
                    child:  DottedBorder(
                      dashPattern: [8],
                      color: DynamicColors.primaryColor,
                      borderType: BorderType.RRect,
                      radius: Radius.circular(6),
                      padding: EdgeInsets.all(6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:controller.classifiedPhotos.isEmpty
                            ? Center(
                          child: InkWell(
                            onTap: () {
                              controller.bottomSheet(context);
                            },
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: DynamicColors.primaryColor,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Add Photos",
                                  style: poppinsRegular(
                                      color: DynamicColors.accentColor,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        )
                            : Stack(
                          children: [
                            buildGridView(controller),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  controller.bottomSheet(context);
                                },
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: DynamicColors
                                              .primaryColor,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Add Photos",
                                      style: poppinsRegular(
                                          color:
                                          DynamicColors.accentColor,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldComponent(
                      title: "Title",
                      hint: "Selling New Shoes",
                      controller: controller.titleController),
                  TextFieldComponent(
                      title: "Description",
                      hint: "Lorem ipsum dolor sit amet, consetetur.",
                      controller: controller.descriptionController),
                  TextFieldComponent(
                      title: "Price",
                      hint: "\$56",
                      textInputType: TextInputType.number,
                      controller: controller.priceController),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldComponent(
                      title: "Location",
                      hint: "Chicago, New York, NY, USA",
                      readOnly: true,
                      onTap: () {
                        controller.determinePosition();
                      },
                      fromPedigree: true,
                      controller: controller.locationController,
                      suffix: InkWell(
                        onTap: () {
                          controller.determinePosition();
                        },
                        child: Icon(
                          Icons.location_pin,
                          color: DynamicColors.primaryColorRed,
                        ),
                      )),
                  SizedBox(
                    height: 40,
                  ),

                  Text(
                    "Ad Validity",
                    style: poppinsLight(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5,),
                  DropDownClass(
                    hint: "1 Week",
                    initialValue: week,
                    list: weekList,
                    validationError: 'week',
                    fromPedigree: false,
                    listener: (v){
                      week = v;
                    },
                  ),
                  SizedBox(
                    height: 20,

                  ),
                  ClassifiedDropDownClass(
                    initialValue: dropValue,
                    list: controller.classifiedCategoriesModel!.data!,
                    hint: "Select a category",
                    hintStyle: montserratSemiBold(fontSize: 16),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: DynamicColors.primaryColorRed, width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: DynamicColors.primaryColorRed, width: 1)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: DynamicColors.primaryColorRed, width: 1)),
                    validationError: "category",
                    listener: (value){
                      dropValue = value;
                    },
                  ),

                  SizedBox(
                    height: kToolbarHeight,
                  ),
                  Center(
                    child: CustomButton(
                      text: id != null?"Update":"Create",
                      isLong: false,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                         if(dropValue != null) {
                            controller.createAd(dropValue!.id!,
                                adId: id,status: result != null?result!.status:null,
                            week:week);
                          }else{
                           BotToast.showText(text: "Please select category");
                         }
                        }

                      },
                      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 40),
                      color: DynamicColors.primaryColorRed,
                      borderColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      style:
                          poppinsSemiBold(color: DynamicColors.primaryColorLight),
                    ),
                  ),
                  SizedBox(
                    height: kToolbarHeight / 2,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
  GridView buildGridView(ClassifiedController controller) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: controller.classifiedPhotos.length,
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(crossAxisCount: 3,height: Utils.height(context)/10),
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [
            controller.classifiedPhotos[index].id != null
                ? OptimizedCacheImage(
                imageUrl: controller.classifiedPhotos[index].photo!,
                fit: BoxFit.cover,
                width: Utils.width(context)/3)
                : Image.file(
              File(controller.classifiedPhotos[index].localImage!.path),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 5),
                child: InkWell(
                  onTap: () {
                    if (controller.classifiedPhotos[index].id != null) {
                      controller.deleteMediaIds
                          .add(controller.classifiedPhotos[index].id.toString());
                    }
                    controller.classifiedPhotos.removeAt(index);
                    controller.update();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: DynamicColors.whiteColor,
                          shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Icon(
                          Icons.close,
                          color: DynamicColors.primaryColor,
                        ),
                      )),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
