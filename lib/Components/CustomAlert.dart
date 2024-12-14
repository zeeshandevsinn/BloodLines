import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void alertMethod({context, childrenData, click, buttonText, titleText, theme}) {
  Alert(
      context: context,
      title: titleText,
      content: Column(
        children: childrenData,
      ),
      style: AlertStyle(
        titleStyle: poppinsRegular(
            fontSize: 25, color: theme, fontWeight: FontWeight.w200),
        backgroundColor: DynamicColors.whiteColor,
        animationDuration: Duration(milliseconds: 400),
        animationType: AnimationType.fromTop,
      ),
      buttons: [
        DialogButton(
          color: theme,
          onPressed: click,
          child: Text(
            buttonText,
            style: TextStyle(color: DynamicColors.whiteColor, fontSize: 20),
          ),
        )
      ]).show();
}

void alertCustomMethod(context,
    {childrenData,
    click,
    click2,
    closeClick,
    buttonText,
    buttonText2,
    String? titleText,
      TextStyle? titleStyle,
    theme}) {
  Alert(
      context: context,
      title: titleText,
      onWillPopActive: false,
      closeIcon: GestureDetector(
          onTap: closeClick??(){
            Get.back();
          },
          child: Icon(
            Icons.clear,
            color: Colors.black87,
          )),
      content: childrenData == null
          ? Container()
          : Column(
              children: childrenData,
            ),
      style: AlertStyle(
        titleStyle: titleStyle??poppinsRegular(
            fontSize: 25, color: theme, fontWeight: FontWeight.w200),
        backgroundColor: DynamicColors.whiteColor,
        animationDuration: Duration(milliseconds: 400),
        animationType: AnimationType.fromTop,
      ),
      buttons:buttonText2 == null ?[
        DialogButton(
          color: theme,
          onPressed: click,
          child: Text(
            buttonText,
            style: TextStyle(color: DynamicColors.whiteColor, fontSize: 20),
          ),
        ),
      ]: [
        DialogButton(
          color: theme,
          onPressed: click,
          child: Text(
            buttonText,
            style: TextStyle(color: DynamicColors.whiteColor, fontSize: 20),
          ),
        ),
          DialogButton(
          color: theme,
          onPressed: click2,
          child: Text(
            buttonText2,
            style: TextStyle(color: DynamicColors.whiteColor, fontSize: 20),
          ),
        )
      ]).show();
}

progressAlert(
  context,
  end,
) {
  return Alert(
    context: context,
    title: 'titleText',
    content: TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: end.toDouble()),
      duration: const Duration(seconds: 20),
      builder: (BuildContext context, double size, Widget? child) {
        return ProgressScreen(end);
      },
    ),
    style: AlertStyle(
      titleStyle: poppinsRegular(
          fontSize: 25,
          color: DynamicColors.textColor,
          fontWeight: FontWeight.w200),
      backgroundColor: DynamicColors.whiteColor,
      animationDuration: Duration(milliseconds: 400),
      animationType: AnimationType.fromTop,
    ),
  ).show();
}

class ProgressScreen extends StatefulWidget {
  ProgressScreen(this.end);
  var end;
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
    );
    animation =
        Tween<double>(begin: 0, end: widget.end.toDouble()).animate(controller!)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller!.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller!.forward();
            }
          });

    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: animation!.value,
      width: animation!.value,
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
