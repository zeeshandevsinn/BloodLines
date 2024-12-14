// To parse this JSON data, do
//
//     final followModel = followModelFromJson(jsonString);

import 'dart:convert';

import 'package:bloodlines/userModel.dart';

FollowModel followModelFromJson(String str) => FollowModel.fromJson(json.decode(str));

String followModelToJson(FollowModel data) => json.encode(data.toJson());

class FollowModel {
  bool? success;
  List<FollowData>? data;
  String? message;

  FollowModel({
    this.success,
    this.data,
    this.message,
  });

  factory FollowModel.fromJson(Map<String, dynamic> json) => FollowModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<FollowData>.from(json["data"]!.map((x) => FollowData.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}
class TaggedUserModel {
  bool? success;
  List<UserModel>? data;
  String? message;

  TaggedUserModel({
    this.success,
    this.data,
    this.message,
  });

  factory TaggedUserModel.fromJson(Map<String, dynamic> json) => TaggedUserModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<UserModel>.from(json["data"]!.map((x) => UserModel.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class FollowData {
  int? id;
  int? userId;
  int? followingId;
  int? followerId;
  bool? isFollowing;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? users;

  FollowData({
    this.id,
    this.userId,
    this.isFollowing,
    this.followingId,
    this.followerId,
    this.createdAt,
    this.updatedAt,
    this.users,
  });

  factory FollowData.fromJson(Map<String, dynamic> json) => FollowData(
    id: json["id"],
    userId: json["user_id"],
    followingId: json["following_id"],
    followerId: json["follower_id"],
    isFollowing: json["is_following"] == null || json["is_following"] == 0?false:true,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    users: json["users"] == null ? null : UserModel.fromJson(json["users"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "following_id": followingId,
    "follower_id": followerId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "users": users?.toJson(),
  };
}



class RequestModel {
  bool? success;
  List<RequestData>? data;
  String? message;

  RequestModel({
    this.success,
    this.data,
    this.message,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<RequestData>.from(json["data"]!.map((x) => RequestData.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class RequestData {
  int? id;
  int? receiverId;
  int? senderId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? users;

  RequestData({
    this.id,
    this.receiverId,
    this.status,
    this.senderId,
    this.createdAt,
    this.updatedAt,
    this.users,
  });

  factory RequestData.fromJson(Map<String, dynamic> json) => RequestData(
    id: json["id"],
    receiverId: json["receiver_id"],
    senderId: json["sender_id"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    users: json["sender"] == null ? null : UserModel.fromJson(json["sender"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "following_id": receiverId,
    "follower_id": senderId,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "users": users?.toJson(),
  };
}


