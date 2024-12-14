// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/View/newsFeed/model/postMedia.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/userModel.dart';
import 'package:get/get.dart';

CommentModel commentModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  CommentModel({
    this.success,
    this.results,
    this.message,
  });

  bool? success;
  CommentPaginatedData? results;
  String? message;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        success: json["success"],
        results:  CommentPaginatedData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": results,
        "message": message,
      };
}


class CommentPaginatedData {
  int? currentPage;
  List<CommentData>? data;
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

  CommentPaginatedData({
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

  factory CommentPaginatedData.fromJson(Map<String, dynamic> json) => CommentPaginatedData(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<CommentData>.from(json["data"]!.map((x) => CommentData.fromJson(x))),
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
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
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


class CommentData {
  CommentData({
    this.id,
    this.userId,
    this.postId,
    this.isReported,
    this.postType,
    this.comment,
    this.media,
    this.parentId,
    this.isLike,
    this.createdAt,
    this.updatedAt,
    this.totalLikes,
    this.user,
    this.reply,
    this.likes,
  });

  int? id;
  int? userId;
  int? postId;
  int? isReported;
  String? postType;
  String? comment;
  String? media;
  int? parentId;
  RxBool? isLike;
  DateTime? createdAt;
  DateTime? updatedAt;
  RxInt? totalLikes;
  UserModel? user;
  List<CommentData>? reply;
  RxList<Like>? likes;

  factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
        id: json["id"],
        userId: json["user_id"],
        postId: json["post_id"],
    isReported: json["is_reported"],
        postType: json["post_type"],
        comment: json["comment"],
        media: json["media"] == null ? null : imageUrl + json["media"],
        parentId: json["parent_id"]??0,
        isLike: json["is_like"] == 0 ? false.obs : true.obs,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        totalLikes: json["total_likes"] == null
            ? 0.obs
            : int.parse(json["total_likes"].toString()).obs,
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        reply: json["reply"] == null
            ? []
            : List<CommentData>.from(
                json["reply"]!.map((x) => CommentData.fromJson(x))),
        likes: json["likes"] == null
            ? <Like>[].obs
            : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))).obs,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "post_id": postId,
        "post_type": postType,
        "comment": comment,
        "media": media,
        "parent_id": parentId,
        "is_like": isLike,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "total_likes": totalLikes,
        "user": user?.toJson(),
        "reply": reply == null
            ? []
            : List<dynamic>.from(reply!.map((x) => x.toJson())),
        "likes": likes == null
            ? []
            : List<dynamic>.from(likes!.map((x) => x.toJson())),
      };
}

class Like {
  Like({
    this.id,
    this.commentId,
    this.reaction,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  int? commentId;
  String? reaction;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? user;

  factory Like.fromJson(Map<String, dynamic> json) => Like(
        id: json["id"],
        commentId: json["comment_id"],
        reaction: json["reaction"],
        userId: json["user_id"],
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
        "comment_id": commentId,
        "reaction": reaction,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}
