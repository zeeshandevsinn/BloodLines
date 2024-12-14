import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/View/newsFeed/view/post/newPost.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class LoaderClass extends StatelessWidget {
  LoaderClass({this.colorOne, this.colorTwo});
  final Color? colorOne;
  final Color? colorTwo;

  @override
  Widget build(BuildContext context) {
    return SpinKitFoldingCube(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven
                ? colorOne ?? DynamicColors.primaryColor
                : colorTwo ?? DynamicColors.primaryColor.withOpacity(0.5),
          ),
        );
      },
    );
  }
}

showLoading() {
  return BotToast.showCustomLoading(
      toastBuilder: (_) => Center(
              child: LoaderClass(
            colorOne: DynamicColors.primaryColor,
            colorTwo: DynamicColors.primaryColor.withOpacity(0.5),
          )),
      animationDuration: Duration(milliseconds: 300));
}


showCompressLoading(){
  return BotToast.showCustomLoading(
      toastBuilder: (_) =>
          Center(
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                  color: DynamicColors.primaryColor,
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        return Text("${chatProgress.toInt()} %", style: poppinsRegular(
                            color: DynamicColors.primaryColorLight,
                            fontSize: 11),);
                      }),
                      SizedBox(height: 5,),
                      Text("Compressing ..", style: poppinsRegular(
                          color: DynamicColors.primaryColorLight,
                          fontSize: 11),)
                    ],
                  ),
                ),
              ),
            ),


          ),
      animationDuration: Duration(milliseconds: 300));
}