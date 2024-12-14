import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageBottomSheet {
  static bottomSheet(context,
      {GestureTapCallback? onCameraTap, GestureTapCallback? onGalleryTap,String camera = "Camera",String gallery = "Gallery"}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext abc) {
          return Container(
            decoration: BoxDecoration(color: DynamicColors.primaryColor),
            child: Wrap(
              children: [
                ListTile(
                  onTap: onCameraTap!,
                  leading: Icon(
                    Icons.camera_alt,
                    color: DynamicColors.primaryColorLight,
                  ),
                  title: Text(
                    camera,
                    style: poppinsRegular(
                        fontSize: 15.0, color: DynamicColors.primaryColorLight),
                  ),
                ),
                ListTile(
                  onTap: onGalleryTap!,
                  leading: Icon(
                    Icons.image,
                    color: DynamicColors.primaryColorLight,
                  ),
                  title: Text(

                  gallery,
                    style: poppinsRegular(
                        fontSize: 15.0, color: DynamicColors.primaryColorLight),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.back();
                  },
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: DynamicColors.primaryColor),
                    ),
                    child: Icon(
                      Icons.close,
                      color: DynamicColors.primaryColorLight,
                    ),
                  ),
                  title: Text(
                    'Cancel',
                    style: poppinsRegular(
                        fontSize: 15.0, color: DynamicColors.primaryColorLight),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
