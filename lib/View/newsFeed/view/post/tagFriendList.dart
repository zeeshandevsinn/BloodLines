// ignore_for_file: must_be_immutable, invalid_use_of_protected_member

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class TagFriend extends StatelessWidget {
  TagFriend({Key? key}) : super(key: key);
  FeedController controller = Get.find();

  Future<bool> onWillPop()async{
    controller.taggedUserModel = null;
    Get.back();
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:onWillPop,
      child: Scaffold(
        backgroundColor: DynamicColors.primaryColorLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: AppBarWidgets(
            onTap: (){
              onWillPop();
            },
          ),
          title: Text(
            "Tag Friends",
            style:
                poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 28),
          ),
          elevation: 0,
        ),
        body: GetBuilder<FeedController>(builder: (controller) {
          if (controller.taggedUserModel == null) {
            return Center(
              child: LoaderClass(),
            );
          }
          if (controller.taggedUserModel!.data!.isEmpty) {
            return Center(
              child: Text(
                "No Data",
                style: poppinsBold(fontSize: 25),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                ListView.builder(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: controller.taggedUserModel!.data!.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      UserModel user = controller.taggedUserModel!.data![index];
                      if(user.isReported == 1){
                        return Container();
                      }
                      if (controller.taggedUser
                          .any((element) => element.id == user.id)) {
                        user.isTagSelected!.value = true;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child:
                                SizedBox(
                                 child: OptimizedCacheImage(
                                    imageUrl:
                                    user.profile!.profileImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              user.profile!.fullname!,
                              style: poppinsRegular(),
                            ),
                            Spacer(),
                            Obx(() {
                              return InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                onTap: () {
                                  user.isTagSelected!.value =
                                      !user.isTagSelected!.value;
                                  if (user.isTagSelected!.value == true) {
                                    controller.taggedUserList.add(user.id!);
                                    controller.taggedUser.add(user);
                                  } else {
                                    controller.taggedUserList.removeWhere(
                                        (element) => element == user.id);
                                    controller.taggedUser.value.removeWhere(
                                        (element) => element.id == user.id);
                                    print(controller.taggedUser.value);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: user.isTagSelected!.value == false
                                          ? DynamicColors.accentColor
                                          : DynamicColors.primaryColor),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.check,
                                      color: DynamicColors.whiteColor,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                      );
                    }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
