// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'package:bloodlines/Components/Dummy.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/View/Forum/Model/forumDetailsModel.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:get/get.dart';

class UserModel {
  UserModel({
    this.id,
    this.username,
    this.isReported,
    this.email,
    this.isUserDeleted,
    this.emailVerifiedAt,
    this.stripeId,
    this.profileStatus,
    this.userStatus,
    this.createdAt,
    this.updatedAt,
    this.followersCount,
    this.followingCount,
    this.isFriend,
    this.typing,
    this.profile,
    this.gallery,
    this.topic,
    this.blockBy,
    this.isBlock,
    this.isTagSelected,
    this.forums,
    this.posts,
  });

  int? id;
  String? username;
  String? email;
  int? isReported;
  int? isUserDeleted;
  dynamic emailVerifiedAt;
  String? stripeId;
  String? profileStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  RxBool? typing;
  int? followersCount;
  int? followingCount;
  RxString? isFriend;
  RxBool? isTagSelected;
  RxBool? userStatus;
  Profile? profile;
  bool? blockBy;
  bool? isBlock;
  List<Gallery>? gallery;
  List<ForumDetailsData>? topic;
  List<ForumDetailsData>? forums;
  List<PostElement>? posts;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        isReported: json["is_reported"],
        isUserDeleted: json["is_user_deleted"]??0,
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        stripeId: json["stripe_id"],
        blockBy: json["block_by"] ?? false,
        isBlock: json["is_block"] ?? false,
        typing: false.obs,
        userStatus: false.obs,
        profileStatus: json["profile_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        followersCount: json["followers_count"],
        followingCount: json["following_count"],
        isTagSelected: false.obs,
        isFriend: json["is_friend"].toString().obs,
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
        gallery: json["gallery"] == null
            ? []
            : List<Gallery>.from(
                json["gallery"]!.map((x) => Gallery.fromJson(x))),
        topic: json["topic"] == null
            ? []
            : List<ForumDetailsData>.from(
                json["topic"]!.map((x) => ForumDetailsData.fromJson(x))),
        forums: json["forums"] == null
            ? []
            : List<ForumDetailsData>.from(
                json["forums"]!.map((x) => ForumDetailsData.fromJson(x))),
        posts: json["posts"] == null
            ? []
            : List<PostElement>.from(
                json["posts"]!.map((x) => PostElement.fromJson(x))),
      );

  factory UserModel.fromDeleted() => UserModel(
      id: 0,
      username: "",
      isReported: 0,
      email: "",
      emailVerifiedAt: "",
      stripeId: "",
      blockBy: false,
      isBlock: false,
      typing: false.obs,
      userStatus: false.obs,
      isTagSelected: false.obs,
      createdAt: DateTime.now(),
      profile: Profile.deletedProfile());

  factory UserModel.fromEmpty() => UserModel(
        id: 0,
        username: "",
        email: "",
        emailVerifiedAt: "",
        stripeId: "",
        isReported: 0,
        blockBy: false,
        isBlock: false,
        typing: false.obs,
        userStatus: false.obs,
        profileStatus: "",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        followersCount: 0,
        followingCount: 0,
        isTagSelected: false.obs,
        isFriend: "".obs,
        profile: Profile(),
        gallery: [],
        topic: [],
        forums: [],
        posts: [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "is_reported": isReported,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "stripe_id": stripeId,
        "profile_status": profileStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "followers_count": followersCount,
        "following_count": followingCount,
        "is_block": isBlock,
        "block_by": blockBy,
        "is_user_deleted": isUserDeleted,
        "is_friend": isFriend!.value,
        "profile": profile?.toJson(),
        "gallery": gallery == null
            ? []
            : List<dynamic>.from(gallery!.map((x) => x.toJson())),
        "topic": topic == null ? [] : List<dynamic>.from(topic!.map((x) => x)),
        // "posts": posts == null ? [] : List<dynamic>.from(posts!.map((x) => x)),
      };
}

class Gallery {
  Gallery({
    this.id,
    this.userId,
    this.photo,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? photo;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
        id: json["id"],
        userId: json["user_id"],
        photo: json["photo"].toString().contains("http")
            ? json["photo"]
            : imageUrl + json["photo"],
        description: json["description"],
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
        "photo": photo,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Profile {
  Profile({
    this.id,
    this.userId,
    this.coverImage,
    this.profileImage,
    this.about,
    this.fullname,
    this.phone,
    this.age,
    this.gender,
    this.city,
    this.country,
    this.state,
    this.zipcode,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? coverImage;
  String? profileImage;
  String? about;
  String? fullname;
  String? phone;
  String? age;
  String? gender;
  String? city;
  String? country;
  String? state;
  String? zipcode;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        userId: json["user_id"],
        coverImage: json["cover_image"].toString().contains("http")
            ? json["cover_image"]
            : imageUrl + json["cover_image"],
        profileImage: json["profile_image"].toString().contains("http")
            ? json["profile_image"]
            : imageUrl + json["profile_image"],
        about: json["about"],
        fullname: json["fullname"],
        phone: json["phone"],
        age: json["age"],
        country: json["country"],
        state: json["state"],
        gender: json["gender"],
        city: json["city"],
        zipcode: json["zipcode"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
  factory Profile.deletedProfile() => Profile(
        coverImage: dummyProfile,
        profileImage: dummyProfile,
        fullname: "Deleted User",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "cover_image": coverImage,
        "profile_image": profileImage,
        "about": about,
        "fullname": fullname,
        "phone": phone,
        "age": age,
        "gender": gender,
        "city": city,
        "country": country,
        "state": state,
        "zipcode": zipcode,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class PostElement {
  int? id;
  int? userId;
  PostModel? post;

  PostElement({
    this.id,
    this.userId,
    this.post,
  });

  factory PostElement.fromJson(Map<String, dynamic> json) => PostElement(
        id: json["id"],
        userId: json["user_id"],
        post: json["post"] == null ? null : PostModel.fromJson(json["post"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "post": post?.toJson(),
      };
}
