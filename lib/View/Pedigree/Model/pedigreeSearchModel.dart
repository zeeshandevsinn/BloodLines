// To parse this JSON data, do
//
//     final pedigreeSearchModel = pedigreeSearchModelFromJson(jsonString);

import 'dart:convert';

import 'package:bloodlines/Components/Dummy.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/View/Classified/View/classified.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/userModel.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

PedigreeSearchModel pedigreeSearchModelFromJson(String str) => PedigreeSearchModel.fromJson(json.decode(str));

String pedigreeSearchModelToJson(PedigreeSearchModel data) => json.encode(data.toJson());

class PedigreeModel {
  bool? success;
  List<PedigreeSearchData>? data;
  String? message;

  PedigreeModel({
    this.success,
    this.data,
    this.message,
  });

  factory PedigreeModel.fromJson(Map<String, dynamic> json) => PedigreeModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<PedigreeSearchData>.from(json["data"]!.map((x) => PedigreeSearchData.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}
class SinglePedigreeModel {
  bool? success;
  PedigreeSearchData? data;
  String? message;

  SinglePedigreeModel({
    this.success,
    this.data,
    this.message,
  });

  factory SinglePedigreeModel.fromJson(Map<String, dynamic> json) => SinglePedigreeModel(
    success: json["success"],
    data: json["data"] == null ?null : PedigreeSearchData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };
}


class PedigreeSearchModel {
  int? currentPage;
  List<PedigreeSearchData>? data;
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

  PedigreeSearchModel({
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

  factory PedigreeSearchModel.fromJson(Map<String, dynamic> json) => PedigreeSearchModel(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<PedigreeSearchData>.from(json["data"]!.map((x) => PedigreeSearchData.fromJson(x))),
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

class PedigreeSearchData {
  int? id;
  int? parentId;
  String? ownerName;
  String? beforeNameTitle;
  String? dogName;
  String? afterNameTitle;
  String? fullName;
  String? sex;
  DateTime? dob;
  String? color;
  RxBool? isSelected;
  RxBool? isTagSelected;
  String? weight;
  String? brief;
  int? damId;
  int? sireId;
  int? createrId;
  UserModel? creator;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<PedigreePhotos>? photos;
  PedigreeSearchData? dam;
  PedigreeSearchData? sire;

  PedigreeSearchData({
    this.id,
    this.parentId,
    this.ownerName,
    this.beforeNameTitle,
    this.dogName,
    this.afterNameTitle,
    this.sex,
    this.dob,
    this.color,
    this.isSelected,
    this.isTagSelected,
    this.weight,
    this.photos,
    this.brief,
    this.fullName,
    this.damId,
    this.sireId,
    this.createrId,
    this.creator,
    this.createdAt,
    this.updatedAt,
    this.dam,
    this.sire,
  });

  factory PedigreeSearchData.fromJson(Map<String, dynamic> json, {int? parentIdPedigree}) => PedigreeSearchData(
    id: json["id"],
    parentId: parentIdPedigree,
    ownerName: json["owner_name"],
    beforeNameTitle: json["before_name_title"],
    dogName: json["dog_name"],
    afterNameTitle: json["after_name_title"],
    fullName: json["full_name"]??"",
    sex: json["sex"],
    isSelected: false.obs,
    isTagSelected: false.obs,
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    color: json["color"],
    weight: json["weight"],
    photos: json["photos"] == null ? [] : List<PedigreePhotos>.from(json["photos"]!.map((x) => PedigreePhotos.fromJson(x))),

    brief: json["brief"],
    damId: json["dam_id"],
    sireId: json["sire_id"],
    dam: json["dam"] == null ? null : PedigreeSearchData.fromJson(json["dam"],parentIdPedigree: json["id"]),
    sire: json["sire"] == null ? null : PedigreeSearchData.fromJson(json["sire"],parentIdPedigree: json["id"]),
    createrId: json["creater_id"],
    creator: json["creater"] == null?null:UserModel.fromJson(json["creater"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "owner_name": ownerName,
    "before_name_title": beforeNameTitle,
    "dog_name": dogName,
    "after_name_title": afterNameTitle,
    "sex": sex,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "color": color,
    "weight": weight,
    "brief": brief,
    "dam_id": damId,
    "sire_id": sireId,
    "creater_id": createrId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class PedigreePhotos {
  int? id;
  int? pedigreeId;
  String? photo;
  String? type;
  XFile? localImage;
  DateTime? createdAt;
  DateTime? updatedAt;

  PedigreePhotos({
    this.id,
    this.pedigreeId,
    this.photo,
    this.localImage,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory PedigreePhotos.fromJson(Map<String, dynamic> json) => PedigreePhotos(
    id: json["id"],
    pedigreeId: json["padigree_id"],
    photo: json["photo"] == null?dummyProfile:json["photo"].toString().contains("http")
        ? json["photo"]
        : imageUrl + json["photo"],
    type: json["type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "padigree_id": pedigreeId,
    "photo": photo,
    "type": type,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
