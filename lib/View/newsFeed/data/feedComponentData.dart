import 'dart:io';

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/imageBottomSheet.dart';
import 'package:bloodlines/Components/markdown.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:multi_image_crop/multi_image_crop.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedComponentData {
  FeedController controller = Get.find();
  loc.Location location = loc.Location();
  final ImagePicker _picker = ImagePicker();

  _imgFromGallery(context, {fromAddEvent = false}) async {
    try {
      controller.files = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxHeight: 1200,
          maxWidth: 1200);

      if (controller.files != null) {
        CroppedFile? crop = await ImageCropper.platform
            .cropImage(sourcePath: controller.files!.path);
        if (crop != null) {
          controller.files = XFile(crop.path);
          controller.update();
        }
      }

      controller.update();
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
  }

  _imgFromCamera(context, {fromAddEvent = false}) async {
    try {
      controller.files = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxHeight: 1200,
          maxWidth: 1200);

      if (controller.files != null) {
        CroppedFile? crop = await ImageCropper.platform
            .cropImage(sourcePath: controller.files!.path);
        if (crop != null) {
          controller.files = XFile(crop.path);
          controller.update();
        }
      }
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
  }

  Widget popUpMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: 150,
          height: 50,
          color: const Color(0xFF4C4C4C),
          child: GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: controller.menuItems
                .map((item) => GestureDetector(
                      onTap: () async {
                        if (item.title == 'Gallery') {
                          PermissionStatus statuses =
                              await Permission.storage.request();
                          if (statuses == PermissionStatus.granted) {
                            _imgCommentFromGallery();
                          } else {
                            BotToast.showText(text: 'Permission not granted');
                          }
                        } else if (item.title == 'Camera') {
                          PermissionStatus statuses =
                              await Permission.camera.request();
                          if (statuses == PermissionStatus.granted) {
                            _imgCommentFromCamera();
                          } else {
                            BotToast.showText(text: 'Permission not granted');
                          }
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            item.icon,
                            size: 20,
                            color: Colors.white,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 2),
                            child: Text(
                              item.title,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  bottomSheet(context, {fromAddEvent = false}) {
    ImageBottomSheet.bottomSheet(
      context,
      onCameraTap: () async {
        _imgFromCamera(context, fromAddEvent: fromAddEvent);
        Navigator.of(context).pop();
      },
      onGalleryTap: () {
        _imgFromGallery(context, fromAddEvent: fromAddEvent);
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(days: 1)),
        firstDate: DateTime.now().add(Duration(days: 1)),
        lastDate: DateTime.now().add(Duration(days: 365)),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                    onPrimary: DynamicColors.whiteColor, // selected text color
                    onSurface:
                        DynamicColors.primaryColorRed, // default text color
                    primary: DynamicColors.primaryColorRed // circle color
                    ),
                dialogBackgroundColor: DynamicColors.primaryColorLight,
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        textStyle: poppinsRegular(
                          color: DynamicColors.primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                        // color of button's letters
                        backgroundColor:
                            DynamicColors.primaryColorLight, // Background color
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.transparent,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(50))))),
            child: child!,
          );
        });
    if (pickedDate != null) {
      controller.eventDate.value.text = DateFormat("yyyy-MM-dd")
          .format(pickedDate); //  DateFormat.yMd().format(pickedDate);
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedDate = await showTimePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                    onPrimary: DynamicColors.whiteColor, // selected text color
                    onSurface:
                        DynamicColors.primaryColorRed, // default text color
                    primary: DynamicColors.primaryColorRed // circle color
                    ),
                dialogBackgroundColor: DynamicColors.primaryColorLight,
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        textStyle: poppinsRegular(
                          color: DynamicColors.primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                        // color of button's letters
                        backgroundColor:
                            DynamicColors.primaryColorLight, // Background color
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.transparent,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(50))))),
            child: child!,
          );
        },
        initialTime: TimeOfDay.now());
    if (pickedDate != null) {
      final localizations = MaterialLocalizations.of(context);
     // String currentTime = DateFormat("HH:mm").format(DateTime.now());
      final formattedTimeOfDay = localizations.formatTimeOfDay(pickedDate,
          alwaysUse24HourFormat: true);
    // int compare =  currentTime.compareTo(formattedTimeOfDay);
      // if(compare < 0){
        controller.eventTime.value.text = formattedTimeOfDay;
      // }else{
      //   BotToast.showText(text: "You cannot select past time");
      // }
    }
  }

  _imgCommentFromGallery() async {
    try {
      controller.imageFile = null;

      final XFile? xFile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      if (xFile != null) {
        controller.imageFile = xFile;

        controller.customPopupMenuController.hideMenu();
        controller.fieldUpdate(true);
      }
    } catch (e) {
      controller.pickImageError = e;
    }
  }

  _imgCommentFromCamera() async {
    try {
      controller.imageFile = null;

      final XFile? xFile =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      if (xFile != null) {
        controller.imageFile = xFile;

        controller.customPopupMenuController.hideMenu();
        controller.fieldUpdate(true);
      }
    } catch (e) {
      controller.pickImageError = e;
    }
  }

  determinePositions() async {
    bool serviceEnabled;
    await permissionServices(func: () {
      determinePositions();
    }).then(
      (value) async {
        if (value != null) {
          if (value[Permission.location]!.isGranted) {
            serviceEnabled = await location.serviceEnabled();
            if (!serviceEnabled) {
              serviceEnabled = await location.requestService();
            }

            if (serviceEnabled) {
              Get.toNamed(Routes.eventMapLocation);
              controller.update();
            }
          } else {
            // exit(1);
          }
        }
      },
    );
  }

  ///Comments
  MarkdownBody markdownBody(text, context, TextStyle style,
      {selectable = true}) {
    return MarkdownBody(
      selectable: selectable,
      data: _replaceMentions(text), //.replaceAll('\n', '\\\n'),
      onTapLink: (
        String? link,
        String? href,
        String? title,
      ) {
        openUrl(link!);
      },
      onReadMore: (v) {
        print(v);
      },
      onTapText: () {
        print("hello");
        // Get.toNamed(Routes.friendTimeline,arguments: {"id": getUserID(data.body!)});
      },
      builders: {
        "coloredBox": ColoredBoxMarkdownElementBuilder(context,
            controller.usersList.map((u) => "${u.profile!.fullname}").toList()),
      },
      inlineSyntaxes: [
        ColoredBoxInlineSyntax(),
      ],
      styleSheet: MarkdownStyleSheet.fromTheme(
        Theme.of(context).copyWith(textTheme: TextTheme(bodyMedium: style)),
      ),
    );
  }

  openUrl(String url) async {
    if (url.startsWith("www")) {
      url = "https://$url/";
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not open the url.';
      }
    } else {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not open the url.';
      }
    }
  }

  openMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$query';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  String _replaceMentions(String text) {
    controller.usersList
        .map((u) => "${u.profile!.fullname}")
        .toSet()
        .forEach((userName) {
      text = text.replaceAll('@$userName', '[$userName]');
    });
    return text;
  }
}
