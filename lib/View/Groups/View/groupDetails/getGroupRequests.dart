// // ignore_for_file: must_be_immutable
//
// import 'package:bloodlines/Components/Color.dart';
// import 'package:bloodlines/Components/TextStyle.dart';
// import 'package:bloodlines/Components/appbarWidget.dart';
// import 'package:bloodlines/Components/loader.dart';
// import 'package:bloodlines/View/newsFeed/data/feedController.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class GetGroupRequests extends StatefulWidget {
//   GetGroupRequests({Key? key}) : super(key: key);
//
//   @override
//   State<GetGroupRequests> createState() => _GetGroupRequestsState();
// }
//
// class _GetGroupRequestsState extends State<GetGroupRequests> {
//   FeedController controller = Get.find();
//
//   @override
//   void initState() {
//     controller.getGroupRequests(controller.groupDetails!.value!.id!);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: DynamicColors.primaryColorLight,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         centerTitle: true,
//         leading: AppBarWidgets(),
//         title: Text(
//           "Requests",
//           style:
//               poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 28),
//         ),
//         elevation: 0,
//       ),
//       body: Obx(() {
//         if (controller.groupRequestsMembers!.value!.results == null) {
//           return Center(child: LoaderClass());
//         } else if (controller.groupRequestsMembers!.value!.results!.isEmpty) {
//           return Center(
//             child: Text(
//               "No Requests Found",
//               style: poppinsBold(color: DynamicColors.primaryColor),
//             ),
//           );
//         }
//         return ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//             itemCount: controller.groupRequestsMembers!.value!.results!.length,
//             shrinkWrap: true,
//             padding: EdgeInsets.zero,
//             itemBuilder: (context, index) {
//               RequestMembersResult result =
//                   controller.groupRequestsMembers!.value!.results![index];
//               if (result.user == null) {
//                 return Container();
//               }
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(30),
//                           child: Image.network(
//                             result.user!.profileNormal!.normalProfileMeta!
//                                 .profileImage!,
//                             height: 50,
//                           ),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         SizedBox(
//                           width: width(context) / 1.7,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               result.groupInvite == null ||
//                                       result.groupInvite!.userInviteBy == null
//                                   ? RichText(
//                                       text: TextSpan(children: [
//                                       // TextSpan(
//                                       //     text: result.user!.profileNormal!
//                                       //         .normalProfileMeta!.name!,
//                                       //     style: poppinsBold(
//                                       //         color: DynamicColors.primaryColor,
//                                       //         fontSize: 16)),
//                                       TextSpan(
//                                           text:
//                                               "${result.user!.profileNormal!.normalProfileMeta!.name}",
//                                           style: poppinsBold(
//                                               color: DynamicColors.primaryColor,
//                                               fontSize: 16)),
//                                       TextSpan(
//                                           text: " wants to join this group",
//                                           style: poppinsRegular(
//                                               color: DynamicColors.textColor,
//                                               fontSize: 16)),
//
//                                       // TextSpan(
//                                       //     text: " sends you a friend request",
//                                       //     style: poppinsLight(fontSize: 16)),
//                                       // TextSpan(
//                                       //     text: result.profileType == "normal_profile"
//                                       //         ? ""
//                                       //         : " in ",
//                                       //     style: poppinsLight(fontSize: 16)),
//                                       // TextSpan(
//                                       //     text: result.profileType == "normal_profile"
//                                       //         ? ""
//                                       //         : "Alter Ego",
//                                       //     style: poppinsLight(
//                                       //         color: DynamicColors.primaryColor,
//                                       //         fontSize: 16)),
//                                     ]))
//                                   : RichText(
//                                       text: TextSpan(children: [
//                                       TextSpan(
//                                           text:
//                                               "${result.groupInvite!.userInviteBy!.profileNormal!.normalProfileMeta!.name}",
//                                           style: poppinsBold(
//                                               color: DynamicColors.primaryColor,
//                                               fontSize: 16)),
//                                       TextSpan(
//                                           text: " invite ",
//                                           style: poppinsRegular(
//                                               color: DynamicColors.textColor,
//                                               fontSize: 16)),
//                                       TextSpan(
//                                           text:
//                                               "${result.groupInvite!.userInviteTo!.profileNormal!.normalProfileMeta!.name}",
//                                           style: poppinsBold(
//                                               color: DynamicColors.primaryColor,
//                                               fontSize: 16)),
//                                       TextSpan(
//                                           text: " to the group",
//                                           style: poppinsRegular(
//                                               color: DynamicColors.textColor,
//                                               fontSize: 16)),
//                                     ])),
//                               SizedBox(
//                                 height: 11,
//                               ),
//                               Row(
//                                 children: [
//                                   CustomButton(
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 8, horizontal: 25),
//                                     isLong: false,
//                                     style: poppinsLight(
//                                         color: DynamicColors.primaryColor,
//                                         fontSize: 16),
//                                     text: "Reject",
//                                     onTap: () {
//                                       controller.approveRequestGroup(
//                                           controller.groupDetails!.value!.id!,
//                                           result.userId!,
//                                           "reject");
//                                     },
//                                     color: Colors.transparent,
//                                     border: Border.all(
//                                         color: DynamicColors.primaryColor),
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                   Spacer(),
//                                   CustomButton(
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 8, horizontal: 25),
//                                     text: "Accept",
//                                     onTap: () {
//                                       controller.approveRequestGroup(
//                                           controller.groupDetails!.value!.id!,
//                                           result.userId!,
//                                           "accept");
//                                     },
//                                     isLong: false,
//                                     style: poppinsLight(
//                                         color: DynamicColors.primaryColorDark,
//                                         fontSize: 15),
//                                     color: DynamicColors.primaryColor,
//                                     borderColor: DynamicColors.primaryColor,
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                         Spacer(),
//                         Text(notificationList[index].time,
//                             style: poppinsLight(fontSize: 12)),
//                       ],
//                     ),
//                   ),
//                   notificationList.length - 1 == index
//                       ? SizedBox.shrink()
//                       : DividerClass()
//                 ],
//               );
//             });
//       }),
//     );
//   }
// }
