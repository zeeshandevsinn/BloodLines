// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:bloodlines/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloodlines/View/Chat/controller/chatController.dart';
import 'package:bloodlines/View/Chat/model/chatModel.dart';
import 'package:bloodlines/View/Chat/view/messageTile.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:intl/intl.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:swipe_to/swipe_to.dart';


class MessageWidgetClass extends StatelessWidget {
  MessageWidgetClass({super.key,required this.index,required this.isUserDeleted,required this.chatMessageItem});
  final ChatController controller = Get.find();
  int index;
  bool isUserDeleted;
  ChatMessageItem chatMessageItem;


  Offset? _tapDownPosition;
  _onLongPress(context, index, element) {
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      color: Colors.transparent,
      useRootNavigator: true,
      //onSelected: () => setState(() => imageList.remove(index))
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: index,
          padding: EdgeInsets.zero,
          child: controller.chatTilePopUp(element, context, index),
        )
      ],
      context: context,
      position: RelativeRect.fromLTRB(
        _tapDownPosition!.dx,
        _tapDownPosition!.dy,
        overlay.size.width - _tapDownPosition!.dx,
        overlay.size.height - _tapDownPosition!.dy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (chatMessageItem.user == null) return Container();
    UserModel user = UserModel.fromJson(jsonDecode(chatMessageItem.user!));
    if (chatMessageItem.isDeleted == 1) {
      return Container();
    }
    if( chatMessageItem.isFlag == 1 && chatMessageItem.receiverId == Api.singleton.sp.read("id")){
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: isUserDeleted == true?
      messageWidgetDeletedUser(context)
          : user.isBlock == false && user.blockBy == false
          ? SwipeTo(
        onRightSwipe: (details) {
          if (controller.replyModel == null) {
            controller.isReplying(true);
            // controller.update();
          }
          controller.replyModel =
          controller.chatModel!.data!.items![index];
          controller.replyId =
              controller.chatModel!.data!.items![index].id.toString();
          controller.fieldUpdate(!controller.fieldUpdate.value);
          controller.update();
        },
        child: messageWidgetDeletedUser(context),
      )
          : messageWidgetDeletedUser(context),
    );
  }

  GestureDetector messageWidgetDeletedUser(BuildContext context) {
    return GestureDetector(
        onTapDown: (TapDownDetails details) {
          _tapDownPosition = details.globalPosition;
        },
        onLongPress: () {
          _onLongPress(context, index, chatMessageItem);
        },
        child: MessageTile(
          chatMessageItem: chatMessageItem,
          index: index,
        ),
      );
  }
}


class StickyListViewClass extends StatelessWidget {
  StickyListViewClass({super.key,required this.list,required this.isUserDeleted});

  final ChatController controller = Get.find();
  final List<ChatMessageItem> list;
  final bool isUserDeleted;
  @override
  Widget build(BuildContext context) {
    return StickyGroupedListView<ChatMessageItem,
        DateTime>(
        shrinkWrap: false,
        elements: list,
        itemScrollController:
        controller.scrollController,
        itemPositionsListener:
        controller.itemPositionsListener,
        padding:
        EdgeInsets.only(bottom: kToolbarHeight + 5),
        // physics: NeverScrollableScrollPhysics(),
        reverse: true,
        groupBy: (ChatMessageItem element) {
          var dates = DateTime.parse(element.createdAt!)
              .toLocal();
          return DateTime(
            dates.year,
            dates.month,
            dates.day,
          );
        },
        itemComparator: (element1, element2) =>
            DateTime.parse(element2.createdAt!)
                .toLocal()
                .compareTo(
                DateTime.parse(element1.createdAt!)
                    .toLocal()),
        stickyHeaderBackgroundColor:
        DynamicColors.accentColor,
        floatingHeader: false,
        groupComparator: (item1, item2) =>
            item2.compareTo(item1),
        groupSeparatorBuilder:
            (ChatMessageItem element) {
          DateTime dates =
          DateTime.parse(element.createdAt!)
              .toLocal();
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    child: Divider(
                      height: 3,
                      color: DynamicColors.textColor,
                    )),
                Expanded(
                  child: Text(
                    DateFormat.yMMMd()
                        .format(dates)
                        .toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: DynamicColors.primaryColor,
                    ),
                  ),
                ),
                Expanded(
                    child: Divider(
                      height: 3,
                      color: DynamicColors.textColor,
                    )),
              ],
            ),
          );
        },
        addSemanticIndexes: true,
        indexedItemBuilder:
            (context, chatMessageItem, index) {
          controller.seenMessageSocket(
              chatMessageItem.inboxId, index);
          if (chatMessageItem.deleteBy ==
              Api.singleton.sp.read("id")) {
            return Container();
          }
          return Stack(
            children: [
              controller.selectedIndex == index
                  ? Obx(() {
                return AnimatedOpacity(
                  // If the widget is visible, animate to 0.0 (invisible).
                  // If the widget is hidden, animate to 1.0 (fully visible).
                  opacity: controller
                      .animatedOpacity
                      .value ==
                      true
                      ? 1.0
                      : 0.0,
                  duration: const Duration(
                      milliseconds: 1500),
                  child: Container(
                      decoration: BoxDecoration(
                        color: controller
                            .selectedIndex ==
                            index
                            ? DynamicColors
                            .primaryColor
                            : Colors.transparent,
                      ),
                      child: MessageWidgetClass(
                          isUserDeleted:isUserDeleted,
                          index: index,
                          chatMessageItem:chatMessageItem)),
                );
              })
                  : SizedBox.shrink(),
              MessageWidgetClass(
                  index: index,
                  isUserDeleted:isUserDeleted,
                  chatMessageItem:chatMessageItem)
            ],
          );
          // return _messageWidget(
          //     controller, index, chatMessageItem);
        });
  }
}


class OnlineWidget extends StatelessWidget {
  const OnlineWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Online",
          style: poppinsSemiBold(color: DynamicColors.textColor, fontSize: 13),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          width: 10,
          height: 10,
          decoration:
          BoxDecoration(shape: BoxShape.circle, color: Colors.green),
        )
      ],
    );
  }
}
