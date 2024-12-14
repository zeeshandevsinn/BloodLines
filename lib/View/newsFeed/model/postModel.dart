// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'package:bloodlines/View/Groups/Model/groupModel.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:bloodlines/View/newsFeed/model/eventsModel.dart';
import 'package:bloodlines/View/newsFeed/model/postMedia.dart';
import 'package:bloodlines/userModel.dart';
import 'package:get/get.dart';

class Posts {
  Posts({
    this.currentPage,
    this.postModel,
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

  int? currentPage;
  List<PostModel>? postModel;
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

  factory Posts.fromJson(Map<String, dynamic> json,) => Posts(
        currentPage: json["current_page"],
        postModel: json["data"] == null
            ? []
            : List<PostModel>.from(
                json["data"]!.map((x) => PostModel.fromJson(x))),
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
        "data": postModel == null
            ? []
            : List<dynamic>.from(postModel!.map((x) => x.toJson())),
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

class PostModel {
  PostModel({
    this.id,
    this.userId,
    this.user,
    this.tag,
    this.content,
    this.backgroundColor,
    this.postActivityType,
    this.postActivity,
    this.location,
    this.audience,
    this.postType,
    this.parentPost,
    this.group,
    this.media,
    this.totalLikes,
    this.isLike,
    this.commentsCount,
    this.comments,
    this.parentId,
    this.isFriend,
    this.eventsPost,
    this.link,
    this.isReported,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  UserModel? user;
  Tag? tag;
  String? content;
  String? backgroundColor;
  dynamic postActivityType;
  dynamic postActivity;
  PostLocation? location;
  EventsData? eventsPost;
  String? audience;
  String? postType;
  PostModel? parentPost;
  GroupData? group;
  List<PostMedia>? media;
  RxInt? totalLikes;
  int? parentId;
  RxBool? isLike;
  RxInt? commentsCount;
  dynamic comments;
  String? isFriend;
  String? link;
  int? status;
  int? isReported;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        userId: json["user_id"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        tag: json["tag"] == null ? null : Tag.fromJson(json["tag"]),
        content: json["content"],
        backgroundColor: json["background_color"] ?? "0",
        postActivityType: json["post_activity_type"],
        postActivity: json["post_activity"],
        location: json["location"] == null
            ? null
            : PostLocation.fromJson(json["location"]),
        parentPost: json["parent_post"] == null
            ? null
            : PostModel.fromJson(json["parent_post"]),
        group: json["group"] == null ? null : GroupData.fromJson(json["group"]),
        audience: json["audience"],
        postType: json["post_type"],
        media: json["media"] == null
            ? []
            : List<PostMedia>.from(
                json["media"]!.map((x) => PostMedia.fromJson(x))),
        isLike: json["is_like"] == 0 ? false.obs : true.obs,
        totalLikes: int.parse(json["total_likes"].toString()).obs,
        commentsCount: json["comments_count"] == null
            ? 0.obs
            : int.parse(json["comments_count"].toString()).obs,
        comments: json["comments"],
        parentId: json["parent_id"] ?? 0,
    isReported: json["is_reported"] ?? 0,
        isFriend: json["is_friend"],
        link: json["link"],
    eventsPost: json["event_post"] == null? null:EventsData.fromJson(json["event_post"]),
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
        "user_id": userId,
        "user": user?.toJson(),
        "tag": tag,
        "content": content,
        "background_color": backgroundColor,
        "post_activity_type": postActivityType,
        "post_activity": postActivity,
        "location": location?.toJson(),
        "parent_post": parentPost?.toJson(),
        "group": group?.toJson(),
        "audience": audience,
        "post_type": postType,
        "media": media,
        "total_likes": totalLikes,
        "is_like": isLike,
        "comments_count": commentsCount,
        "comments": comments,
        "is_friend": isFriend,
        "link": link,
        "parent_id": parentId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class PostLocation {
  PostLocation({
    this.address,
    this.latitude,
    this.longitude,
  });

  dynamic address;
  dynamic latitude;
  dynamic longitude;

  factory PostLocation.fromJson(Map<String, dynamic> json) => PostLocation(
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class Tag {
  List<UserModel>? people;
  List<PedigreeSearchData>? pedigrees;

  Tag({
    this.people,
    this.pedigrees,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        people: json["people"] == null
            ? []
            : List<UserModel>.from(
                json["people"]!.map((x) => UserModel.fromJson(x))),
    pedigrees: json["pedigree"] == null
            ? []
            : List<PedigreeSearchData>.from(
                json["pedigree"]!.map((x) => PedigreeSearchData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "people": people == null
            ? []
            : List<dynamic>.from(people!.map((x) => x.toJson())),
        "pedigree": pedigrees == null
            ? []
            : List<dynamic>.from(pedigrees!.map((x) => x.toJson())),
      };
}
