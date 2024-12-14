import 'package:bloodlines/Components/Color.dart';
import 'package:flutter/material.dart';

class DividerClass extends StatelessWidget {
  const DividerClass(
      {Key? key,
      this.height = 20,
      this.width = 3,
      this.color = DynamicColors.constTextColor})
      : super(key: key);
  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
        ),
        Divider(
          height: width,
          color: color,
        ),
        SizedBox(
          height: height,
        ),
      ],
    );
  }
}

class Pad extends StatelessWidget {
  const Pad({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: child,
    );
  }
}
