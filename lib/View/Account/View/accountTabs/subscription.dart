import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/Account/Model/subscriptionPlan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Subscription extends StatelessWidget {
  Subscription({Key? key}) : super(key: key);
  RxInt yearlyIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Utils.height(context) - kToolbarHeight * 3,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Bloodlines App Subscription",
                    style: montserratBold(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: subscriptionPlansList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            for (var element in subscriptionPlansList) {
                              if (element.isSelected!.value == true) {
                                element.isSelected!.value = false;
                              } else {
                                element.isSelected!.value = true;
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: subscriptionPlan(
                                subscriptionPlansList[index].title,
                                subscriptionPlansList[index].price,
                                subscriptionPlansList[index]),
                          ),
                        );
                      }),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color: DynamicColors.accentColor,
                  //       ),
                  //       borderRadius: BorderRadius.circular(5)),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           flex: 1,
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(top: 6),
                  //             child: Container(
                  //               decoration: BoxDecoration(
                  //                 border: Border.all(
                  //                     color: DynamicColors.accentColor,
                  //                     width: 2),
                  //                 shape: BoxShape.circle,
                  //               ),
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(3.0),
                  //                 child: Container(
                  //                   width: 10,
                  //                   height: 10,
                  //                   decoration: BoxDecoration(
                  //                       color: DynamicColors.accentColor,
                  //                       shape: BoxShape.circle),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           width: 5,
                  //         ),
                  //         Expanded(
                  //           flex: 10,
                  //           child: Row(
                  //             children: [
                  //               Text(
                  //                 "Yearly Plan",
                  //                 style: poppinsBold(
                  //                   fontSize: 20,
                  //                   color: DynamicColors.accentColor,
                  //                 ),
                  //               ),
                  //               Spacer(),
                  //               Text(
                  //                 "\$ 20",
                  //                 style: poppinsBold(
                  //                   fontSize: 20,
                  //                   color: DynamicColors.accentColor,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Groups Subscription",
                    style: montserratBold(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          "assets/following/6.png",
                          height: 60,
                          width: 50,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lorem ipsum dolor sit amet, consetetur.",
                              style: montserratRegular(fontSize: 16),
                            ),
                            Text(
                              "Starting 10-12-2023",
                              style: montserratBold(
                                  fontSize: 12,
                                  color: DynamicColors.accentColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "\$ 26",
                        style: poppinsBold(
                          fontSize: 20,
                          color: DynamicColors.accentColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
              text: "Buy Now",
              isLong: false,
              onTap: () {},
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              color: DynamicColors.primaryColorRed,
              borderColor: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              style: poppinsSemiBold(
                color: DynamicColors.whiteColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget subscriptionPlan(title, price, SubscriptionPlan plan) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: plan.isSelected!.value == false
                  ? DynamicColors.accentColor
                  : DynamicColors.primaryColorRed,
            ),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: plan.isSelected!.value == false
                              ? DynamicColors.accentColor
                              : DynamicColors.primaryColorRed,
                          width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: plan.isSelected!.value == false
                                ? DynamicColors.accentColor
                                : DynamicColors.primaryColorRed,
                            shape: BoxShape.circle),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: poppinsBold(
                              fontSize: 20,
                              color: plan.isSelected!.value == false
                                  ? DynamicColors.accentColor
                                  : DynamicColors.textColor),
                        ),
                        Spacer(),
                        Text(
                          price,
                          style: poppinsBold(
                              fontSize: 20,
                              color: plan.isSelected!.value == false
                                  ? DynamicColors.accentColor
                                  : DynamicColors.textColor),
                        ),
                      ],
                    ),
                    plan.isSelected!.value == false
                        ? SizedBox.shrink()
                        : Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "1. Lorem ipsum dolor sit amet, consetetur sadipscing",
                                style: poppinsRegular(fontSize: 12),
                              ),
                              Text(
                                "2. sed diam nonumy eirmod tempor invidunt utaccusam et justo duo dolores et ea rebum.",
                                style: poppinsRegular(fontSize: 12),
                              ),
                              Text(
                                "3. dolore magna aliquyam erat, sed diam voluptuao",
                                style: poppinsRegular(fontSize: 12),
                              ),
                              Text(
                                "4. eos et accusam et justo duo dolores et ea rebum.",
                                style: poppinsRegular(fontSize: 12),
                              ),
                              Text(
                                "5. clita kasd gubergren, no sea takimata sanctus est",
                                style: poppinsRegular(fontSize: 12),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
