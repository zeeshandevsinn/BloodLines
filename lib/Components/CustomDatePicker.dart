import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatePick extends StatelessWidget {
  DatePick(
      {required this.dateChange,
      required this.setColor,
      this.intColor,
      this.hint = 'Date of Birth',
      this.from = "profile",
      this.initialDate});
  var dateChange;
  Color setColor;
  String hint;

  String from;
  Color? intColor;
  RxString? initialDate = "".obs;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: setColor, // header background color
            onPrimary: intColor ?? Colors.black, // header text color
            onSurface: DynamicColors.textColor, // body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              // primary: setColor, // button text color
            ),
          ),
        ),
        child: DateTimePicker(
            initialValue: initialDate!.value,
            style: TextStyle(color: Colors.black87),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select date";
              } else if (from == "event") {
                int difference =
                    DateTime.parse(value).difference(DateTime.now()).inDays;
                if (difference < 1) {
                  return "Day must be greater or equal to 1";
                } else {
                  return null;
                }
              } else {
                int thirteenYears = 4745;
                int difference =
                    DateTime.now().difference(DateTime.parse(value)).inDays;
                if (difference >= thirteenYears) {
                  return null;
                } else {
                  return "Age must be greater than 13";
                }
              }
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: DynamicColors.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: DynamicColors.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: DynamicColors.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                hintText: hint,
                hintStyle: poppinsRegular(
                    color: DynamicColors.borderGrey, fontSize: 15)),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            onChanged: dateChange));
  }
}

class TimePicker extends StatelessWidget {
  TimePicker(
      {required this.dateChange,
      required this.setColor,
      this.intColor,
      this.from = "profile",
      this.hint = '',
      this.initialDate});
  final ValueChanged<String> dateChange;
  Color setColor;
  String from;
  String hint;
  Color? intColor;
  RxString? initialDate = "".obs;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: setColor, // header background color
            onPrimary: intColor ?? Colors.black, // header text color
            onSurface: DynamicColors.textColor, // body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              // primary: setColor, // button text color
            ),
          ),
        ),
        child: DateTimePicker(
            type: DateTimePickerType.time,
            use24HourFormat: false,
            initialValue: initialDate!.value,
            style: TextStyle(color: Colors.black87),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select time";
              } else {
                int difference =
                    DateTime.parse(value).difference(DateTime.now()).inDays;
                if (difference < 1) {
                  return "Day must be greater or equal to 1";
                } else {
                  return null;
                }
              }
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: DynamicColors.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: DynamicColors.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: DynamicColors.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                hintText: hint,
                hintStyle: poppinsRegular(
                    color: DynamicColors.borderGrey, fontSize: 15)),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            onChanged: dateChange));
  }
}
