import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Shop/Data/shopController.dart';
import 'package:bloodlines/View/Shop/Model/orderHistoryModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class OrderHistory extends StatelessWidget {
  OrderHistory({Key? key}) : super(key: key);
  ShopController controller = Get.find();
  Future<bool> onWillPop() async {
    controller.orderHistoryModel = null;
    Get.back();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:onWillPop,
      child: Scaffold(
        backgroundColor: DynamicColors.primaryColorLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: AppBarWidgets(
            onTap: (){
              onWillPop();
            },
          ),
          title: Text(
            "Order History",
            style:
                poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
          ),
          elevation: 0,
        ),
        body: GetBuilder<ShopController>(initState: (c) {
          controller.getOrderHistory();
        }, builder: (controller) {
          if (controller.orderHistoryModel == null) {
            return Center(
              child: LoaderClass(),
            );
          } else if (controller.orderHistoryModel!.data!.data!.isEmpty) {
            return Center(
              child: Text(
                "No Data",
                style: poppinsBold(fontSize: 25),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: controller.orderHistoryModel!.data!.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  OrderHistoryData data =
                      controller.orderHistoryModel!.data!.data![index];
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.orderDetailView,arguments: {
                        "id":data.id
                      });
                    },
                    child:productWidget(data),


                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 5),
                    //   child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
                    //     elevation: 10,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10)),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         children: [
                    //           Row(
                    //             children: [
                    //               Text(
                    //                 "Order ID: ",
                    //                 style: poppinsBold(),
                    //               ),
                    //               Text(
                    //                 data.orderNumber!,
                    //                 style: poppinsRegular(),
                    //               ),
                    //             ],
                    //           ),
                    //           SizedBox(
                    //             height: 10,
                    //           ),
                    //           Row(
                    //             children: [
                    //               Text(
                    //                 "Total Amount: ",
                    //                 style: poppinsBold(),
                    //               ),
                    //               Text(
                    //                 data.totalAmount!,
                    //                 style: poppinsRegular(),
                    //               ),
                    //             ],
                    //           ),
                    //           SizedBox(
                    //             height: 10,
                    //           ),
                    //           Row(
                    //             children: [
                    //               Text(
                    //                 "Order Date: ",
                    //                 style: poppinsBold(),
                    //               ),
                    //               Text(
                    //                 DateFormat("MMM-dd-yyyy")
                    //                     .format(DateTime.parse(data.createdAt!)),
                    //                 style: poppinsRegular(),
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  );
                }),
          );
        }),
      ),
    );
  }
//   Container productWidget({
//  required  OrderHistoryData data
// }) {
//     return Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey[300]!,
//               blurRadius: 10.0,
//             ),
//           ],
//         ),
//         child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//           child: Row(
//             children: [
//               Expanded(flex: 4, child: OptimizedCacheImage(imageUrl: 'data',)),
//               SizedBox(
//                 width: 5,
//               ),
//               Expanded(
//                   flex: 5,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'data.',
//                         style: montserratBold(fontSize: 12),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 10),
//                         child: Row(
//                           children: [
//                             Text(
//                               data.totalAmount!,
//                               style: montserratExtraBold(fontSize: 14),
//                             ),
//                             Spacer(),
//                             Text(
//                               "02",
//                               style: montserratExtraBold(
//                                   fontSize: 14,
//                                   color: DynamicColors.primaryColorRed),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         "Order Number",
//                         style: montserratBold(fontSize: 14),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         "1536546548654",
//                         style: montserratSemiBold(fontSize: 14),
//                       ),
//                     ],
//                   ))
//             ],
//           ),
//         ));
//   }
  Widget productWidget(OrderHistoryData data) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(flex: 4, child: OptimizedCacheImage(
                  imageUrl: data.orderItems![0].product!.image!,
                )),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.orderItems![0].product!.name!,
                          style: montserratBold(fontSize: 12),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            children: [
                              Text(
                                "${data.totalAmount}",
                                style: montserratExtraBold(fontSize: 14),
                              ),
                              Spacer(),
                              Text(
                                data.orderItems!.length.toString(),
                                style: montserratExtraBold(
                                    fontSize: 14,
                                    color: DynamicColors.primaryColorRed),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Order Number",
                          style: montserratBold(fontSize: 14),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          data.orderNumber!,
                          style: montserratSemiBold(fontSize: 14),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
