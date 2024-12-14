import 'package:flutter/material.dart';
import 'package:bloodlines/View/Chat/model/chatModel.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Network/API.dart';

class ReplyMessageWidget extends StatelessWidget {
  final Widget? child;
  final bool? isText;
  final bool? fromReply;
  final bool? sender;
  final GestureTapCallback? onCancelReply;
  final dynamic chatMessageItem;

  ReplyMessageWidget({
    this.onCancelReply,
    this.chatMessageItem,
    this.child,
    this.fromReply = false,
    this.sender = false,
    this.isText = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        // width: fromReply == false ? null : 50,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(18),
            topLeft: Radius.circular(18),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: sender == true
                  ? Colors.black45
                  : DynamicColors.primaryColor
                      .withOpacity(fromReply == true ? 0.5 : 1),
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize:
                    isText == false ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 3,
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.green,
                      width: 5,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(flex: 20, child: buildReplyMessage()),
                ],
              ),
            ),
          ),
        ),
      );

  Widget buildReplyMessage() => onCancelReply != null
      ? Container(
          color: Colors.black54,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                          onTap: onCancelReply,
                          child:
                              Icon(Icons.close, color: Colors.white, size: 16)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 2),
              child!
            ],
          ),
        )
      : child!;
}
