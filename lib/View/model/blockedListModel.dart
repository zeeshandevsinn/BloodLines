// To parse this JSON data, do
//
//     final blockedListModel = blockedListModelFromJson(jsonString);

import 'dart:convert';

import 'package:bloodlines/userModel.dart';

BlockedListModel blockedListModelFromJson(String str) => BlockedListModel.fromJson(json.decode(str));

String blockedListModelToJson(BlockedListModel data) => json.encode(data.toJson());

class BlockedListModel {
  bool? success;
  List<BlockedListData>? data;
  String? message;

  BlockedListModel({
    this.success,
    this.data,
    this.message,
  });

  factory BlockedListModel.fromJson(Map<String, dynamic> json) => BlockedListModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<BlockedListData>.from(json["data"]!.map((x) => BlockedListData.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class BlockedListData {
  int? id;
  int? userId;
  int? blockId;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? user;

  BlockedListData({
    this.id,
    this.userId,
    this.blockId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory BlockedListData.fromJson(Map<String, dynamic> json) => BlockedListData(
    id: json["id"],
    userId: json["user_id"],
    blockId: json["block_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "block_id": blockId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
  };
}


