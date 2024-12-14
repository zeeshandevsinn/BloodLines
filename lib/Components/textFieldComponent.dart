import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';

class TextFieldComponent extends StatelessWidget {
  const TextFieldComponent({
    Key? key,
    required this.title,
    required this.hint,
    required this.controller,
    this.suffix,
    this.fromPedigree = false,
    this.nameOnly = false,
    this.allowDashes = false,
    this.maxLength,
    this.formatter,
    this.onChanged,
    this.underLineBorderColor = const Color(0xffD50814),
    this.onTap,
    this.titleFontWeight = FontWeight.bold,
    this.titleFontSize = 21,
    this.readOnly = false,
    this.maxLines = 1,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  final String title;
  final String hint;
  final dynamic formatter;
  final bool readOnly;
  final bool fromPedigree;
  final bool allowDashes;
  final bool nameOnly;
  final TextEditingController controller;
  final int maxLines;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final int? maxLength;
  final Widget? suffix;
  final Color underLineBorderColor;
  final VoidCallback? onTap;
  final TextInputType? textInputType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
          Text(
            title,
            style: poppinsLight(fontSize: titleFontSize, fontWeight:titleFontWeight),
          ),
          SizedBox(height: 5,),
        CustomTextField(
          controller: controller,
          mainPadding: EdgeInsets.zero,
          nameOnly: nameOnly,
          allowDashes: allowDashes,
          hint: hint,
          onTap: onTap,
          onChanged: onChanged,

          maxLength: maxLength,
          underLineBorderColor:underLineBorderColor,
          formatter: formatter == null?[RemoveEmojiInputFormatter()]:[
            RemoveEmojiInputFormatter(),
            formatter
          ],
          readOnly: readOnly,
          maxLines: maxLines,
          suffixIcon: suffix,
          textInputType: textInputType,
          fromPedigree: fromPedigree,
          validationError:title,
        ),
      ],
    );
  }
}
