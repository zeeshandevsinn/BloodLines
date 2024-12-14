import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/View/newsFeed/view/post/postWidget.dart';
import 'package:flutter/material.dart';

class TimelinePosts extends StatelessWidget {
  const TimelinePosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // PostWidget(
        //   title: "Kate Winslet",
        //   subTitle: "Golden Retriever · Fayetteville",
        //   profileImage: "assets/profile/dp.png",
        //   description: "Isn't five-month-old Teddy cute? 😏 😏",
        //   actionWidget: Transform.rotate(
        //     angle: 300,
        //     child: Image.asset(
        //       "assets/more.png",
        //       height: 20,
        //       width: 20,
        //       color: DynamicColors.accentColor,
        //     ),
        //   ),
        //   postWidget: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 10),
        //     child: Row(
        //       children: [
        //         Expanded(child: Image.asset("assets/post/post3.png")),
        //         SizedBox(
        //           width: 5,
        //         ),
        //         Expanded(child: Image.asset("assets/post/post2.png")),
        //         SizedBox(
        //           width: 5,
        //         ),
        //         Expanded(child: Image.asset("assets/post/post1.png")),
        //       ],
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   height: 20,
        // ),
        // PostWidget(
        //   title: "Kate Winslet",
        //   subTitle: "Golden Retriever · Fayetteville",
        //   profileImage: "assets/profile/dp.png",
        //   description: "It's a joy to work with dogs. Life is great.",
        //   actionWidget: Transform.rotate(
        //     angle: 300,
        //     child: Image.asset(
        //       "assets/more.png",
        //       height: 20,
        //       width: 20,
        //       color: DynamicColors.accentColor,
        //     ),
        //   ),
        //   image: "assets/eventMembers/eventImage1.png",
        // ),
      ],
    );
  }
}
