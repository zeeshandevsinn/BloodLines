// To parse this JSON data, do
//
//     final classifiedAdModel = classifiedAdModelFromJson(jsonString);

import 'dart:convert';
import 'package:bloodlines/Components/Dummy.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/View/Classified/Model/categoryModel.dart';
import 'package:bloodlines/userModel.dart';
import 'package:image_picker/image_picker.dart';

ClassifiedAdModel classifiedAdModelFromJson(String str) => ClassifiedAdModel.fromJson(json.decode(str));

String classifiedAdModelToJson(ClassifiedAdModel data) => json.encode(data.toJson());

class ClassifiedAdModel {
  bool? success;
  List<ClassifiedAdData>? data;
  String? message;

  ClassifiedAdModel({
    this.success,
    this.data,
    this.message,
  });

  factory ClassifiedAdModel.fromJson(Map<String, dynamic> json) => ClassifiedAdModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<ClassifiedAdData>.from(json["data"]!.map((x) => ClassifiedAdData.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class ClassifiedAdData {
  int? id;
  int? categoryId;
  int? userId;
  String? title;
  String? description;
  String? price;
  String? status;
  String? location;
  String? latitude;
  String? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? user;
  ClassifiedCategoriesData? category;
  List<ClassifiedPhotos>? classifiedPhotos;

  ClassifiedAdData({
    this.id,
    this.categoryId,
    this.userId,
    this.title,
    this.description,
    this.price,
    this.status,
    this.location,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.category,
    this.classifiedPhotos,
  });

  factory ClassifiedAdData.fromJson(Map<String, dynamic> json) => ClassifiedAdData(
    id: json["id"],
    categoryId: json["category_id"],
    userId: json["user_id"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    status: json["status"],
    location: json["location"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
    category: json["category"] == null ? null : ClassifiedCategoriesData.fromJson(json["category"]),
    classifiedPhotos: json["gallery"] == null ? [] : List<ClassifiedPhotos>.from(json["gallery"]!.map((x) => ClassifiedPhotos.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "user_id": userId,
    "title": title,
    "description": description,
    "price": price,
    "location": location,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
    "category": category?.toJson(),
    "galley": classifiedPhotos,
  };
}

class ClassifiedPhotos {
  int? id;
  int? classifiedId;
  String? photo;
  String? type;
  XFile? localImage;
  DateTime? createdAt;
  DateTime? updatedAt;

  ClassifiedPhotos({
    this.id,
    this.classifiedId,
    this.photo,
    this.localImage,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory ClassifiedPhotos.fromJson(Map<String, dynamic> json) => ClassifiedPhotos(
    id: json["id"],
    classifiedId: json["classified_ad_id"],
    photo: json["cover"] == null?dummyProfile:json["cover"].toString().contains("http")
        ? json["cover"]
        : imageUrl + json["cover"],
    type: json["type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "classified_ad_id": classifiedId,
    "cover": photo,
    "type": type,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

