import 'package:bloodlines/View/Pedigree/Data/pedigreeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PedigreeSearch extends StatelessWidget {
  PedigreeSearch({Key? key}) : super(key: key);
  PedigreeController controller = Get.find();
  String searchType = Get.arguments["searchType"];

  RxBool unknown = false.obs;
  searchHit() {
    if (controller.searchTextController.text.isNotEmpty) {
      // controller.getSearchedData(searchType: searchType);
    }
  }
  int id = 0;

  Future<bool> onWillPop()async{
    if(unknown.value == true){
      id= 0;
      if(searchType == "dam"){
        controller.damNameController.text = "Unknown";
      }else{
        controller.sireNameController.text = "Unknown";
      }
    }
    controller.searchTextController.clear();
    // controller.pedigreeSearchModel = null;
    Get.back(result: id);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return WillPopScope(
    //     onWillPop:onWillPop,
    //   child: Scaffold(
    //     body: SingleChildScrollView(
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 10),
    //         child: Stack(
    //           alignment: Alignment.bottomCenter,
    //           children: [
    //
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 SizedBox(
    //                   height: Platform.isIOS ? 50 : 40,
    //                 ),
    //                 Row(
    //                   children: [
    //                     Expanded(
    //                       child: CustomTextField(
    //                         filled: true,
    //                         isUnderLineBorder: false,
    //                         controller: controller.searchTextController,
    //                         mainPadding: EdgeInsets.zero,
    //                         padding: EdgeInsets.only(left: 10, top: 12),
    //                         radius: 5,
    //                         hint: "Search here",
    //                         isBorder: true,
    //                         isTransparentBorder: true,
    //                         fillColor: Colors.grey[200]!,
    //                         onFieldSubmitted: (value) {
    //                           searchHit();
    //                         },
    //                         suffixIcon: Icon(
    //                           Icons.search,
    //                           color: Colors.black,
    //                         ),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       width: 5,
    //                     ),
    //                     InkWell(
    //                       onTap: () {
    //                         onWillPop();
    //                       },
    //                       child: Text(
    //                         "Cancel",
    //                         style: montserratSemiBold(
    //                             color: DynamicColors.primaryColorRed),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: 10,
    //                 ),
    //                 GestureDetector(
    //                   onTap: () {
    //                     if(controller.pedigreeSearchModel!= null && controller.pedigreeSearchModel!.data!.isNotEmpty){
    //                       for (int i = 0;
    //                           i < controller.pedigreeSearchModel!.data!.length;
    //                           i++) {
    //                         controller.pedigreeSearchModel!.data![i].isSelected!.value = false;
    //                       }
    //                     }
    //                     unknown.value = !unknown.value;
    //
    //                   },
    //                   child: Container(
    //                       decoration: BoxDecoration(
    //                         color: Colors.grey[200],
    //                         // selectedIndex.contains(index) ? Colors.green : Colors.white,
    //                         borderRadius: BorderRadius.circular(2),
    //                       ),
    //                       padding: EdgeInsets.symmetric(
    //                           vertical: 4, horizontal: 8),
    //                       child: RichText(
    //                         text: TextSpan(
    //                             children: [
    //                               WidgetSpan(
    //                                   alignment:PlaceholderAlignment.middle ,
    //                                   child: Obx(() {
    //                                     return Container(
    //                                       width: 15, height: 15,
    //                                       decoration: BoxDecoration(
    //                                           shape: BoxShape.circle,
    //                                           color: unknown.value == false ? Colors
    //                                               .grey : DynamicColors
    //                                               .primaryColorRed
    //                                       ),
    //                                       child: Center(
    //                                         child: Icon(Icons.check,color: Colors.white,size: 12,),
    //                                       ),
    //                                     );
    //                                   })),
    //                               WidgetSpan(child: SizedBox(width: 10,)),
    //                               TextSpan(
    //
    //                                 text: "Unknown",
    //                                 style: montserratSemiBold(
    //                                     color: Colors.black),
    //                               ),
    //                             ]
    //                         ),
    //                       )
    //                   ),
    //                 ),
    //                 DividerClass(),
    //                 GetBuilder<PedigreeController>(builder: (controller) {
    //                   if (controller.pedigreeSearchModel == null) {
    //                     return Container();
    //                   }
    //                   return Wrap(
    //                     crossAxisAlignment: WrapCrossAlignment.start,
    //                     alignment: WrapAlignment.start,
    //                     children: [
    //                       ...List.generate(
    //
    //                         controller.pedigreeSearchModel!.data!.length,
    //                             (index) =>
    //                             Padding(
    //                               padding: const EdgeInsets.symmetric(horizontal: 3),
    //                               child: GestureDetector(
    //                                 onTap: () {
    //                                   for (int i = 0; i < controller.pedigreeSearchModel!.data!.length; i++) {
    //
    //                                     if (controller.pedigreeSearchModel!.data![i].id ==
    //                                         controller.pedigreeSearchModel!.data![index]
    //                                             .id && controller.pedigreeSearchModel!.data![i].isSelected!.value == false) {
    //                                       print("${ controller.pedigreeSearchModel!.data![index].dogName} true");
    //
    //                                       controller.pedigreeSearchModel!.data![i]
    //                                           .isSelected!.value = true;
    //                                       id =  controller.pedigreeSearchModel!.data![i].id!;
    //                                       if(searchType == "dam"){
    //                                         controller.damNameController.text = controller.pedigreeSearchModel!.data![i].dogName!;
    //                                       }else{
    //                                         controller.sireNameController.text = controller.pedigreeSearchModel!.data![i].dogName!;
    //                                       }
    //                                     } else  {
    //                                       print("${ controller.pedigreeSearchModel!.data![i].dogName} false");
    //                                       controller.pedigreeSearchModel!.data![i]
    //                                           .isSelected!.value = false;
    //                                     }
    //                                     unknown.value = false;
    //                                   }
    //                                 },
    //                                 child: Container(
    //                                     decoration: BoxDecoration(
    //                                       color: Colors.grey[200],
    //                                       // selectedIndex.contains(index) ? Colors.green : Colors.white,
    //                                       borderRadius: BorderRadius.circular(2),
    //                                     ),
    //                                     padding: EdgeInsets.symmetric(
    //                                         vertical: 4, horizontal: 8),
    //                                     child: RichText(
    //                                       text: TextSpan(
    //                                           children: [
    //                                             WidgetSpan(
    //                                                 alignment:PlaceholderAlignment.middle ,
    //                                                 child: Obx(() {
    //                                               return Container(
    //                                                 width: 15, height: 15,
    //                                                 decoration: BoxDecoration(
    //                                                     shape: BoxShape.circle,
    //                                                     color: controller
    //                                                         .pedigreeSearchModel!
    //                                                         .data![index].isSelected!
    //                                                         .value == false ? Colors
    //                                                         .grey : DynamicColors
    //                                                         .primaryColorRed
    //                                                 ),
    //                                                 child: Center(
    //                                                   child: Icon(Icons.check,color: Colors.white,size: 12,),
    //                                                 ),
    //                                               );
    //                                             })),
    //                                             WidgetSpan(child: SizedBox(width: 10,)),
    //                                             TextSpan(
    //
    //                                               text: controller.pedigreeSearchModel!
    //                                                   .data![index].dogName!,
    //                                               style: montserratSemiBold(
    //                                                   color: Colors.black),
    //                                             ),
    //                                           ]
    //                                       ),
    //                                     )
    //                                 ),
    //                               ),
    //                             ),
    //                       )
    //                     ],
    //                   );
    //                 }),
    //                 SizedBox(height: kToolbarHeight,),
    //                 Align(
    //                   alignment: Alignment.bottomCenter,
    //                   child: Center(
    //                     child: CustomButton(
    //                       text: "Done",
    //                       isLong: false,
    //                       onTap: () {
    //                         onWillPop();
    //                         // if (formKey.currentState!.validate()) {
    //                         //   if(controller.pedigreeCover.isEmpty){
    //                         //     BotToast.showText(text: "Please add pedigree photos");
    //                         //   }else if(controller.genderText.isEmpty){
    //                         //     BotToast.showText(text: "Please select gender");
    //                         //   }else{
    //                         //     Get.to(() => NextPedigree());
    //                         //   }
    //                         // }
    //
    //                       },
    //                       padding:
    //                       EdgeInsets.symmetric(vertical: 7, horizontal: 40),
    //                       color: DynamicColors.primaryColorRed,
    //                       borderColor: DynamicColors.primaryColorRed,
    //                       borderRadius: BorderRadius.circular(5),
    //                       style: poppinsLight(
    //                           color: DynamicColors.primaryColorLight),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
