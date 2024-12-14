// To parse this JSON data, do
//
//     final classifiedCategoriesModel = classifiedCategoriesModelFromJson(jsonString);

import 'dart:convert';

import 'package:bloodlines/Components/Network/API.dart';

ClassifiedCategoriesModel classifiedCategoriesModelFromJson(String str) => ClassifiedCategoriesModel.fromJson(json.decode(str));

String classifiedCategoriesModelToJson(ClassifiedCategoriesModel data) => json.encode(data.toJson());

class ClassifiedCategoriesModel {
  bool? success;
  List<ClassifiedCategoriesData>? data;
  String? message;

  ClassifiedCategoriesModel({
    this.success,
    this.data,
    this.message,
  });

  factory ClassifiedCategoriesModel.fromJson(Map<String, dynamic> json) => ClassifiedCategoriesModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<ClassifiedCategoriesData>.from(json["data"]!.map((x) => ClassifiedCategoriesData.fromJson(x)))..sort((a,b)=>a.id!.compareTo(b.id!)),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class ClassifiedCategoriesData {
  int? id;
  String? title;
  String? image;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? classifiedsCount;

  ClassifiedCategoriesData({
    this.id,
    this.title,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.classifiedsCount,
  });

  factory ClassifiedCategoriesData.fromJson(Map<String, dynamic> json) => ClassifiedCategoriesData(
    id: json["id"],
    title: json["title"],
    image: json["image"].toString().contains("http")
      ? json["image"]
      : imageUrl + json["image"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    classifiedsCount: json["classifieds_count"]??0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "classifieds_count": classifiedsCount,
  };
}
