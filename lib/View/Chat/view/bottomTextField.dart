// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';

import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:bloodlines/View/Chat/controller/chatController.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/customWidget.dart';
import 'package:bloodlines/Components/textField.dart';

class BottomTextField extends StatelessWidget {
  BottomTextField({Key? key}) : super(key: key);
  ChatController controller = Get.find();
  bool isMessage = false;
  bool firstTime = false;

  Timer? onStoppedTyping;

  _onChangeHandler(value) {
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call stopTyping() after that.
    if (onStoppedTyping != null) {
      if (controller.inboxId != null) {
        if (firstTime == false) {
          print("firstTime is true");
          firstTime = true;

          controller.socket!.emit("typing", {
            "conversation_id": controller.inboxId,
            "typing": true,
          });
        }
      }
      onStoppedTyping!.cancel(); // clear timer
    }
    onStoppedTyping = Timer(duration, () => stopTyping());
  }

  stopTyping() {
    firstTime = false;
    if (controller.inboxId != null) {
      controller.socket!.emit("typing", {
        "conversation_id": controller.inboxId,
        "typing": false,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller.imageFile.isEmpty) {
      return textField();
    }
    return Container(
      color: DynamicColors.primaryColorLight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 5),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.imageFile.length,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,

                    itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: SizedBox(
                      width: 50,
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child:
                            controller.imageFile[index].path.split(".").last == "mp4" || controller.imageFile[index].path.split(".").last == "mov"
                          ?ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  topLeft: Radius.circular(5)),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        topLeft: Radius.circular(5)),
                                    border: Border.all(
                                        color: DynamicColors.primaryColor)),
                                child: Center(child: Icon(Icons.play_circle_outline_rounded,color: DynamicColors.primaryColor)),
                              ),
                            ):ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  topLeft: Radius.circular(5)),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        topLeft: Radius.circular(5)),
                                    border: Border.all(
                                        color: DynamicColors.primaryColor)),
                                child: Image.file(
                                  File(controller.imageFile[index].path),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // controller.fileList.removeAt(index);
                              controller.imageFile.removeAt(index);
                              controller.fieldUpdate.value = !controller.fieldUpdate.value;
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: DynamicColors.primaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Divider(
            color: Colors.white,
          ),
          textField(),
        ],
      ),
    );
  }

  Container textField() {
    return Container(
      color: DynamicColors.accentColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Color(0xFF343434)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomPopupMenu(
                  controller: controller.customPopupMenuController,
                  menuBuilder: controller.popUpMenu,
                  horizontalMargin: 0,
                  showArrow: true,
                  barrierColor: Colors.transparent,
                  pressType: PressType.singleClick,
                  child: Icon(
                    Entypo.attach,
                    color: DynamicColors.primaryColorLight,
                  ),
                ),
              ),
            ),
            Expanded(
                child: CustomTextField(
              isUnderLineBorder: false,
              radius: 3,
              controller: controller.messageEditingController,
              hint: "Start Writing",
              hintStyle: poppinsRegular(color: DynamicColors.primaryColorLight.withOpacity(0.5)),
              prefixIcon: GestureDetector(
                onTap: () {
                  controller.imgFromCamera();
                },
                child: Icon(
                  Icons.camera_alt,
                  color: DynamicColors.primaryColor,
                ),
              ),
              onChanged: _onChangeHandler,
              suffixIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                child: InkWell(
                  onTap: () {
                    if (isMessage == false) {
                      isMessage = true;
                      Future.delayed(Duration(seconds: 1), () {
                        isMessage = false;
                      });
                      if (controller.messageEditingController.text.isNotEmpty) {
                        controller.messageEditingController.text =
                            inputFormatter(
                                controller.messageEditingController.text);
                      }
                      if (controller
                          .messageEditingController.text.isNotEmpty || controller.imageFile.isNotEmpty) {
                        controller.type = "message";
                        controller.sendMessage(id: controller.inboxId);
                      } else {
                        BotToast.showText(text: "Message is empty");
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Color(0xFF343434)),
                    child: Icon(
                      FontAwesome5.paper_plane,
                      color: DynamicColors.primaryColorLight,
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
