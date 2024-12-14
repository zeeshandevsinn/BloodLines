import 'package:bloodlines/Components/TextStyle.dart';
import 'package:flutter/material.dart';

import 'Color.dart';

class CButton extends StatelessWidget {
  CButton(
      {Key? key,
      this.onTap,
      this.customHeight = 50,
      this.customWidth,
      this.btnText,
      this.btnColor,
      this.radius = 5,
      this.showButton = false,
      this.btnTextStyle,
      this.borderColor,
      this.containLoading = true})
      : super(key: key);

  GestureTapCallback? onTap;
  double? customHeight;
  double? radius;
  double? customWidth;
  String? btnText;
  bool? containLoading;
  bool? showButton = false;
  Color? btnColor;
  TextStyle? btnTextStyle;
  Color? borderColor;
  @override
  Widget build(BuildContext context) {
    double widths = MediaQuery.of(context).size.width;
    return buttonAnimation(
        containLoading,
        Container(
          height: containLoading == true ? customHeight! + 5 : customHeight,
          width: customWidth ?? widths / 1.2,
          decoration: borderColor == null
              ? BoxDecoration(
                  color: btnColor,
                  image: showButton == false
                      ? DecorationImage(
                          image: AssetImage('assets/btnBg.png'),
                          fit: BoxFit.fill,
                        )
                      : null,
                  border: Border.all(
                    color: borderColor ?? DynamicColors.primaryColor,
                    width: 1.9,
                  ),
                  borderRadius: BorderRadius.circular(radius!),
                )
              : BoxDecoration(
                  color: btnColor,
                  image: showButton == false
                      ? DecorationImage(
                          image: AssetImage('assets/btnBg.png'),
                          fit: BoxFit.fill,
                        )
                      : null,
                  border: Border.all(
                    color: borderColor!,
                    width: 1.9,
                  ),
                  borderRadius: BorderRadius.circular(radius!),
                ),
          child: Center(
            child: Text(
              btnText ?? "",
              style: btnTextStyle ??
                  poppinsRegular(
                    color: DynamicColors.textColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        onTap);
  }

  Widget buttonAnimation(check, child, onclick) {
    return InkWell(onTap: onclick, child: child);
  }
}

class SmallButton extends StatelessWidget {
  SmallButton(
      {Key? key,
      this.onTap,
      this.btnText,
      this.btnColor,
      this.btnshow = false,
      this.btnTextStyle,
      this.borderColor,
      this.icon,
      this.iconColor,
      this.customWidth = 2.7,
      this.imageString})
      : super(key: key);

  GestureTapCallback? onTap;

  String? btnText;
  bool? btnshow = false;
  Color? btnColor;
  TextStyle? btnTextStyle;
  IconData? icon;
  Color? borderColor;
  String? imageString;
  Color? iconColor;
  var customWidth;
  @override
  Widget build(BuildContext context) {
    double widths = MediaQuery.of(context).size.width;
    double heights = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: heights / 23,
        width: widths / customWidth,
        decoration: BoxDecoration(
          color: btnColor ?? Colors.white,
          image: btnshow == false
              ? DecorationImage(
                  image: AssetImage('assets/btnBg.png'),
                  fit: BoxFit.fill,
                )
              : null,
          border: Border.all(
            color: borderColor ?? DynamicColors.hintBorderColor,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: icon != null
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 3, right: 3),
              child: imageString != null
                  ? Image(
                      image: AssetImage(imageString!),
                      height: 25,
                      color: DynamicColors.whiteColor,
                    )
                  : icon != null
                      ? Icon(
                          icon,
                          size: heights / 35,
                          color: iconColor,
                        )
                      : Container(),
            ),
            Center(
              child: Text(
                btnText ?? "",
                style: btnTextStyle ??
                    poppinsRegular(
                      fontSize: heights / 40,
                      color: DynamicColors.textColor,
                      fontWeight: FontWeight.w300,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  CustomButton({
    Key? key,
    this.onTap,
    this.decoration,
    this.borderRadius,
    this.border,
    this.color,
    this.isLong = true,
    this.borderColor,
    this.text = "",
    this.style,
    this.child,
    this.elevation = 0,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);
  final VoidCallback? onTap;
  final BoxDecoration? decoration;
  final BorderRadius? borderRadius;
  final Border? border;
  final Color? color;
  final Color? borderColor;
  final String? text;
  final bool isLong;
  final TextStyle? style;
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,

        child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            child: Card(surfaceTintColor: DynamicColors.primaryColorLight,color:DynamicColors.primaryColorLight,
              elevation: elevation,
              child: Container(
                padding: padding,
                margin: margin,
                decoration: decoration ??
                    BoxDecoration(
                        borderRadius: borderRadius ?? BorderRadius.circular(10),
                        color: color ?? DynamicColors.primaryColor,
                        border: border ??
                            Border.all(
                                color: borderColor ?? DynamicColors.textColor)),
                child: isLong == true
                    ? child ??
                        Center(
                            child: Text(
                          text!,
                          style: style ?? montserratRegular(),
                        ))
                    : child ??
                        Text(
                          text!,
                          style: style ?? montserratRegular(),
                        ),
              ),
            )));
  }
}
