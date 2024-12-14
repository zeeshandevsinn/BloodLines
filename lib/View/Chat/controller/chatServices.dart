import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:bloodlines/View/Chat/model/chatModel.dart';
import 'package:bloodlines/View/Chat/model/inboxModel.dart';
import 'package:bloodlines/Components/Network/API.dart';

class InboxServices {
  Future<InboxModel> getInbox({fullUrl}) async {
    Response response = await Api.singleton.interceptorGet("get-inbox");
    return InboxModel.fromJson(response.data["data"]);
  }

  Future<ChatModel> getUserChat(int receiverID, {fullUrl}) async {
    Response response = await Api.singleton.get("user-chats",
        fullUrl: fullUrl, queryParameters: {"user_id": receiverID});
    return ChatModel.fromJson(response.data);
  }

  Future<ChatMessageItem?> sendMessage({
    String text = "",
    String? replyID,
    int? receiverId,
    String? type = "message",
    String? inboxId,
    List fileList = const [],
    String? messageType,
  }) async {
    ChatMessageItem? chat;
    var formData = FormData.fromMap({
      if (text.isNotEmpty) 'msg': text,
      if (replyID != null) 'parent_id': replyID,
      'receiver_id': receiverId,
      'media[]': fileList,
      'conversation_id': inboxId,
      // 'message_type': messageType,
    });
    var response = await Api.singleton.messagePost(formData, "send-message",
        inboxId: inboxId,
        multiPart: true,
        isProgressShow: fileList.isNotEmpty ? false : true);
    chat = ChatMessageItem.fromJson(response.data["data"]);
    return chat;
  }

  ChatMessageItem getLocalDbChat(final List<Map<String, dynamic>> maps, int i) {
    return ChatMessageItem(
      id: maps[i]["id"],
      senderId: maps[i]["sender_id"],
      receiverId: maps[i]["receiver_id"],
      parentId: maps[i]["parent_id"],
      inboxId: maps[i]["conversation_id"],
      message: maps[i]["message"],
      deleteBy: maps[i]["delete_by"],
      isSeen: maps[i]["receiver_id"] == Api.singleton.sp.read("id")
          ? 1
          : maps[i]["is_seen"] ?? 0,
      reply: maps[i]["parent_chat"],
      fileType: maps[i]["file_type"],
      isFlag: maps[i]["is_flagged"],
      isDeleted: maps[i]["is_deleted"],
      media: maps[i]["media"],
      createdAt: maps[i]["created_at"],
      updatedAt: maps[i]["updated_at"],
      user: maps[i]["user"],
    );
  }

  Future<ChatMessageItem?> sendVideoMessage({
    String text = "",
    String? replyID,
    int? receiverId,
    String? type = "message",
    String? inboxId,
    List fileList = const [],
    String? messageType,
  }) async {
    ChatMessageItem? chat;
    var formData = FormData.fromMap({
      'msg': text,
      'parent_id': replyID,
      'receiver_id': receiverId,
      'media[]': fileList,
      // 'file_type': type,
      'conversation_id': inboxId,
      // 'message_type': messageType,
    });
    var response = type == "video"
        ? await Api.singleton
            .messagePost(formData, "send-message",
                multiPart: true,
                isProgressShow: true,
                video: true,
                fromChat: true,
                inboxId: inboxId,
                rand: Random().nextInt(99999))
            .then((value) {
            chat = ChatMessageItem.fromJson(value.data["data"]);
          })
        : await Api.singleton.messagePost(formData, "send-message",
            inboxId: inboxId, multiPart: true, isProgressShow: true);
    if (type != "video") {
      chat = ChatMessageItem.fromJson(response.data["data"]);
      return chat;
    }
    print(chat);
    return chat;
  }

  ///Response

  Future<Response> clearChat({
    String inboxId = "",
  }) async {
    try {
      var formData = FormData.fromMap({
        'conversation_id': inboxId,
      });
      final response = await Api.singleton
          .post(formData, "clear-chat", isProgressShow: true);
      return response;
    } catch (e) {
      BotToast.showText(text: e.toString());
      throw Exception(e.toString());
    }
  }

  Future<Response> deleteInbox({
    String inboxId = "",
  }) async {
    try {
      var formData = FormData.fromMap({
        'conversation_id': inboxId,
      });
      final response = await Api.singleton.post(
        formData,
        "inbox-delete",
      );
      return response;
    } catch (e) {
      BotToast.showText(text: e.toString());
      throw Exception(e.toString());
    }
  }

  Future<Response> messageSeen({
    String inboxId = "",
  }) async {
    try {
      var formData = FormData.fromMap({
        'conversation_id': inboxId,
      });
      final response = await Api.singleton
          .post(formData, "all-message-seen", isProgressShow: true);
      return response;
    } catch (e) {
      BotToast.showText(text: e.toString());
      throw Exception(e.toString());
    }
  }
}
