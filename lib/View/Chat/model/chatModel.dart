// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';
import 'dart:convert' as j;

import 'package:bloodlines/View/Chat/model/mediaClass.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/userModel.dart';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  bool? status;
  ChatData? data;
  String? message;

  ChatModel({
    this.status,
    this.data,
    this.message,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    status: json["status"],
    data: json["data"] == null ? null : ChatData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
  };
}

class ChatData {
  int? currentPage;
  List<ChatMessageItem>? items;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  ChatData({
    this.currentPage,
    this.items,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
    currentPage: json["current_page"],
    items: json["data"] == null ? [] : List<ChatMessageItem>.from(json["data"]!.map((x) => ChatMessageItem.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class ChatMessageItem {
  int? id;
  int? senderId;
  int? receiverId;
  int? parentId;
  String? inboxId;
  String? message;
  String? media;
  String? fileType;
  int? deleteBy;
  int? isFlag;
  int? isDeleted;
  int? isSeen;
  String? createdAt;
  String? updatedAt;
  int? isUserDeleted;
  String? user;
  String? reply;

  ChatMessageItem({
    this.id,
    this.senderId,
    this.receiverId,
    this.parentId,
    this.inboxId,
    this.message,
    this.media,
    this.fileType,
    this.deleteBy,
    this.isDeleted,
    this.isFlag,
    this.isSeen,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.reply,
    this.isUserDeleted,
  });

  factory ChatMessageItem.fromJson(Map<String, dynamic> json) => ChatMessageItem(
    id: json["id"],
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    parentId: json["parent_id"],
    isUserDeleted: json["is_user_deleted"]??0,
    inboxId: json["conversation_id"],
    message: json["message"]??"",
    media: json["media"] == null
        ? null
        : json["media"] == "null"
        ? null
        : json["media"] is String
        ? j.json.encode(List<MediaClass>.from(j.json
        .decode(json["media"])
        .map((x) => MediaClass.fromJson(x))))
        : j.json.encode(List<MediaClass>.from(j.json
        .decode(j.json.encode(json["media"]))
        .map((x) => MediaClass.fromJson(x)))),
    fileType: json["file_type"],
    deleteBy: json["delete_by"],
    isDeleted: json["is_deleted"],
    isFlag: json["is_flagged"],
    isSeen: json["is_seen"],
    createdAt: json["created_at"]??DateTime.now().toLocal().toIso8601String(),
    updatedAt: json["updated_at"],
    user: json["user"] == null ? null : jsonEncode(json["user"]),
    reply: json["parent_chat"] == null? null:jsonEncode(ChatMessageItem.fromJson(json["parent_chat"])),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender_id": senderId,
    "receiver_id": receiverId,
    "parent_id": parentId,
    "conversation_id": inboxId,
    "message": message,
    "media": media,

    "file_type": fileType,
    "delete_by": deleteBy,
    "is_deleted": isDeleted,
    "is_flagged": isFlag,
    "is_seen": isSeen,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user": user,
    "parent_chat": reply,
    "is_user_deleted": isUserDeleted,
  };
}


