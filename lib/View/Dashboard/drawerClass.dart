import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/SingletonPattern/singletonUser.dart';
import 'package:bloodlines/View/Classified/Data/classifiedController.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class DrawerClass extends StatelessWidget {
  DrawerClass({Key? key, this.scaffoldKey,})
      : super(key: key);
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final FeedController controller = Get.find();


  closeDrawer() {
    scaffoldKey!.currentState!.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          backgroundColor: DynamicColors.primaryColorLight,
          canvasColor: Color(0xFFF5F5F5)),
      child: Drawer(
        width: Utils.width(context) / 1.2,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.timeline);
              },
              child: SizedBox(
                height: Utils.height(context) / 4.5,
                // decoration: BoxDecoration(
                //     color: DynamicColors.accentColor.withOpacity(0.3)),
                child: GetBuilder<FeedController>(
                  builder: (controller) {
                    final user = SingletonUser.singletonClass.getUser;
                    return Stack(
                      children: [
                        Positioned(
                            right: 10,
                            top: 20,
                            child: InkWell(
                              onTap: () {
                                closeDrawer();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: DynamicColors.primaryColorRed),
                                    shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.close,
                                    color: DynamicColors.primaryColorRed,
                                  ),
                                ),
                              ),
                            )),
                        Positioned(
                            left: 10,
                            bottom: 20,
                            child: user == null ? Container() : Row(
                              children: [
                                SizedBox(
                                  height: 80,
                                  child: OptimizedCacheImage(
                                    imageUrl:
                                    user.profile!.profileImage!,

                                    fit: BoxFit.cover,
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
                                      style: montserratRegular(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: user.followersCount
                                                  .toString(),
                                              style: montserratBold(
                                                  fontSize: 14)),
                                          WidgetSpan(
                                              child: SizedBox(
                                                width: 3,
                                              )),
                                          TextSpan(
                                              text: "Followers",
                                              style: poppinsLight(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w100)),
                                          WidgetSpan(
                                              child: SizedBox(
                                                width: 10,
                                              )),
                                          TextSpan(
                                              text: user.followingCount
                                                  .toString(),
                                              style: montserratBold(
                                                  fontSize: 14)),
                                          WidgetSpan(
                                              child: SizedBox(
                                                width: 3,
                                              )),
                                          TextSpan(
                                              text: "Following",
                                              style: poppinsLight(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w100)),
                                        ]))
                                  ],
                                )
                              ],
                            )),
                      ],
                    );
                  },
                ),
              ),
            ),
            ListTile(
              tileColor: DynamicColors.whiteColor,
              title: Text(
                "Account Orders & Subscriptions",
                style: montserratRegular(fontSize: 14),
              ),
              onTap: () {
                closeDrawer();
                Get.toNamed(Routes.account);
              },
            ),
            SizedBox(
              height: 5,
            ),
            // ListTile(
            //   tileColor: DynamicColors.whiteColor,
            //   title: Text(
            //     "Events",
            //     style: montserratRegular(fontSize: 14),
            //   ),
            //   onTap: () {
            //     closeDrawer();
            //     controller.getAllEvents();
            //     Get.toNamed(Routes.allEvents);
            //   },
            // ),
            // SizedBox(
            //   height: 1,
            // ),
            ListTile(
              tileColor: DynamicColors.whiteColor,
              title: Text(
                "My Events",
                style: montserratRegular(fontSize: 14),
              ),
              onTap: () {
                closeDrawer();
                controller.getCreated();
                controller.getAttending();
                Get.toNamed(Routes.myEvents);
              },
            ),
            SizedBox(
              height: 1,
            ),
            ListTile(
              tileColor: DynamicColors.whiteColor,
              title: Text(
                "My Groups",
                style: montserratRegular(fontSize: 14),
              ),
              onTap: () {
                controller.tabIndex.value = 3;
                closeDrawer();
              },
            ),
            SizedBox(
              height: 1,
            ),
            ListTile(
              tileColor: DynamicColors.whiteColor,
              title: Text(
                "My Classified",
                style: montserratRegular(fontSize: 14),
              ),
              onTap: () {
                closeDrawer();
                ClassifiedController controller = Get.put(
                    ClassifiedController());
                controller.getMyClassifiedAds();
                Get.toNamed(Routes.myClassified);
              },
            ),
            SizedBox(
              height: 1,
            ),
            // ListTile(
            //   tileColor: DynamicColors.whiteColor,
            //   title: Text(
            //     "Order History",
            //     style: montserratRegular(fontSize: 14),
            //   ),
            //   onTap: () {
            //     closeDrawer();
            //     Get.toNamed(Routes.orderHistory);
            //   },
            // ),
            // SizedBox(
            //   height: 1,
            // ),
            // ListTile(
            //   tileColor: DynamicColors.whiteColor,
            //   title: Text(
            //     "Blocked List",
            //     style: montserratRegular(fontSize: 14),
            //   ),
            //   onTap: () {
            //     closeDrawer();
            //     Get.toNamed(Routes.blockedList);
            //   },
            // ),
            // SizedBox(
            //   height: 1,
            // ),
            // ListTile(
            //   tileColor: DynamicColors.whiteColor,
            //   title: Text(
            //     "Address",
            //     style: montserratRegular(fontSize: 14),
            //   ),
            //   onTap: () {
            //     closeDrawer();
            //     Get.toNamed(Routes.addressList);
            //   },
            // ),
            SizedBox(
              height: 8,
            ),
            ListTile(
              tileColor: DynamicColors.whiteColor,
              title: Text(
                "Payment Methods",
                style: montserratRegular(fontSize: 14),
              ),
              onTap: () {
                closeDrawer();
                Get.toNamed(Routes.paymentMethod);
              },
            ),
            SizedBox(
              height: 8,
            ),
            ListTile(
              tileColor: DynamicColors.whiteColor,
              title: Text(
                "General",
                style: montserratRegular(fontSize: 14),
              ),
              onTap: () {
                Get.toNamed(Routes.generalClass);
              },
            ),
            SizedBox(
              height: 1,
            ),
            ListTile(
              tileColor: DynamicColors.whiteColor,
              title: Text(
                "Help and Feedback",
                style: montserratRegular(fontSize: 14),
              ),
              onTap: () {},
            ),
            SizedBox(
              height: 1,
            ),
            ListTile(
              tileColor: DynamicColors.whiteColor,
              title: Text(
                "About Bloodlines",
                style: montserratRegular(fontSize: 14),
              ),
              trailing: Text(
                "Version 6.0.5",
                style: poppinsRegular(
                    fontSize: 10, color: DynamicColors.accentColor),
              ),
              onTap: () {},
            ),
            SizedBox(
              height: 8,
            ),
            ListTile(
              tileColor: DynamicColors.whiteColor,
              title: Center(
                child: Text(
                  "Log out",
                  style: montserratRegular(
                      fontSize: 14, color: DynamicColors.primaryColorRed),
                ),
              ),
              onTap: () {
                Api.singleton.sp.erase();
                Get.offAllNamed(Routes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
