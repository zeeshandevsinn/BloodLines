import 'dart:io';

import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:photo_view/photo_view.dart';

class Photo extends StatelessWidget {
  String image = Get.arguments["image"];
  String type = Get.arguments["type"]??"network";

  Photo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColors.primaryColorLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: AppBarWidgets(),
        centerTitle: true,
        title: Text(
          "Photo",
          style:
              poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 28),
        ),
        elevation: 0,
      ),
      body: PhotoView(
        backgroundDecoration: BoxDecoration(
          color: DynamicColors.primaryColorLight,
        ),
        initialScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.contained * 2,
        minScale: PhotoViewComputedScale.contained,
        imageProvider: type == "network"? OptimizedCacheImageProvider(image):FileImage(File(image)) as ImageProvider,
      ),
    );
  }
}
