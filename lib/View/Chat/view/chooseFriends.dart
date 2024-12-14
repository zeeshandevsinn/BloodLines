import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/userModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:get/get.dart';
import 'package:bloodlines/View/Chat/controller/chatController.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/textField.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class ChooseFriends extends StatefulWidget {
  ChooseFriends({Key? key}) : super(key: key);

  @override
  State<ChooseFriends> createState() => _ChooseFriendsState();
}

class _ChooseFriendsState extends State<ChooseFriends> {
  ChatController controller = Get.find();

  FeedController newsFeedController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newsFeedController.getFollowers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColors.primaryColorLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: AppBarWidgets(),
        title: Text(
          "Choose Friends",
          style:
              poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 28),
        ),
        elevation: 0,
      ),
      body: GetBuilder<FeedController>(builder: (c) {
        if (newsFeedController.followings == null) {
          return Center(child: LoaderClass());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                filled: true,
                fillColor: DynamicColors.primaryColorLight,
                hint: "Search..",
                controller: controller.searchController,
                onChanged: (c) {
                  controller.update();
                },
                isUnderLineBorder: false,
                radius: 10,
                // left: 10,
                cursorColor: DynamicColors.primaryColor,
                style: poppinsRegular(color: DynamicColors.primaryColor),
                suffixIcon: InkWell(
                  onTap: () {
                    // controller.determinePosition();
                  },
                  child: Icon(
                    Octicons.search,
                    color: DynamicColors.primaryColor.withOpacity(0.5),
                  ),
                ),
                hintStyle: poppinsRegular(
                    color: DynamicColors.primaryColor.withOpacity(0.5),
                    fontSize: 14),
              ),
              SizedBox(
                height: 20,
              ),
              newsFeedController.followings == null?
                  Padding(padding: EdgeInsets.only(top: Utils.height(context)/4),
                  child: LoaderClass(),
                  )
                  :
              newsFeedController.followings!.data!.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 4),
                      child: Text(
                        "No Data",
                        style: poppinsBold(fontSize: 25),
                      ),
                    )
                  : ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: newsFeedController.followings!.data!.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        UserModel user =
                            newsFeedController.followings!.data![index].users!;
                        if (user.profile!.fullname!.toLowerCase().contains(
                            controller.searchController.text.toLowerCase())) {
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
                                    child: OptimizedCacheImage(
                                      imageUrl: user.profile!.profileImage!,
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
                                CustomButton(
                                  text: "Chat",
                                  onTap: () {
                                    controller.chatModel = null;
                                    controller.inboxId = null;
                                    controller.userData = user;
                                    Get.toNamed(Routes.chatScreen, arguments: {
                                      "id": user.id,
                                      "user": user,
                                    })!
                                        .then((value) => controller.getInbox());
                                  },
                                  isLong: false,
                                  borderColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  borderRadius: BorderRadius.circular(5),
                                  color: DynamicColors.primaryColor,
                                  style: poppinsRegular(
                                      fontSize: 15,
                                      color: DynamicColors.primaryColorLight),
                                ),
                              ],
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      }),
            ],
          ),
        );
      }),
    );
  }
}
