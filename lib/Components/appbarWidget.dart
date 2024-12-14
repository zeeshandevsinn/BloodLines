import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/model/searchedUserList.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class AppBarWidgets extends StatelessWidget {
  const AppBarWidgets({
    Key? key,
    this.size = 21,
    this.onTap,
    this.color,
    this.icon = Icons.arrow_back_ios_sharp,
    this.assetImage,
    this.decorationColor,
    this.noDecoration = false,
    this.margin = 4,
    this.width = 50,
    this.height = 50,
    this.leftPadding = 10,
    this.isCardType = true,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final GestureTapCallback? onTap;
  final Color? color;
  final Color? decorationColor;
  final IconData? icon;
  final String? assetImage;
  final double size;
  final EdgeInsets padding;
  final double margin;
  final double width;
  final double height;
  final double leftPadding;
  final bool noDecoration;
  final bool isCardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: EdgeInsets.only(left: leftPadding),
        child: InkWell(

          onTap: onTap ??
              () {
                Get.back();
              },
          child: isCardType == true
              ? Card(surfaceTintColor: decorationColor??DynamicColors.primaryColorLight,color:decorationColor??DynamicColors.primaryColorLight,
                  margin: EdgeInsets.all(margin),
                  shape: CircleBorder(),
                  child: Container(
                    margin: EdgeInsets.all(margin),
                    decoration: noDecoration == true
                        ? null
                        : BoxDecoration(
                            shape: BoxShape.circle,
                            // color: decorationColor ?? Colors.grey[200]!,
                          ),
                    child: assetImage != null
                        ? Padding(
                            padding: padding,
                            child: ImageIcon(
                              AssetImage(assetImage!),
                              color: color ?? DynamicColors.textColor,
                              size: size,
                            ),
                          )
                        : Padding(
                            padding: padding,
                            child: Icon(
                              icon,
                              color: color ?? DynamicColors.primaryColorRed,
                              size: size,
                            ),
                          ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(margin),
                  decoration: noDecoration == true
                      ? null
                      : BoxDecoration(
                          shape: BoxShape.circle,
                          color: decorationColor ?? Colors.grey[200]!,
                        ),
                  child: assetImage != null
                      ? Padding(
                          padding: padding,
                          child: ImageIcon(
                            AssetImage(assetImage!),
                            color: color ?? DynamicColors.textColor,
                            size: size,
                          ),
                        )
                      : Padding(
                          padding: padding,
                          child: Icon(
                            icon,
                            color: color ?? DynamicColors.primaryColorRed,
                            size: size,
                          ),
                        ),
                ),
        ),
      ),
    );
  }
}
class AppBarProfileWidget extends StatelessWidget {
  AppBarProfileWidget({
    super.key,
  });

  final FeedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppBarWidgets(
          leftPadding: 0,
          onTap: () {
            controller.searchedUsersList = Rxn<SearchClassUsersList>();
            Get.toNamed(Routes.searchClass);
          },
          color: DynamicColors.primaryColor,
          icon: Octicons.search,
          size: 20,
          margin: 2,
          // padding: EdgeInsets.all(8),
        ),
        SizedBox(
          width: 10,
        ),
        AppBarWidgets(
          leftPadding: 0,
          onTap: () {
            Get.toNamed(Routes.notificationClass);
          },
          color: DynamicColors.primaryColor,
          assetImage: "assets/icons/notification.png",
          size: 15,
          margin: 2,
          padding: EdgeInsets.all(8),
          // padding: EdgeInsets.all(8),
        ),
        SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {
            Get.toNamed(Routes.timeline);
          },
          child: GetBuilder<FeedController>(builder: (controller) {
            return SizedBox(
              height: 40,
              width: 40,
              child: Obx(() {
                if(controller.myProfile.value == null){
                  return Container();
                }
                return Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: OptimizedCacheImageProvider(
                            controller.myProfile.value!.profile!
                                .profileImage!,
                          ),
                          fit: BoxFit.cover)),
                );
              }),
            );
          }),
        ),
      ],
    );
  }
}
