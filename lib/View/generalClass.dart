import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/CustomAlert.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/Components/textField.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/SingletonPattern/singletonUser.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class GeneralClass extends StatelessWidget {
  GeneralClass({super.key});

  FeedController controller = Get.find();

  List<GeneralModel> list = [
    GeneralModel(
        title: "Profile",
        icon: Entypo.user,
        onTap: () {
          Get.toNamed(Routes.timeline);
        }),
    GeneralModel(
        title: "My Cards",
        icon: Entypo.vcard,
        onTap: () {
          Get.toNamed(Routes.cardList);
        }),
    GeneralModel(
        title: "My Address",
        icon: Elusive.address_book,
        onTap: () {
          Get.toNamed(Routes.addressList);
        }),
    GeneralModel(
        title: "Order History",
        icon: Elusive.basket,
        onTap: () {
          Get.toNamed(Routes.orderHistory);
        }),

    GeneralModel(
        title: "Blocked List",
        icon: Entypo.block,
        onTap: () {
          Get.toNamed(Routes.blockedList);
        }),
    GeneralModel(
        title: "Private Profile",
        icon: Entypo.user,
        isSwitch: true,
        onTap: () {}),
  ];

  deletionMethod(AuthCredential? credentials, user) async {
    if (credentials != null) {
      UserCredential? result;
      try {
        result = await user!.reauthenticateWithCredential(credentials);
      } on FirebaseAuthException catch (e) {
        BotToast.closeAllLoading();
        BotToast.showText(text: e.message.toString());
      }
      if (result != null) {
        await result.user!.delete();
        String? deviceId = await PlatformDeviceId.getDeviceId;
        await FirebaseFirestore.instance
            .collection("appleIdentifier")
            .doc(deviceId)
            .delete();

        BotToast.closeAllLoading();
        controller.deleteAccount();
      } else {
        BotToast.closeAllLoading();
        BotToast.showText(text: "Something went wrong");
      }
    } else {
      BotToast.closeAllLoading();
      BotToast.showText(text: "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    // BotToast.closeAllLoading();
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight + 50,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
          child: CustomButton(
            text: "Delete Account",
            onTap: () {
              alertCustomMethod(context,
                  theme: DynamicColors.primaryColor,
                  titleText: "Do you want to delete your account?",
                  click: () async {
                    if (Api.singleton.sp.read("loginType") == "normal") {
                      controller.deleteAccount();
                    } else {
                      showLoading();
                      final user = FirebaseAuth.instance.currentUser;
                      AuthCredential? credentials;
                      if (Api.singleton.sp.read("loginType") == "apple") {
                        controller.deleteAccount();
                        // credentials = await appleDelete( user);
                      } else
                      if (Api.singleton.sp.read("loginType") == "google") {
                        credentials = GoogleAuthProvider.credential(
                            idToken: Api.singleton.sp.read("idToken"),
                            accessToken: Api.singleton.sp.read("accessToken"));
                        deletionMethod(credentials, user);
                      } else
                      if (Api.singleton.sp.read("loginType") == "facebook") {
                        credentials = FacebookAuthProvider.credential(
                            Api.singleton.sp.read("accessToken"));
                        deletionMethod(credentials, user);
                      }
                    }
                  },
                  click2: () {
                    Get.back();
                  },
                  buttonText: "Yes",
                  buttonText2: "No");
            },
            isLong: true,
            padding: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            borderRadius: BorderRadius.circular(5),
            margin: EdgeInsets.symmetric(vertical: 5),
            color: DynamicColors.primaryColorRed,
            borderColor: DynamicColors.primaryColorRed,
            style: montserratSemiBold(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: DynamicColors.whiteColor),
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: AppBarWidgets(
          onTap: () {
            Get.back();
          },
        ),
        title: Text(
          "General",
          style:
          poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
        ),
        elevation: 0,
      ),
      body: GetBuilder<FeedController>(builder: (controller) {
        return ListView.builder(
            itemCount: list.length,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (list[index].isSwitch == true) {
                return SwitchListTile(value: SingletonUser.singletonClass.user!.profileStatus == "private"?true:false, onChanged: (value){
                  if(value == true){
                    controller.profileStatus("private");
                  }else{
                    controller.profileStatus("public");
                  }
                },
                  activeColor: DynamicColors.primaryColorRed,
                tileColor: DynamicColors.whiteColor,

                  title: Row(
                    children: [
                      Icon(list[index].icon),
                      SizedBox(width: 5,),
                      Text(
                        list[index].title,
                        style: montserratRegular(fontSize: 14),
                      ),
                    ],
                  ),);
              }
              return ListTile(
                  tileColor: DynamicColors.whiteColor,
                  leading: Icon(list[index].icon),
                  title: Text(
                    list[index].title,
                    style: montserratRegular(fontSize: 14),
                  ),
                  onTap: list[index].onTap);
            });
      }),
    );
  }

  RxBool isPassword = true.obs;
  final loginPasswordController = TextEditingController();

  appleDelete(user) async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("appleIdentifier")
        .doc(deviceId)
        .get();

    var data = snapshot.data() as Map;

    if (Api.singleton.sp.read("email") == data["email"]) {
      AuthCredential? credentials = AppleAuthProvider.credential(
          data["authorizationCode"]);

      // final oAthProvider = OAuthProvider("apple.com");
      // final credentials = oAthProvider.credential(
      //     accessToken: data["authorizationCode"],
      //     idToken: data["identityToken"]);
      deletionMethod(credentials, user);
    } else {
      throw Exception();
    }
  }
}

class GeneralModel {
  String title;
  IconData icon;
  bool? isSwitch;
  GestureTapCallback onTap;

  GeneralModel({
    required this.title,
    required this.icon,
    this.isSwitch = false,
    required this.onTap,
  });
}
