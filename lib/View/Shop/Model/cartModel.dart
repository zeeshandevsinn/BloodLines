// // To parse this JSON data, do

///-----Orignal----///
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

import 'package:bloodlines/View/Shop/Model/addressModel.dart';
import 'package:bloodlines/View/Shop/Model/shopModel.dart';
import 'package:get/get.dart';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  bool? success;
  Cart? data;
  String? message;

  CartModel({
    this.success,
    this.data,
    this.message,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    success: json["success"],
    data: json["data"] == null ? null : Cart.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };
}


class Cart {
  String? subTotalAmount;
  String? shipping;
  String? salesTax;
  String? totalAmount;
  AddressData? addressData;
  List<CartData>? cart;

  Cart({
    this.subTotalAmount,
    this.shipping,
    this.salesTax,
    this.totalAmount,
    this.addressData,
    this.cart,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    subTotalAmount: json["subTotalAmount"],
    shipping: json["shipping"],
    salesTax: json["salesTax"],
    totalAmount: json["totalAmount"],
    addressData: json["address"] == null?null:AddressData.fromJson(json["address"]),
    cart: json["cart"] == null ? [] : List<CartData>.from(json["cart"]!.map((x) => CartData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "subTotalAmount": subTotalAmount,
    "shipping": shipping,
    "salesTax": salesTax,
    "totalAmount": totalAmount,
    "cart": cart == null ? [] : List<dynamic>.from(cart!.map((x) => x.toJson())),
  };
}

class CartData {
  int? id;
  int? userId;
  int? idProduct;
  int? idVariation;
  String? price;
  int? idStock;
  RxInt? qty;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Attribute>? variations;
  Product? product;
  Stock? stock;

  CartData({
    this.id,
    this.userId,
    this.idProduct,
    this.idVariation,
    this.idStock,
    this.price,
    this.qty,
    this.createdAt,
    this.updatedAt,
    this.variations,
    this.product,
    this.stock,
  });

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
    id: json["id"],
    userId: json["user_id"],
    idProduct: json["id_product"],
    idVariation: json["id_variation"],
    idStock: json["id_stock"],
    price: json["price"],
    qty: json["qty"] == null? 0.obs:int.parse(json["qty"].toString()).obs,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    variations: json["variations"] == null ? [] : List<Attribute>.from(json["variations"]!.map((x) => Attribute.fromJson(x ,fromCart: true))),
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
    stock: json["stock"] == null ? null : Stock.fromJson(json["stock"]),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "id_product": idProduct,
    "id_variation": idVariation,
    "id_stock": idStock,
    "qty": qty,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "variations": variations == null ? [] : List<dynamic>.from(variations!.map((x) => x.toJson())),
    "product": product?.toJson(),
    "stock": stock?.toJson(),
  };
}





///-----Test Model----///
// To parse this JSON data, do
// //
// //     final cartModel = cartModelFromJson(jsonString);
//
// import 'dart:convert';
//
// import 'package:bloodlines/View/Shop/Model/addressModel.dart';
// import 'package:bloodlines/View/Shop/Model/shopModel.dart';
// import 'package:get/get.dart';
//
// CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));
//
// String cartModelToJson(CartModel data) => json.encode(data.toJson());
//
// class CartModel {
//   bool? success;
//   Cart? data;
//   String? message;
//
//   CartModel({
//     this.success,
//     this.data,
//     this.message,
//   });
//
//   factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
//     success: json["success"],
//     data: json["data"] == null ? null : Cart.fromJson(json["data"]),
//     message: json["message"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "data": data?.toJson(),
//     "message": message,
//   };
// }
//
//
// class Cart {
//   String? subTotalAmount;
//   String? shipping;
//   String? salesTax;
//   String? totalAmount;
//   AddressData? addressData;
//   List<CartData>? cart;
//   List<VariationElement>? variations;
//
//   Cart({
//     this.subTotalAmount,
//     this.shipping,
//     this.salesTax,
//     this.totalAmount,
//     this.variations,
//     this.addressData,
//     this.cart,
//   });
//
//   factory Cart.fromJson(Map<String, dynamic> json) => Cart(
//     subTotalAmount: json["subTotalAmount"],
//     shipping: json["shipping"],
//     salesTax: json["salesTax"],
//     totalAmount: json["totalAmount"],
//     variations: List<VariationElement>.from(json["variations"].map((x) => VariationElement.fromJson(x))),
//     addressData: json["address"] == null?null:AddressData.fromJson(json["address"]),
//     cart: json["cart"] == null ? [] : List<CartData>.from(json["cart"]!.map((x) => CartData.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "subTotalAmount": subTotalAmount,
//     "shipping": shipping,
//     "salesTax": salesTax,
//     "variations": List<dynamic>.from(variations!.map((x) => x.toJson())),
//     "totalAmount": totalAmount,
//     "cart": cart == null ? [] : List<dynamic>.from(cart!.map((x) => x.toJson())),
//   };
// }
//
// class CartData {
//   int? id;
//   int? userId;
//   int? idProduct;
//   int? idVariation;
//   String? price;
//   int? idStock;
//   RxInt? qty;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   List<Attribute>? variations;
//   Product? product;
//   Stock? stock;
//
//   CartData({
//     this.id,
//     this.userId,
//     this.idProduct,
//     this.idVariation,
//     this.idStock,
//     this.price,
//     this.qty,
//     this.createdAt,
//     this.updatedAt,
//     this.variations,
//     this.product,
//     this.stock,
//   });
//
//   factory CartData.fromJson(Map<String, dynamic> json) => CartData(
//     id: json["id"],
//     userId: json["user_id"],
//     idProduct: json["id_product"],
//     idVariation: json["id_variation"],
//     idStock: json["id_stock"],
//     price: json["price"],
//     qty: json["qty"] == null? 0.obs:int.parse(json["qty"].toString()).obs,
//     createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//     updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//     variations: json["variations"] == null ? [] : List<Attribute>.from(json["variations"]!.map((x) => Attribute.fromJson(x))),
//     product: json["product"] == null ? null : Product.fromJson(json["product"]),
//     stock: json["stock"] == null ? null : Stock.fromJson(json["stock"]),
//
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "user_id": userId,
//     "id_product": idProduct,
//     "id_variation": idVariation,
//     "id_stock": idStock,
//     "qty": qty,
//     "created_at": createdAt?.toIso8601String(),
//     "updated_at": updatedAt?.toIso8601String(),
//     "variations": variations == null ? [] : List<dynamic>.from(variations!.map((x) => x.toJson())),
//     "product": product?.toJson(),
//     "stock": stock?.toJson(),
//   };
// }
//
// class VariationElement {
//   int id;
//   int idProduct;
//   String name;
//   DateTime createdAt;
//   DateTime updatedAt;
//   List<VariationElement>? attributeOptions;
//   int? idAttributes;
//   VariationElement? attribute;
//
//   VariationElement({
//     required this.id,
//     required this.idProduct,
//     required this.name,
//     required this.createdAt,
//     required this.updatedAt,
//     this.attributeOptions,
//     this.idAttributes,
//     this.attribute,
//   });
//
//   factory VariationElement.fromJson(Map<String, dynamic> json) => VariationElement(
//     id: json["id"],
//     idProduct: json["id_product"],
//     name: json["name"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     attributeOptions: json["attribute_options"] == null ? [] : List<VariationElement>.from(json["attribute_options"]!.map((x) => VariationElement.fromJson(x))),
//     idAttributes: json["id_attributes"],
//     attribute: json["attribute"] == null ? null : VariationElement.fromJson(json["attribute"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "id_product": idProduct,
//     "name": name,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "attribute_options": attributeOptions == null ? [] : List<dynamic>.from(attributeOptions!.map((x) => x.toJson())),
//     "id_attributes": idAttributes,
//     "attribute": attribute?.toJson(),
//   };
// }

///--------------///////

