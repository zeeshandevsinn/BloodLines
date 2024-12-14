import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import 'Color.dart';

class Like extends StatelessWidget {
  Like({
    required this.isLiked,
    required this.likeCount,
    this.iconDetail = Icons.thumb_up_alt,
    this.onclick,
    this.size = 30.0,
    this.column,
  });
  final bool isLiked;
  final int likeCount;
  final double? size;
  final Widget? column;
  IconData? iconDetail;
  Future<bool?> Function(bool)? onclick;
  @override
  Widget build(BuildContext context) {
    return LikeButton(
      onTap: onclick!,
      size: size!,
      circleColor:
          CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Color(0xff33b5e5),
        dotSecondaryColor: Color(0xff0099cc),
      ),
      likeBuilder: (bool isLiked) {
        return column ??
            Icon(
              iconDetail,
              color: isLiked ? DynamicColors.primaryColor : Colors.grey,
            );
      },
      isLiked: isLiked,
      likeCount: likeCount,
    );
  }
}
