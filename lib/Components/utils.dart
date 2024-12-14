import 'dart:io';

import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Chat/controller/chatController.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/userModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';

class Utils {
  static double height(context) => MediaQuery.of(context).size.height;
  static double width(context) => MediaQuery.of(context).size.width;

  static onNavigateTimeline(int id){
    if(id == Api.singleton.sp.read("id")) {
      Get.toNamed(Routes.timeline);
    }else{
      if(Api.singleton.sp.read("friendId") != id){
        FeedController controller = Get.find();
        controller.friendProfile = Rxn<UserModel>();
      }
      Get.toNamed(Routes.friendTimeline,arguments: {"id": id});
    }
  }
  static routeOnTimeline(
      int id,UserModel user, {
        fromChat = false,
        fromSearch = false,
        mustThen = false,
      }) {
    if (id == Api.singleton.sp.read("id")) {
      if (fromChat == true) {
        Get.back();
      } else {
        Get.toNamed(Routes.timeline);
      }
    } else {
      if (fromChat == true) {
        Get.back();
      } else {
        if(user.blockBy == false && user.isBlock == false){

          Get.toNamed(Routes.friendTimeline, arguments: {
            "id": user.id,
            "fromChat": fromChat,
            "fromSearch": fromSearch,
          })!.then((value)async {
            FeedController controller = Get.find();
            if(fromSearch == true){

              controller.getSearchedData();
            }else if(mustThen == true){
              ChatController chatController = Get.find();
              final users = await controller.getAnyUserProfile(id);
              chatController.userData = users;
              chatController.update();

            }
          });
        }
      }
    }
  }
}

Future<Map<Permission, PermissionStatus>> permissionServices(
    {Function? func}) async {
  // You can request multiple permissions at once.
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
  ].request();

  if (statuses[Permission.location]!.isPermanentlyDenied) {
    BotToast.showText(text: "You denied permission location!! Please turn on from your setting");
    await openAppSettings().then(
      (value) async {
        if (value) {
          if (await Permission.location.status.isPermanentlyDenied == true &&
              await Permission.location.status.isGranted == false) {
            print(false);
            openAppSettings();
            // permissionServiceCall(); /* opens app settings until permission is granted */
          }
        }
      },
    );
  } else {
    if (statuses[Permission.location]!.isDenied) {
      func!.call();
    }

  }

  /*{Permission.camera: PermissionStatus.granted, Permission.storage: PermissionStatus.granted}*/
  return statuses;
}
getDownloadedFile(url)async{
   await DefaultCacheManager().downloadFile(url,key: url);
}