import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Shop/Model/shopModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class ShopGrid extends StatelessWidget {
  ShopGrid({Key? key}) : super(key: key);

  List<Product> productList = Get.arguments["list"];
  String name = Get.arguments["name"];

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
          "Shop",
          style:
              poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: CustomButton(
                text: name,
                isLong: false,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                style: montserratSemiBold(
                  color: Color(0xff679537),
                ),
                borderColor: Colors.transparent,
                color: Color(0xffE1FFB1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GridView.builder(
              itemCount: productList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ShopItem(product: productList[index], index: index);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.75),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class ShopItem extends StatelessWidget {
  const ShopItem({
    Key? key,
    required this.product,
    required this.index,
  }) : super(key: key);

  final Product product;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.shopDetail, arguments: {"id": product.id});
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 15),
        child: Container(
          // height: Utils.height(context) / 3,
          width: Utils.width(context) / 2.4,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                OptimizedCacheImage(
                  imageUrl: product.image!,
                  height: Utils.height(context) / 4,
                ),
                // SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        product.name!,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: montserratSemiBold(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${product.price}",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: poppinsBold(
                            fontSize: 14,
                            color: DynamicColors.primaryColorRed),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
