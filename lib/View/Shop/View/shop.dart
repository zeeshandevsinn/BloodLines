import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Shop/Data/shopController.dart';
import 'package:bloodlines/View/Shop/View/shopGrid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Shop extends StatelessWidget {
  Shop({Key? key}) : super(key: key);
  ShopController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopController>(builder: (controller) {
      if (controller.shopListModel == null) {
        return Center(
          child: LoaderClass(),
        );
      }
      return ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: controller.shopListModel!.data!.length > 3
              ? 3
              : controller.shopListModel!.data!.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                titleWidget(
                  title: controller.shopListModel!.data![index].name!,
                  onTap: () {
                    Get.toNamed(Routes.shopGrid, arguments: {
                      "list": controller.shopListModel!.data![index].products!,
                      "name": controller.shopListModel!.data![index].name!
                    });
                  },
                ),
                SizedBox(
                  height: Utils.height(context) / 2.7,
                  child: ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: controller
                          .shopListModel!.data![index].products!.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, pIndex) {
                        return ShopItem(
                            product: controller
                                .shopListModel!.data![index].products![pIndex],
                            index: index);
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            );
          });
    });
  }

  Padding titleWidget(
      {required String title, required GestureTapCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text(
            title,
            style: montserratSemiBold(fontSize: 24),
          ),
          Spacer(),
          controller.shopListModel!.data!.length <= 3
              ? Container()
              : InkWell(
                  onTap: onTap,
                  child: Text(
                    "See all",
                    style: montserratSemiBold(fontSize: 14),
                  ),
                ),
        ],
      ),
    );
  }
}
