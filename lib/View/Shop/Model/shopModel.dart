// To parse this JSON data, do
//
//     final shopListModel = shopListModelFromJson(jsonString);

import 'dart:convert';

import 'package:bloodlines/Components/Network/API.dart';
import 'package:get/get.dart';

ShopListModel shopListModelFromJson(String str) => ShopListModel.fromJson(json.decode(str));

String shopListModelToJson(ShopListModel data) => json.encode(data.toJson());

class ShopListModel {
  bool? success;
  List<Category>? data;
  String? message;

  ShopListModel({
    this.success,
    this.data,
    this.message,
  });

  factory ShopListModel.fromJson(Map<String, dynamic> json) => ShopListModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<Category>.from(json["data"]!.map((x) => Category.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class ShopProductModel {
  bool? success;
  Product? data;
  String? message;

  ShopProductModel({
    this.success,
    this.data,
    this.message,
  });

  factory ShopProductModel.fromJson(Map<String, dynamic> json) => ShopProductModel(
    success: json["success"],
    data: json["data"] == null ? null : Product.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data,
    "message": message,
  };
}

class ShopCategoryModel {
  bool? success;
  Category? data;
  String? message;

  ShopCategoryModel({
    this.success,
    this.data,
    this.message,
  });

  factory ShopCategoryModel.fromJson(Map<String, dynamic> json) => ShopCategoryModel(
    success: json["success"],
    data: json["data"] == null ? null : Category.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data,
    "message": message,
  };
}

class Category {
  int? id;
  String? name;
  String? image;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Product>? products;

  Category({
    this.id,
    this.name,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    image: json["image"] == null ? null:imageUrl+json["image"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}

class Product {
  int? id;
  int? idCategory;
  String? name;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? price;
  String? image;
  List<Stock>? stocks;
  Category? category;
  List<Attribute>? attributes;
  List<Gallery>? gallery;

  Product({
    this.id,
    this.idCategory,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.price,
    this.image,
    this.stocks,
    this.category,
    this.attributes,
    this.gallery,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    idCategory: json["id_category"],
    name: json["name"],
    image: json["image"] == null ? null:imageUrl+json["image"],
    description: json["description"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    price: json["price"],
    stocks: json["stocks"] == null ? [] : List<Stock>.from(json["stocks"]!.map((x) => Stock.fromJson(x))),
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
    attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"]!.map((x) => Attribute.fromJson(x))),
    gallery: json["gallery"] == null ? [] : List<Gallery>.from(json["gallery"]!.map((x) => Gallery.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_category": idCategory,
    "name": name,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "price": price,
    "category": category?.toJson(),
    "attributes": attributes == null ? [] : List<dynamic>.from(attributes!.map((x) => x.toJson())),

    "stocks": stocks == null ? [] : List<dynamic>.from(stocks!.map((x) => x.toJson())),
  };
}

class Gallery {
  int? id;
  int? idProduct;
  String? media;
  DateTime? createdAt;
  DateTime? updatedAt;

  Gallery({
    this.id,
    this.idProduct,
    this.media,
    this.createdAt,
    this.updatedAt,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
    id: json["id"],
    idProduct: json["id_product"],
    media: imageUrl+json["media"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_product": idProduct,
    "media": media,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}


class Attribute {
  int? id;
  int? idProduct;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Attribute>? attributeOptions;
  Attribute? cartAttribute;
  int? idAttributes;

  Attribute({
    this.id,
    this.idProduct,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.attributeOptions,
    this.cartAttribute,
    this.idAttributes,
  });

  factory Attribute.fromJson(Map<String, dynamic> json,{fromCart = false}) => Attribute(
    id: json["id"],
    idProduct: json["id_product"],
    name: json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    attributeOptions: json["attribute_options"] == null ? [] : List<Attribute>.from(json["attribute_options"]!.map((x) => Attribute.fromJson(x))),
    cartAttribute: json["attribute"] == null ? null : Attribute.fromJson(json["attribute"]),
    idAttributes: json["id_attributes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_product": idProduct,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "attribute_options": attributeOptions == null ? [] : List<dynamic>.from(attributeOptions!.map((x) => x.toJson())),
    "id_attributes": idAttributes,
  };
}

class Stock {
  int? id;
  String? sku;
  String? salePrice;
  String? unitPrice;
  String? discountVal;
  int? discountStatus;
  RxInt? qty;
  int? idProduct;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Stock({
    this.id,
    this.sku,
    this.salePrice,
    this.unitPrice,
    this.discountVal,
    this.discountStatus,
    this.qty,
    this.idProduct,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
    id: json["id"],
    sku: json["sku"],
    salePrice: json["sale_price"],
    unitPrice: json["unit_price"],
    discountVal: json["discount_val"],
    discountStatus: json["discount_status"],
    qty: json["qty"] == null? 0.obs:int.parse(json["qty"].toString()).obs,
    idProduct: json["id_product"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sku": sku,
    "sale_price": salePrice,
    "unit_price": unitPrice,
    "discount_val": discountVal,
    "discount_status": discountStatus,
    "qty": qty,
    "id_product": idProduct,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
