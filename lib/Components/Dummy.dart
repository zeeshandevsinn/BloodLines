// String dummyProfile =
//     'https://media.istockphoto.com/photos/beautiful-afro-woman-with-perfect-makeup-picture-id1287400198?b=1&k=20&m=1287400198&s=170667a&w=0&h=sRLKJQl8Hk1hp5ZS2XcpKcSnhF7w5h2rkLEEGGthilA=';

import 'package:flutter/material.dart';

String dummyProfile =
    "https://www.itdp.org/wp-content/uploads/2021/06/avatar-man-icon-profile-placeholder-260nw-1229859850-e1623694994111.jpg";
const String coverImage =
    "https://www.campusce.net/continuinged/configuration/CampusCE/img/category.jpg";
// const String coverImage = "https://wallpaperaccess.com/full/2213426.jpg";
validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
