import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Snack {
  Duration duration = Duration(seconds: 5);
  void customSnack(
      {required String title,
      required String body,
      required bool function,
      void func(v)?,
      Duration? time,
      Function? ontap(v)?,
      coloring}) {
    Get.snackbar(title, body,
        duration: time ?? duration,
        backgroundColor: coloring ?? DynamicColors.primaryColor,
        colorText: DynamicColors.whiteColor,
        snackbarStatus: function ? func : (v) {}, onTap: (v) {
      ontap!(v);
    });
  }

  bottomBar({context, onClickOne, onClickTwo, color}) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
                color: color ?? Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.photo_library,
                    color: DynamicColors.whiteColor,
                  ),
                  title: Text(
                    'Camera',
                    style: poppinsRegular(fontSize: 20),
                  ),
                  onTap: onClickOne,
                ),
                ListTile(
                    leading: Icon(
                      Icons.photo_camera,
                      color: DynamicColors.whiteColor,
                    ),
                    title: Text(
                      'Photo Library',
                      style: poppinsRegular(fontSize: 20),
                    ),
                    onTap: onClickTwo),
              ],
            ),
          );
        });
  }
}
