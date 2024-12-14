// To parse this JSON data, do
//
//     final inboxModel = inboxModelFromJson(jsonString);

import 'package:bloodlines/View/Chat/model/mediaClass.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/userModel.dart';
import 'package:get/get.dart';

class InboxModel {
  int? currentPage;
  List<InboxData>? data;
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

  InboxModel({
    this.currentPage,
    this.data,
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

  factory InboxModel.fromJson(Map<String, dynamic> json) => InboxModel(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<InboxData>.from(
                json["data"]!.map((x) => InboxData.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class InboxData {
  InboxData({
    this.id,
    this.userId,
    this.addressId,
    this.createdAt,
    this.inboxId,
    this.updatedAt,
    this.typing,
    this.user,
    this.lastMessage,
    this.unseenMessage,
  });
  int? id;
  int? userId;
  int? addressId;
  String? inboxId;
  DateTime? createdAt;
  DateTime? updatedAt;
  LastMessage? lastMessage;
  RxBool? typing;
  UserModel? user;
  RxInt? unseenMessage;

  factory InboxData.fromJson(Map<String, dynamic> json) => InboxData(
        id: json["id"],
        userId: json["user_id"],
        addressId: json["addresser_id"],
        inboxId: json["conversation_id"],
        typing: false.obs,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null
            ? UserModel.fromDeleted()
            : UserModel.fromJson(json["user"]),
        lastMessage: json["last_message"] == null
            ? null
            : LastMessage.fromJson(json["last_message"]),
        unseenMessage: json["unseenmessages_count"] == null
            ? 0.obs
            : int.parse(json["unseenmessages_count"].toString()).obs,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "addresser_id": addressId,
        "conversation_id": inboxId,
        "last_message": lastMessage?.toJson(),
        "unseen_message": unseenMessage,
      };
}

class LastMessage {
  LastMessage({
    this.id,
    this.senderId,
    this.receiverId,
    this.parentId,
    this.inboxId,
    this.msg,
    this.media,
    this.fileType,
    this.postThumbnail,
    this.messageType,
    this.isDeleted,
    this.profileType,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.sender,
    this.isSeen,
  });

  int? id;
  int? senderId;
  int? receiverId;
  int? isSeen;
  dynamic parentId;
  String? inboxId;
  String? msg;
  List<MediaClass>? media;
  dynamic fileType;
  dynamic postThumbnail;
  String? messageType;
  int? isDeleted;
  String? profileType;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  UserModel? sender;

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        parentId: json["parent_id"],
        inboxId: json["conversation_id"],
        msg: json["message"],
        media: json["media"] == null
            ? []
            : List<MediaClass>.from(
                json["media"].map((x) => MediaClass.fromJson(x))),
        fileType: json["file_type"],
        postThumbnail: json["post_thumbnail"],
        messageType: json["message_type"],
        isDeleted: json["is_deleted"],
        profileType: json["profile_type"],
        isSeen: json["is_seen"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        sender:
            json["sender"] == null ? null : UserModel.fromJson(json["sender"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "parent_id": parentId,
        "conversation_id": inboxId,
        "message": msg,
        "media": media,
        "file_type": fileType,
        "post_thumbnail": postThumbnail,
        "message_type": messageType,
        "is_deleted": isDeleted,
        "profile_type": profileType,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "sender": sender?.toJson(),
      };
}
