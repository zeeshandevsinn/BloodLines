// To parse this JSON data, do
//
//     final forumDetailsModel = forumDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:bloodlines/userModel.dart';
import 'package:get/get.dart';

ForumDetailsModel forumDetailsModelFromJson(String str) =>
    ForumDetailsModel.fromJson(json.decode(str));

String forumDetailsModelToJson(ForumDetailsModel data) =>
    json.encode(data.toJson());

class ForumDetailsModel {
  bool? success;
  ForumDetailsData? data;
  String? message;

  ForumDetailsModel({
    this.success,
    this.data,
    this.message,
  });

  factory ForumDetailsModel.fromJson(Map<String, dynamic> json) =>
      ForumDetailsModel(
        success: json["success"],
        data: json["data"] == null
            ? null
            : ForumDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class ForumDetailsData {
  int? id;
  int? categoryId;
  int? userId;
  int? isReported;
  String? title;
  String? content;
  String? media;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? responsesCount;
  Tag? tag;
  Category? category;
  UserModel? user;
  List<dynamic>? tags;
  List<ResponseData>? responses;

  ForumDetailsData({
    this.id,
    this.categoryId,
    this.userId,
    this.title,
    this.content,
    this.media,
    this.createdAt,
    this.isReported,
    this.updatedAt,
    this.responsesCount,
    this.tag,
    this.category,
    this.user,
    this.tags,
    this.responses,
  });

  factory ForumDetailsData.fromJson(Map<String, dynamic> json) =>
      ForumDetailsData(
        id: json["id"],
        categoryId: json["cateogry_id"],
        isReported: json["is_reported"],
        userId: json["user_id"],
        title: json["title"],
        content: json["content"],
        media: json["media"] == null ? null : imageUrl + json["media"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        responsesCount: json["responses_count"],
        tag: json["tag"] == null ? null : Tag.fromJson(json["tag"]),
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        tags: json["tags"] == null
            ? []
            : List<dynamic>.from(json["tags"]!.map((x) => x)),
        responses: json["responses"] == null
            ? []
            : List<ResponseData>.from(
                json["responses"]!.map((x) => ResponseData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cateogry_id": categoryId,
        "is_reported": isReported,
        "user_id": userId,
        "title": title,
        "content": content,
        "media": media,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "responses_count": responsesCount,
        "tag": tag,
        "category": category?.toJson(),
        "user": user?.toJson(),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "responses": responses == null
            ? []
            : List<dynamic>.from(responses!.map((x) => x)),
      };
}

class Category {
  int? id;
  String? title;
  String? image;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Category({
    this.id,
    this.title,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Tag {
  List<PedigreeSearchData> pedigree;
  List<UserModel> users;

  Tag({
    required this.pedigree,
    required this.users,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        pedigree: json["pedigree"] == null
            ? []
            : List<PedigreeSearchData>.from(
                json["pedigree"].map((x) => PedigreeSearchData.fromJson(x))),
        users: json["people"] == null
            ? []
            : List<UserModel>.from(
                json["people"].map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pedigree": List<dynamic>.from(pedigree.map((x) => x.toJson())),
        "people": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class ResponseData {
  int? id;
  int? topicId;
  int? userId;
  int? isReported;
  String? content;
  RxInt? isLike;
  DateTime? createdAt;
  DateTime? updatedAt;
  RxInt? totalLikes;
  Tag? tag;
  UserModel? user;
  List<dynamic>? tags;
  List<RespondLikes>? likes;
  List<ResponseComment>? comments;

  ResponseData({
    this.id,
    this.topicId,
    this.userId,
    this.isReported,
    this.content,
    this.isLike,
    this.createdAt,
    this.updatedAt,
    this.totalLikes,
    this.tag,
    this.user,
    this.tags,
    this.likes,
    this.comments,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        id: json["id"],
        topicId: json["topic_id"],
        userId: json["user_id"],
        content: json["content"],
    isReported: json["is_reported"] ?? 0,
        isLike: json["is_like"] == null
            ? 0.obs
            : int.parse(json["is_like"].toString()).obs,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        totalLikes: json["total_likes"] == null
            ? 0.obs
            : int.parse(json["total_likes"].toString()).obs,
        tag: json["tag"] == null ? null : Tag.fromJson(json["tag"]),
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        tags: json["tags"] == null
            ? []
            : List<dynamic>.from(json["tags"]!.map((x) => x)),
        likes: json["likes"] == null
            ? []
            : List<RespondLikes>.from(
                json["likes"]!.map((x) => RespondLikes.fromJson(x))),
        comments: json["comments"] == null
            ? []
            : List<ResponseComment>.from(
                json["comments"]!.map((x) => ResponseComment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "topic_id": topicId,
        "user_id": userId,
        "content": content,
        "is_like": isLike,
        "is_reported": isReported,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "total_likes": totalLikes,
        "tag": tag,
        "user": user?.toJson(),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "likes": likes == null ? [] : List<dynamic>.from(likes!.map((x) => x)),
        "comments":
            comments == null ? [] : List<dynamic>.from(comments!.map((x) => x)),
      };
}

class ResponseComment {
  int? id;
  int? userId;
  int? isReported;
  int? responseId;
  String? comment;
  dynamic media;
  int? parentId;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? user;
  List<dynamic>? reply;

  ResponseComment({
    this.id,
    this.userId,
    this.isReported,
    this.responseId,
    this.comment,
    this.media,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.reply,
  });

  factory ResponseComment.fromJson(Map<String, dynamic> json) =>
      ResponseComment(
        id: json["id"],
        userId: json["user_id"],
        responseId: json["response_id"],
        isReported: json["is_reported"],
        comment: json["comment"],
        media: json["media"],
        parentId: json["parent_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        reply: json["reply"] == null
            ? []
            : List<dynamic>.from(json["reply"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "is_reported": isReported,
        "response_id": responseId,
        "comment": comment,
        "media": media,
        "parent_id": parentId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "reply": reply == null ? [] : List<dynamic>.from(reply!.map((x) => x)),
      };
}

class RespondLikes {
  int? id;
  int? sourceId;
  String? reaction;
  String? sourceType;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  RespondLikes({
    this.id,
    this.sourceId,
    this.reaction,
    this.sourceType,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory RespondLikes.fromJson(Map<String, dynamic> json) => RespondLikes(
        id: json["id"],
        sourceId: json["source_id"],
        reaction: json["reaction"],
        sourceType: json["source_type"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "source_id": sourceId,
        "reaction": reaction,
        "source_type": sourceType,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
