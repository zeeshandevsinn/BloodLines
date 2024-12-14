// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Credentials/controller/credentialController.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  TextEditingController? controller = TextEditingController();
  bool? isEmail = false;
  bool? obscureText = false;
  bool? isTransparentBorder = false;
  VoidCallback? onTap;
  bool? isPhone = false;
  bool? isBorder = true;
  bool? isUnderLineBorder = true;
  bool? isConfirmPassword = false;
  bool? readOnly = false;
  bool? isFromSignup = false;
  bool? isFromSetting = false;
  String? validationError;
  int? maxLines = 1;
  int? minLines;
  int? maxLength;
  String? hint;
  String? label;
  double? radius;
  Color? color;
  EdgeInsets mainPadding;
  Color? cursorColor;
  Color underLineBorderColor;
  Color fillColor;
  bool filled;
  bool fromSignUp;
  bool expands;
  bool fromPedigree;
  bool nameOnly;
  bool allowDashes;
  ValueChanged<String>? onChanged;
  ValueChanged<String>? onFieldSubmitted;
  List<TextInputFormatter> formatter;
  Widget? suffixIcon;
  Widget? prefixIcon;
  TextCapitalization? textCapitalization;
  final EdgeInsets? padding;
  final TextInputType? textInputType;
  final TextAlignVertical textAlignVertical;
  final EdgeInsets? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextStyle? labelStyle;

  CustomTextField(
      {Key? key,
      this.hintStyle,
      this.label,
        this.textCapitalization = TextCapitalization.sentences,
      this.textAlignVertical = TextAlignVertical.top,
      this.textInputType = TextInputType.text,
      this.filled = false,
      this.expands = false,
      this.fillColor = Colors.transparent,
      this.textAlign = TextAlign.start,
      this.controller,
      this.underLineBorderColor = const Color(0xffD50814),
      this.isEmail = false,
      this.isUnderLineBorder = true,
      this.fromSignUp = false,
      this.obscureText = false,
      this.isFromSignup = false,
      this.validationError = "",
      this.padding,
      this.onChanged,
      this.suffixIcon,
      this.onFieldSubmitted,
      this.onTap,
      this.prefixIcon,
      this.style,
      this.formatter = const [],
      this.cursorColor,
      this.contentPadding,
      this.readOnly = false,
      this.nameOnly = false,
      this.allowDashes = false,
      this.isFromSetting = false,
      this.fromPedigree = false,
      this.isTransparentBorder = false,
      this.hint,
      this.mainPadding =
          const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      this.color,
      this.radius = 10,
      this.minLines,
      this.maxLength,
      this.labelStyle,
      this.maxLines = 1,
      this.isPhone = false,
      this.isBorder = true,
      this.isConfirmPassword = false})
      : super(key: key);

  // final CreateJobController jobController = Get.put(CreateJobController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: mainPadding,
      child: TextFormField(
        textAlignVertical: textAlignVertical,
        onTap: onTap,
        expands: expands,
        textAlign: textAlign,
        inputFormatters:formatter,
        cursorColor: cursorColor ?? DynamicColors.textColor,
        readOnly: readOnly!,
        enabled: true,
        minLines: minLines,
        onFieldSubmitted: onFieldSubmitted, //
        onChanged: onChanged,


        controller: controller,
        textCapitalization: textCapitalization!,

        style: style ??
            poppinsRegular(
              fontSize: 15,
              color: DynamicColors.textColor,
              fontWeight: FontWeight.w300,
            ),
        obscureText: obscureText!,
        keyboardType: isPhone == true
            ? TextInputType.phone
            : isEmail == true
                ? TextInputType.emailAddress
                : textInputType ?? TextInputType.text,
        validator: (value) {
          if(nameOnly == true){
            if(allowDashes == false){
              return fullNameValidate(value!);
            }
            return fullNameValidateDog(value!);
          }else{
            if (fromPedigree == false) {
              if (value!.isEmpty) {
                return 'Please enter ${validationError!.toLowerCase()}';
              } else {
                if (isEmail == true) {
                  return validateEmail(value);
                } else if (validationError == "Password" &&
                    fromSignUp == true) {
                  CredentialController controller = Get.find();
                  if (controller.signUpPasswordController.text.length < 8) {
                    return "Password must be at least 8 characters";
                  }
                } else if (validationError == "Confirm Password") {
                  CredentialController controller = Get.find();
                  if (controller.signUpPasswordController.text ==
                      controller.signUpConfirmPasswordController.text) {
                    if (controller.signUpPasswordController.text.length < 8) {
                      return "Password must be at least 8 characters";
                    }
                    // return validatePassword(value);
                    return null;
                  } else {
                    return "Password doesn't match";
                  }
                } else if (validationError == "Your Birthday") {
                  int thirteenYears = 6570;
                  int difference =
                      DateTime.now().difference(DateTime.parse(value)).inDays;
                  if (difference >= thirteenYears) {
                    return null;
                  } else {
                    return "Age must be greater than 18";
                  }
                } else if (validationError == "First Name" ||
                    validationError == "Last Name" ||
                    validationError == "card name") {
                  return fullNameValidate(value);
                } else if (validationError == "expiration month") {
                  if (int.parse(value) > 12 || int.parse(value) < 1) {
                    return "Invalid Month";
                  } else {
                    return null;
                  }
                } else if (validationError == "expiration year") {
                  if (int.parse(value) - DateTime.now().year > 5) {
                    return "Expiry is too greater";
                  } else if (int.parse(value) < DateTime.now().year) {
                    return "Year must be greater";
                  } else {
                    return null;
                  }
                } else {
                  return null;
                }
                return null;
              }
            }
            return null;
          }
        },

        decoration: InputDecoration(
          fillColor: fillColor,
          filled: filled,
          contentPadding: padding ??
              EdgeInsets.only(left: 15, top: suffixIcon == null ? 0 : 15),
          border: isBorder == true
              ? isUnderLineBorder == false
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius ?? 1),
                      borderSide: BorderSide(
                          color: isTransparentBorder == false
                              ? underLineBorderColor
                              : Colors.transparent),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: isTransparentBorder == false
                              ? underLineBorderColor
                              : Colors.transparent),
                    )
              : InputBorder.none,
          enabledBorder: isBorder == true
              ? isUnderLineBorder == false
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius ?? 1),
                      borderSide: BorderSide(
                          color: isTransparentBorder == false
                              ?underLineBorderColor
                              : Colors.transparent),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: isTransparentBorder == false
                              ? underLineBorderColor
                              : Colors.transparent),
                    )
              : InputBorder.none,
          focusedBorder: isBorder == true
              ? isUnderLineBorder == false
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius ?? 1),
                      borderSide: BorderSide(
                          color: isTransparentBorder == false
                              ? underLineBorderColor
                              : Colors.transparent),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: isTransparentBorder == false
                              ? underLineBorderColor
                              : Colors.transparent))
              : InputBorder.none,
          hintText: hint ?? "",
          label: label == null
              ? null
              : Text(
                  label!,
                  style: labelStyle ??
                      poppinsRegular(
                        fontSize: 14,
                      ),
                ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintStyle: hintStyle ??
              poppinsRegular(
                fontSize: 14,
                color: DynamicColors.accentColor.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
        ),
        maxLength: maxLength,
        maxLines: maxLines,
      ),
    );
  }

  validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "Password doesn't match to requirements";
    } else {
      return null;
    }
  }

  validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Enter a valid email address";
    } else {
      return null;
    }
  }

  nameWithNum(String fullName) {
    String pattern = r'(?!^\d+$)([!@#$%_\^\&amp;\*\-\.\?]{5,49})*[a-zA-Z]+$';
    RegExp regExp = RegExp(pattern);
    RegExp regExps = RegExp(r'^[0-9. !@#$%^&*()-_=+]+$', caseSensitive: true);
    // RegExp special = RegExp(r'^[!@#$%^&*()-_=+]+$');
    if (fullName.isEmpty) {
      return 'Please enter $validationError';
    } else {
      if (!regExp.hasMatch(fullName)) {
        return '$validationError is invalid';
      } else if (regExp.hasMatch(fullName)) {
        return null;
      } else if (regExps.hasMatch(fullName)) {
        return '$validationError is invalid';
      } else if (fullName.length <= 2) {
        return '$validationError is too short';
      }
      return null;
    }
  }

  fullNameValidate(String fullName) {
    String pattern = r'^[a-z A-Z]+$';
    RegExp regExp = RegExp(pattern);
    if (fullName.isEmpty) {
      return 'Please enter $validationError';
    } else if (!regExp.hasMatch(fullName)) {
      return '$validationError is invalid';
    } else if (fullName.length <= 2) {
      return '$validationError is too short';
    }
    return null;
  }
  fullNameValidateDog(String fullName) {
    String pattern = r'^[a-z A-Z&\$()_-]+$';
    RegExp regExp = RegExp(pattern);
    if (fullName.isEmpty) {
      return 'Please enter $validationError';
    } else if (!regExp.hasMatch(fullName)) {
      return '$validationError is invalid';
    } else if (fullName.length <= 2) {
      return '$validationError is too short';
    }
    return null;
  }
}
