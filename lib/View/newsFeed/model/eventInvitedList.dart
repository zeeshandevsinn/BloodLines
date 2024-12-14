import 'package:bloodlines/userModel.dart';

class EventInvitedList {
  bool? success;
  List<UserModel>? data;

  EventInvitedList({
    this.success,
    this.data,
  });

  factory EventInvitedList.fromJson(Map<String, dynamic> json) => EventInvitedList(
    success: json["success"],
    data: json["data"] == null ? [] : List<UserModel>.from(json["data"]!.map((x) => UserModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
class GroupInvitedList {
  bool? success;
  List<UserModel>? data;

  GroupInvitedList({
    this.success,
    this.data,
  });

  factory GroupInvitedList.fromJson(Map<String, dynamic> json) => GroupInvitedList(
    success: json["success"],
    data: json["data"] == null ? [] : List<UserModel>.from(json["data"]!.map((x) => UserModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}