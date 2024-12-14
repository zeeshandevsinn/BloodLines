// To parse this JSON data, do
//
//     final eventsModel = eventsModelFromJson(jsonString);

import 'dart:convert';

import 'package:bloodlines/Components/Dummy.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/userModel.dart';
import 'package:get/get.dart';

EventsModel eventsModelFromJson(String str) =>
    EventsModel.fromJson(json.decode(str));

String eventsModelToJson(EventsModel data) => json.encode(data.toJson());

class EventsModel {
  List<EventsData>? data;
  String? message;
  int? currentPage;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  EventsModel({
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

  factory EventsModel.fromJson(Map<String, dynamic> json) => EventsModel(
        data: json["data"] == null
            ? []
            : List<EventsData>.from(
                json["data"]!.map((x) => EventsData.fromJson(x))),
        currentPage: json["current_page"],
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

class EventsData {
  int? id;
  int? userId;
  int? isReported;
  String? cover;
  String? title;
  String? description;
  DateTime? eventDate;
  String? eventTime;
  String? location;
  String? latitude;
  RxString? eventStatus;
  String? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? membersGoing;
  int? membersInterested;
  UserModel? user;
  List<EventMembers>? eventMembers;

  EventsData({
    this.id,
    this.userId,
    this.isReported,
    this.cover,
    this.title,
    this.description,
    this.eventDate,
    this.eventTime,
    this.location,
    this.latitude,
    this.eventStatus,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.membersGoing,
    this.membersInterested,
    this.user,
    this.eventMembers,
  });

  factory EventsData.fromJson(Map<String, dynamic> json) => EventsData(
        id: json["id"],
        userId: json["user_id"],
    isReported: json["is_reported"],
        cover:json["cover"] == null?coverImage: json["cover"].toString().contains("http")
            ? json["cover"]
            : imageUrl + json["cover"],
        title: json["title"],
        description: json["description"],
        eventDate: json["event_date"] == null
            ? null
            : DateTime.parse(json["event_date"]),
        eventTime: json["event_time"],
        location: json["location"],
        latitude: json["latitude"],
    eventStatus: json["event_status"] == null? "not going".obs:json["event_status"].toString().obs,
        longitude: json["longitude"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        membersGoing: json["members_going"],
        membersInterested: json["members_interested"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        eventMembers: json["event_members"] == null
            ? []
            : List<EventMembers>.from(
                json["event_members"]!.map((x) => EventMembers.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "is_reported": isReported,
        "cover": cover,
        "title": title,
        "description": description,
        "event_date":
            "${eventDate!.year.toString().padLeft(4, '0')}-${eventDate!.month.toString().padLeft(2, '0')}-${eventDate!.day.toString().padLeft(2, '0')}",
        "event_time": eventTime,
        "location": location,
        "latitude": latitude,
        "event_status": eventStatus,
        "longitude": longitude,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "members_going": membersGoing,
        "members_interested": membersInterested,
        "user": user?.toJson(),
        "event_members": eventMembers == null
            ? []
            : List<dynamic>.from(eventMembers!.map((x) => x)),
      };
}

class EventMembers {
  int? id;
  int? eventId;
  int? userId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? user;

  EventMembers({
    this.id,
    this.eventId,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory EventMembers.fromJson(Map<String, dynamic> json) => EventMembers(
        id: json["id"],
        eventId: json["event_id"],
        userId: json["user_id"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "user_id": userId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}
