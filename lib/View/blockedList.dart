import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class BlockedList extends StatelessWidget {
   BlockedList({super.key});
  final FeedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: AppBarWidgets(
          isCardType: true,
        ),
        centerTitle: true,
        title: Text(
          "Blocked List",
          style: montserratBold(),
        ),
      ),
      body: GetBuilder<FeedController>(
        initState: (c){
          controller.getBlockedList();
        },
        builder: (controller){
        if(controller.blockedList == null){
          return Center(
            child: LoaderClass(),
          );
        }

        if (controller.blockedList!.data!.isEmpty) {
          return Center(
            child: Text(
              "No Data",
              style: poppinsBold(fontSize: 25),
            ),
          );
        }

        return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: controller.blockedList!.data!.length,
            itemBuilder: (context, index) {
              UserModel user = controller.blockedList!.data![index].user!;
              if (user.profile == null) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: DynamicColors.accentColor)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: OptimizedCacheImage(
                          imageUrl: user.profile!.profileImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.profile!.fullname!,
                          style: poppinsRegular(fontSize: 15),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                      ],
                    ),
                    Spacer(),
                    CustomButton(
                      text: "Unblock",
                      isLong: false,
                      onTap: () {
                        controller.blockUnblockUser(userId: user.id.toString(), status: "unblock");
                      },
                      padding:
                      EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                      color: DynamicColors.primaryColorLight,
                      borderColor: DynamicColors.primaryColorRed,
                      borderRadius: BorderRadius.circular(5),
                      style: poppinsLight(
                          color: DynamicColors.primaryColorRed,fontSize: 15),
                    )
                  ],
                ),
              );
            });
      },),
    );
  }
}
