import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/textField.dart';
import 'package:bloodlines/View/Groups/Model/groupSelectionModel.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectGroupType extends StatelessWidget {
  SelectGroupType({Key? key}) : super(key: key);
  RxList<String> tags = <String>[].obs;
  FeedController controller = Get.find();
  final formKey = GlobalKey<FormState>();
  int? id = Get.arguments == null?null:Get.arguments["id"];
  bool isUpdate = Get.arguments == null?false:true;

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
          "Select Group Type",
          style:
          poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            id != null?Container():    SizedBox(
              height: 30,
              child: ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: groupSelectionModelList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          for (var element in groupSelectionModelList) {
                            if (element.isSelected!.value == true) {
                              element.isSelected!.value = false;
                            } else {
                              controller.groupType.value = element.name;
                              element.isSelected!.value = true;
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: DynamicColors.accentColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(() {
                                  return Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: groupSelectionModelList[index]
                                            .isSelected!
                                            .value ==
                                            true
                                            ? DynamicColors.primaryColorRed
                                            : DynamicColors.accentColor),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  );
                                }),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  groupSelectionModelList[index].name,
                                  style: montserratSemiBold(fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(() {
              if(controller.groupType.value == "Free Group"){
                return Container();
              }
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Set Monthly Subscriptions Charges",
                      style: poppinsRegular(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CustomTextField(
                      hint: "50\$",
                      controller: controller.charges,
                      validationError: "prince",
                      mainPadding: EdgeInsets.zero,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }),
            Text(
              "Group Terms and Conditions",
              style: poppinsRegular(fontSize: 16),
            ),
            SizedBox(
              height: 5,
            ),
            CustomTextField(
              hint: "Lorem ipsum dolor sit amet, consetetur.",
              mainPadding: EdgeInsets.zero,
            ),
            Spacer(),
            Center(
              child: CustomButton(
                text: isUpdate == true?"Update":"Create",
                isLong: false,
                onTap: () {
                  if(formKey.currentState == null){
                    controller.createGroup(isUpdate:isUpdate,id:id);
                  }else{
                    if(formKey.currentState!.validate()){
                      controller.createGroup(isUpdate:isUpdate,id:id);

                    }
                  }

                },
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                color: DynamicColors.primaryColorRed,
                borderColor: Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                style: poppinsSemiBold(
                  color: DynamicColors.whiteColor,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text:
                      "By clicking Create, I agree that I have read and accepted\n the",
                      style: poppinsRegular(
                        fontSize: 10,
                        color: DynamicColors.accentColor.withOpacity(0.5),
                      )),
                  TextSpan(
                      text: " Terms of Condition ",
                      style: poppinsRegular(
                          color: DynamicColors.primaryColorRed, fontSize: 10)),
                  TextSpan(
                      text: "and", //
                      style: poppinsRegular(
                        fontSize: 10,
                        color: DynamicColors.accentColor.withOpacity(0.5),
                      )),
                  TextSpan(
                      text: " Fee Policy.",
                      style: poppinsRegular(
                          color: DynamicColors.primaryColorRed, fontSize: 10)),
                ]),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
