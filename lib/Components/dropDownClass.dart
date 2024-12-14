// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/View/Classified/Model/categoryModel.dart';
import 'package:bloodlines/View/Groups/Model/groupModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';

// ignore: must_be_immutable
class DropDownClass extends StatelessWidget {
  final String? _hint;
  List? finalList = [];
  final String? _validationError;
  final String? _initialValue;
  final Widget? _suffixWidget;
  final EdgeInsets? _contentPadding;
  final TextStyle? _style;
  final TextStyle? _hintStyle;
  final InputBorder? _border;
  final InputBorder? _focusedBorder;
  final InputBorder? _enabledBorder;
  final bool? _fromPedigree;

  List? get list => finalList;
  final dynamic Function(dynamic)? _listener;

  DropDownClass({
    Key? key,
    List? list,
    TextStyle? style,
    TextStyle? hintStyle,
    required String? hint,
    IconData? suffixIcon,
    Widget? icon,
    bool? fromPedigree,
    Widget? suffixWidget,
    InputBorder? border,
    InputBorder? focusedBorder,
    InputBorder? enabledBorder,
    EdgeInsets? contentPadding,
    Color? dropDownColor,
    Color? hintColor,
    Color? textColor,
    String? initialValue,
    required String? validationError,
    Color? backgroundColor,
    dynamic Function(dynamic)? listener,
  })  : finalList = list,
        _hint = hint,
        _style = style,
        _hintStyle = hintStyle,
        _border = border,
        _fromPedigree = fromPedigree,
        _initialValue = initialValue,
        _focusedBorder = focusedBorder,
        _enabledBorder = enabledBorder,
        _suffixWidget = suffixWidget,
        _validationError = validationError,
        _contentPadding = contentPadding,
        _listener = listener,
        super(key: key);

  final GlobalKey _dropdownButtonKey = GlobalKey();

  void openDropdown() {
    GestureDetector? detector;
    void searchForGestureDetector(BuildContext element) {
      element.visitChildElements((element) {
        if (element.widget is GestureDetector) {
          detector = element.widget as GestureDetector;
          return;
        } else {
          if (detector == null) {
            searchForGestureDetector(element);
          }
        }

        return;
      });
    }

    if (detector == null) {
      searchForGestureDetector(_dropdownButtonKey.currentContext!);
    }
    assert(detector != null);

    detector!.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<String>(
        value: _initialValue,
        key: _dropdownButtonKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        dropdownColor: DynamicColors.primaryColorLight,
        validator: (value) {
          if (_fromPedigree == false) {
            if (value == null || value.isEmpty) {
              return "Please select ${_validationError!.toLowerCase()}";
            }
            return null;
          }
          return null;
        },
        decoration: InputDecoration(
          suffixIcon: _suffixWidget == null
              ? null
              : GestureDetector(
                  onTap: () {
                    openDropdown();
                  },
                  child: _suffixWidget),
          contentPadding:
              _contentPadding ?? EdgeInsets.only(left: 20, right: 5),
          border: _border ??
              UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: DynamicColors.primaryColorRed, width: 2)),
          focusedBorder: _focusedBorder ??
              UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: DynamicColors.primaryColorRed, width: 2)),
          enabledBorder: _enabledBorder ??
              UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: DynamicColors.primaryColorRed, width: 1)),
        ),
        style: poppinsRegular(
          color: DynamicColors.textColor,
          fontWeight: FontWeight.w300,
        ),
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        isExpanded: true,
        hint: Text(_hint!,
            style: _hintStyle ??
                poppinsRegular(
                  fontSize: 12,
                  color: DynamicColors.accentColor.withOpacity(0.5),
                  fontWeight: FontWeight.w300,
                )),
        items: list!.map((item) {
          return DropdownMenuItem<String>(
              value: item,
              child: Text(item,
                  style: _style ??
                      poppinsRegular(
                        fontSize: 12,
                        color: DynamicColors.textColor,
                        fontWeight: FontWeight.w300,
                      )));
        }).toList(),
        onChanged: (value) {
          if (_listener != null) _listener!.call(value);
        },
      ),
    );
  }
}

class ClassifiedDropDownClass extends StatelessWidget {
  final String? _hint;
  List<ClassifiedCategoriesData>? finalList = [];
  final String? _validationError;
  final ClassifiedCategoriesData? _initialValue;
  final Widget? _suffixWidget;
  final EdgeInsets? _contentPadding;
  final TextStyle? _style;
  final TextStyle? _hintStyle;
  final InputBorder? _border;
  final InputBorder? _focusedBorder;
  final InputBorder? _enabledBorder;

  List<ClassifiedCategoriesData>? get list => finalList;
  final dynamic Function(ClassifiedCategoriesData)? _listener;

  ClassifiedDropDownClass({
    Key? key,
    List<ClassifiedCategoriesData>? list,
    TextStyle? style,
    TextStyle? hintStyle,
    required String? hint,
    IconData? suffixIcon,
    Widget? icon,
    Widget? suffixWidget,
    InputBorder? border,
    InputBorder? focusedBorder,
    InputBorder? enabledBorder,
    EdgeInsets? contentPadding,
    Color? dropDownColor,
    Color? hintColor,
    Color? textColor,
    ClassifiedCategoriesData? initialValue,
    required String? validationError,
    Color? backgroundColor,
    dynamic Function(dynamic)? listener,
  })  : finalList = list,
        _hint = hint,
        _style = style,
        _hintStyle = hintStyle,
        _border = border,
        _initialValue = initialValue,
        _focusedBorder = focusedBorder,
        _enabledBorder = enabledBorder,
        _suffixWidget = suffixWidget,
        _validationError = validationError,
        _contentPadding = contentPadding,
        _listener = listener,
        super(key: key);

  final GlobalKey _dropdownButtonKey = GlobalKey();

  void openDropdown() {
    GestureDetector? detector;
    void searchForGestureDetector(BuildContext element) {
      element.visitChildElements((element) {
        if (element.widget is GestureDetector) {
          detector = element.widget as GestureDetector;
          return;
        } else {
          if (detector == null) {
            searchForGestureDetector(element);
          }
        }

        return;
      });
    }

    if (detector == null) {
      searchForGestureDetector(_dropdownButtonKey.currentContext!);
    }
    assert(detector != null);

    detector!.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<ClassifiedCategoriesData>(
        value: _initialValue,
        key: _dropdownButtonKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        dropdownColor: DynamicColors.primaryColorLight,
        validator: (value) {
          if (value == null) {
            return "Please select ${_validationError!.toLowerCase()}";
          }
          return null;
        },
        decoration: InputDecoration(
          suffixIcon: _suffixWidget == null
              ? null
              : GestureDetector(
                  onTap: () {
                    openDropdown();
                  },
                  child: _suffixWidget),
          contentPadding:
              _contentPadding ?? EdgeInsets.only(left: 20, right: 5),
          border: _border ??
              UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: DynamicColors.primaryColorRed, width: 2)),
          focusedBorder: _focusedBorder ??
              UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: DynamicColors.primaryColorRed, width: 2)),
          enabledBorder: _enabledBorder ??
              UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: DynamicColors.primaryColorRed, width: 1)),
        ),
        style: poppinsRegular(
          color: DynamicColors.textColor,
          fontWeight: FontWeight.w300,
        ),
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        isExpanded: true,
        hint: Text(_hint!,
            style: _hintStyle ??
                poppinsRegular(
                  fontSize: 12,
                  color: DynamicColors.accentColor.withOpacity(0.5),
                  fontWeight: FontWeight.w300,
                )),
        items: list!.map((item) {
          return DropdownMenuItem<ClassifiedCategoriesData>(
              value: item,
              child: Text(item.title!,
                  style: _style ??
                      poppinsRegular(
                        fontSize: 12,
                        color: DynamicColors.textColor,
                        fontWeight: FontWeight.w300,
                      )));
        }).toList(),
        onChanged: (value) {
          if (_listener != null) _listener!.call(value!);
        },
      ),
    );
  }
}

class GroupDropDownClass extends StatelessWidget {
  final String? _hint;
  List<GroupJoined>? finalList = [];
  final String? _validationError;
  final GroupData? _initialValue;
  final Widget? _suffixWidget;
  final EdgeInsets? _contentPadding;
  final TextStyle? _style;
  final TextStyle? _hintStyle;
  final InputBorder? _border;
  final InputBorder? _focusedBorder;
  final InputBorder? _enabledBorder;

  List<GroupJoined>? get list => finalList;
  final dynamic Function(GroupData)? _listener;

  GroupDropDownClass({
    Key? key,
    List<GroupJoined>? list,
    TextStyle? style,
    TextStyle? hintStyle,
    required String? hint,
    IconData? suffixIcon,
    Widget? icon,
    Widget? suffixWidget,
    InputBorder? border,
    InputBorder? focusedBorder,
    InputBorder? enabledBorder,
    EdgeInsets? contentPadding,
    Color? dropDownColor,
    Color? hintColor,
    Color? textColor,
    GroupData? initialValue,
    required String? validationError,
    Color? backgroundColor,
    dynamic Function(GroupData)? listener,
  })  : finalList = list,
        _hint = hint,
        _style = style,
        _hintStyle = hintStyle,
        _border = border,
        _initialValue = initialValue,
        _focusedBorder = focusedBorder,
        _enabledBorder = enabledBorder,
        _suffixWidget = suffixWidget,
        _validationError = validationError,
        _contentPadding = contentPadding,
        _listener = listener,
        super(key: key);

  final GlobalKey _dropdownButtonKey = GlobalKey();

  void openDropdown() {
    GestureDetector? detector;
    void searchForGestureDetector(BuildContext element) {
      element.visitChildElements((element) {
        if (element.widget is GestureDetector) {
          detector = element.widget as GestureDetector;
          return;
        } else {
          if (detector == null) {
            searchForGestureDetector(element);
          }
        }

        return;
      });
    }

    if (detector == null) {
      searchForGestureDetector(_dropdownButtonKey.currentContext!);
    }
    assert(detector != null);

    detector!.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<GroupData>(
        value: _initialValue,
        key: _dropdownButtonKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        dropdownColor: DynamicColors.primaryColorLight,
        validator: (value) {
          if (value == null) {
            return "Please select ${_validationError!.toLowerCase()}";
          }
          return null;
        },
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        decoration: InputDecoration(
          suffixIcon: _suffixWidget == null
              ? null
              : GestureDetector(
                  onTap: () {
                    openDropdown();
                  },
                  child: _suffixWidget),
          contentPadding:
              _contentPadding ?? EdgeInsets.only(left: 20, right: 5),
          border: _border ??
              UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: DynamicColors.primaryColorRed, width: 2)),
          focusedBorder: _focusedBorder ??
              UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: DynamicColors.primaryColorRed, width: 2)),
          enabledBorder: _enabledBorder ??
              UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: DynamicColors.primaryColorRed, width: 1)),
        ),
        style: poppinsRegular(
          color: DynamicColors.textColor,
          fontWeight: FontWeight.w300,
        ),
        isExpanded: true,
        hint: Text(_hint!,
            style: _hintStyle ??
                poppinsRegular(
                  fontSize: 12,
                  color: DynamicColors.accentColor.withOpacity(0.5),
                  fontWeight: FontWeight.w300,
                )),
        items: list!.map((item) {
          return DropdownMenuItem<GroupData>(
              value: item.group,
              child: Text(item.group!.name!,
                  style: _style ??
                      poppinsRegular(
                        fontSize: 12,
                        color: DynamicColors.textColor,
                        fontWeight: FontWeight.w300,
                      )));
        }).toList(),
        onChanged: (value) {
          if (_listener != null) _listener!.call(value!);
        },
      ),
    );
  }
}
