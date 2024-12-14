import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Shop/Data/shopController.dart';
import 'package:bloodlines/View/Shop/Model/shopModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class AttributeOptionTemp{
  int id;
  int index;
  AttributeOptionTemp({required this.id,required this.index});
}

class ShopDetail extends StatelessWidget {
  ShopDetail({Key? key}) : super(key: key);
  int id = Get.arguments["id"];
  ShopController controller = Get.find();
  final RxInt _current = 0.obs;
  final RxInt quantity = 1.obs;
  final List<AttributeOptionTemp> attributesList = [];

  Future<bool> onWillPop() async {
    controller.productShopModel = null;
    Get.back();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: DynamicColors.primaryColorLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: AppBarWidgets(
            onTap: () {
              controller.productShopModel = null;
              onWillPop();
            },
          ),
          title: Text(
            "Shop",
            style: poppinsSemiBold(
                color: DynamicColors.primaryColor, fontSize: 24),
          ),
          elevation: 0,
        ),
        body: GetBuilder<ShopController>(initState: (s) {
          controller.getProductsShops(id);
        }, builder: (controller) {
          if (controller.productShopModel == null) {
            return Center(
              child: LoaderClass(),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: Utils.height(context) / 2.5,
                    child: Stack(
                      children: [
                        CarouselSlider.builder(
                            itemCount: controller.productShopModel!.data!
                                .gallery!.length,
                            itemBuilder: (BuildContext context, int index,
                                int pageViewIndex) =>
                                InkWell(
                                  highlightColor:
                                  DynamicColors.primaryColor.withOpacity(0.1),
                                  onTap: () {
                                    Get.toNamed(Routes.photo, arguments: {
                                      "image": controller.productShopModel!
                                          .data!.gallery![index].media!
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        image: DecorationImage(
                                            image: OptimizedCacheImageProvider(
                                              controller.productShopModel!.data!
                                                  .gallery![index].media!,
                                            ),
                                            // alignment: Alignment.topCenter,
                                            fit: BoxFit.fitHeight)),
                                  ),
                                ),
                            options: CarouselOptions(
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              reverse: false,
                              autoPlay: false,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: false,
                              aspectRatio: 16 / 9,
                              viewportFraction: 1,
                              onPageChanged: (value, reason) {
                                _current.value = value;
                              },
                              scrollDirection: Axis.horizontal,
                            )),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Obx(() {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: controller
                                    .productShopModel!.data!.gallery!
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return Container(
                                    width: 6.0,
                                    height: 6.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (Theme
                                            .of(context)
                                            .brightness ==
                                            Brightness.dark
                                            ? Colors.white
                                            : DynamicColors.primaryColorRed)
                                            .withOpacity(
                                            _current.value == entry.key
                                                ? 0.9
                                                : 0.4)),
                                  );
                                }).toList(),
                              );
                            })),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    controller.productShopModel!.data!.name!,
                    style: montserratSemiBold(fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    controller.productShopModel!.data!.price.toString(),
                    style: montserratExtraBold(
                        fontSize: 24, color: DynamicColors.primaryColorRed),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Description",
                    style: montserratBold(
                        fontSize: 18, color: DynamicColors.primaryColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    controller.productShopModel!.data!.description!,
                    style: montserratLight(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.productShopModel!.data!.attributes!
                          .length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.productShopModel!.data!
                                  .attributes![index].name!,
                              style: montserratBold(
                                  fontSize: 18,
                                  color: DynamicColors.primaryColor),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 40,
                              child: ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                  itemCount: controller.productShopModel!.data!
                                      .attributes![index].attributeOptions!
                                      .length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, aIndex) {
                                    Attribute attribute = controller
                                        .productShopModel!.data!
                                        .attributes![index]
                                        .attributeOptions![aIndex];
                                    return GestureDetector(
                                      onTap: () {
                                        for (int i = 0; i <
                                            controller.productShopModel!.data!
                                                .attributes![index]
                                                .attributeOptions!
                                                .length; i++) {
                                          if (attribute.id ==
                                              controller.productShopModel!.data!
                                                  .attributes![index]
                                                  .attributeOptions![i].id ) {
                                           if(attributesList.isEmpty ||attributesList.any((element)  {
                                             if( element.id != attribute.id && element.index == index){
                                               return true;
                                             }
                                             else if( element.id != attribute.id && element.index != index){
                                               return true;
                                             }
                                             return false;
                                           })){
                                             if(attributesList.any((element) => element.id == attribute.id)){
                                               attributesList.removeWhere((element) => element.id == controller.productShopModel!.data!
                                                   .attributes![index]
                                                   .attributeOptions![i].id && element.index == index);
                                              }else{
                                               attributesList.add(
                                                   AttributeOptionTemp(
                                                       id: controller
                                                           .productShopModel!
                                                           .data!
                                                           .attributes![index]
                                                           .attributeOptions![
                                                       i]
                                                           .id!,
                                                       index: index));
                                             }
                                            }else{
                                             attributesList.removeWhere((element) => element.id == controller.productShopModel!.data!
                                                 .attributes![index]
                                                 .attributeOptions![i].id && element.index == index);

                                           }
                                          } else {
                                            attributesList.removeWhere((element) => element.id == controller.productShopModel!.data!
                                                .attributes![index]
                                                .attributeOptions![i].id && element.index == index);
                                          }
                                        }
                                        controller.update();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: attributesList
                                                  .any((element) =>
                                              element.id == attribute.id && element.index == index)
                                                  ? DynamicColors
                                                  .primaryColorRed
                                                  : Colors.white,
                                              borderRadius: BorderRadius
                                                  .circular(5),
                                              border: Border.all(
                                                  color: DynamicColors
                                                      .primaryColorRed)),
                                          child: Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 30, vertical: 10),
                                            child: Text(
                                              attribute.name!,
                                              style: montserratSemiBold(
                                                  color: attributesList
                                                      .isEmpty
                                                      ? DynamicColors
                                                      .primaryColorRed
                                                      : attributesList
                                                      .every((element) {
                                                    if(element.index == index){
                                                      if(element.id != attribute.id){
                                                        return true;
                                                      }
                                                      return false;

                                                    }else{
                                                      if(element.id != attribute.id){
                                                        return true;
                                                      }
                                                      return false;
                                                    }
                                                  })
                                                      ? DynamicColors
                                                      .primaryColorRed
                                                      : Colors.white,
                                                  fontSize: 14),
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
                          ],
                        );
                      }),
                  Row(
                    children: [
                      Text(
                        "Quantity",
                        style: montserratBold(
                            fontSize: 18, color: DynamicColors.primaryColor),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (quantity.value > 0) {
                            quantity.value = quantity.value - 1;
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: DynamicColors.primaryColor)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(Entypo.minus,
                                color: DynamicColors.primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Obx(() {
                        return Text(
                          quantity.value.toString(),
                          style: montserratBold(),
                        );
                      }),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (quantity.value <
                              controller.productShopModel!.data!.stocks![0].qty!
                                  .value) {
                            quantity.value = quantity.value + 1;
                          }else{
                            BotToast.showText(text: "You cannot add more than stock");
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: DynamicColors.primaryColorRed)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(Icons.add,
                                color: DynamicColors.primaryColorRed),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: "ADD TO CART",
                      onTap: () {
                        if(quantity
                          .value == 0){
                        BotToast.showText(text: "Please select quantity");
                      }else if(attributesList.isEmpty){
                        BotToast.showText(text: "Please select any attribute");
                      }else if(attributesList.length != controller.productShopModel!.data!.attributes!.length){
                        BotToast.showText(text: "Please select any attribute from all variants");
                      }else{
                        controller.addToCart(
                            controller.productShopModel!.data!.id!,
                            quantity
                                .value,
                            attributesList.map((
                                e) => e.id).toList());
                      }

                      },
                      padding: EdgeInsets.symmetric(vertical: 13),
                      style: montserratBold(
                          fontSize: 16, color: DynamicColors.primaryColorRed),
                      color: DynamicColors.primaryColorRed.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5),
                      borderColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
