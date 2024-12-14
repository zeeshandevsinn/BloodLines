// To parse this JSON data, do
//
//     final groupsModel = groupsModelFromJson(jsonString);

import 'dart:convert';

import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/userModel.dart';

GroupsModel groupsModelFromJson(String str) => GroupsModel.fromJson(json.decode(str));

String groupsModelToJson(GroupsModel data) => json.encode(data.toJson());

class GroupsModel {
  bool? success;
  List<GroupData>? data;
  String? message;

  GroupsModel({
    this.success,
    this.data,
    this.message,
  });

  factory GroupsModel.fromJson(Map<String, dynamic> json) => GroupsModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<GroupData>.from(json["data"]!.map((x) => GroupData.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class GroupData {
  int? id;
  int? userId;
  int? isReported;
  String? photo;
  String? name;
  String? description;
  String? type;
  String? charges;
  dynamic terms;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? groupMembersCount;
  String? isJoined;
  UserModel? user;
  List<GroupMember>? groupMembers;

  GroupData({
    this.id,
    this.userId,
    this.isReported,
    this.photo,
    this.name,
    this.description,
    this.type,
    this.charges,
    this.terms,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.groupMembersCount,
    this.isJoined,
    this.user,
    this.groupMembers,
  });

  factory GroupData.fromJson(Map<String, dynamic> json) => GroupData(
    id: json["id"],
    userId: json["user_id"],
    isReported: json["is_reported"],
    photo: json["photo"].toString().contains("http")
        ? json["photo"]
        : imageUrl + json["photo"],
    name: json["name"],
    description: json["description"],
    type: json["type"],
    charges: json["charges"],
    terms: json["terms"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    groupMembersCount: json["group_members_count"],
    isJoined: json["is_joined"]??"",
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
    groupMembers: json["group_members"] == null ? [] : List<GroupMember>.from(json["group_members"]!.map((x) => GroupMember.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "is_reported": isReported,
    "photo": photo,
    "name": name,
    "description": description,
    "type": type,
    "charges": charges,
    "terms": terms,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "group_members_count": groupMembersCount,
    "is_joined": isJoined,
    "user": user?.toJson(),
    "group_members": groupMembers == null ? [] : List<dynamic>.from(groupMembers!.map((x) => x.toJson())),
  };
}

class GroupMember {
  int? id;
  int? groupId;
  int? userId;
  String? status;
  dynamic createdAt;
  dynamic updatedAt;
  UserModel? user;
  GroupData? groupData;

  GroupMember({
    this.id,
    this.groupId,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.groupData,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
    id: json["id"],
    groupId: json["group_id"],
    userId: json["user_id"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
    groupData: json["group"] == null ? null : GroupData.fromJson(json["group"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "group_id": groupId,
    "user_id": userId,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user": user?.toJson(),
    "group": groupData?.toJson(),
  };
}


class GroupJoinedModel {
  bool? success;
  List<GroupJoined>? data;
  String? message;

  GroupJoinedModel({
    this.success,
    this.data,
    this.message,
  });

  factory GroupJoinedModel.fromJson(Map<String, dynamic> json) => GroupJoinedModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<GroupJoined>.from(json["data"]!.map((x) => GroupJoined.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class GroupJoined {
  int? id;
  int? groupId;
  int? userId;
  String? status;
  dynamic createdAt;
  dynamic updatedAt;
  GroupData? group;

  GroupJoined({
    this.id,
    this.groupId,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.group,
  });

  factory GroupJoined.fromJson(Map<String, dynamic> json) => GroupJoined(
    id: json["id"],
    groupId: json["group_id"],
    userId: json["user_id"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    group: json["group"] == null ? null : GroupData.fromJson(json["group"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "group_id": groupId,
    "user_id": userId,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "group": group?.toJson(),
  };
}

class GroupsInvitationModel {
  bool? success;
  List<GroupMember>? data;
  String? message;

  GroupsInvitationModel({
    this.success,
    this.data,
    this.message,
  });

  factory GroupsInvitationModel.fromJson(Map<String, dynamic> json) => GroupsInvitationModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<GroupMember>.from(json["data"]!.map((x) => GroupMember.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}
