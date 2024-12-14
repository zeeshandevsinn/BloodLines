// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:bloodlines/View/Shop/Model/addressModel.dart';
import 'package:bloodlines/View/Shop/Model/shopModel.dart';

OrderDetailsModel orderDetailsModelFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
  int? totalItem;
  String? subTotalAmount;
  String? shipping;
  String? salesTax;
  String? totalAmount;
  AddressData? addressData;
  List<OrderDetail>? orderDetails;

  OrderDetailsModel({
    this.totalItem,
    this.subTotalAmount,
    this.shipping,
    this.salesTax,
    this.totalAmount,
    this.addressData,
    this.orderDetails,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
    totalItem: json["totalItem"],
    subTotalAmount: json["subTotalAmount"],
    shipping: json["shipping"],
    salesTax: json["salesTax"],
    totalAmount: json["totalAmount"],
    addressData: json["address"] == null?null:AddressData.fromJson(json["address"]),
    orderDetails: json["orderDetails"] == null ? [] : List<OrderDetail>.from(json["orderDetails"]!.map((x) => OrderDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalItem": totalItem,
    "subTotalAmount": subTotalAmount,
    "shipping": shipping,
    "salesTax": salesTax,
    "totalAmount": totalAmount,
    "orderDetails": orderDetails == null ? [] : List<dynamic>.from(orderDetails!.map((x) => x.toJson())),
  };
}

class OrderDetail {
  int? id;
  int? idOrder;
  int? idProduct;
  int? idVariation;
  int? idStock;
  int? qty;
  String? salePrice;
  String? discountVal;
  int? discountStatus;
  String? createdAt;
  String? updatedAt;
  String? price;
  List<Attribute>? variations;
  Product? product;
  Stock? stock;

  OrderDetail({
    this.id,
    this.idOrder,
    this.idProduct,
    this.idVariation,
    this.idStock,
    this.qty,
    this.salePrice,
    this.discountVal,
    this.discountStatus,
    this.createdAt,
    this.updatedAt,
    this.price,
    this.variations,
    this.product,
    this.stock,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    id: json["id"],
    idOrder: json["id_order"],
    idProduct: json["id_product"],
    idVariation: json["id_variation"],
    idStock: json["id_stock"],
    qty: json["qty"],
    salePrice: json["sale_price"],
    discountVal: json["discount_val"],
    discountStatus: json["discount_status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    price: json["price"],
    variations: json["variations"] == null ? [] : List<Attribute>.from(json["variations"]!.map((x) => Attribute.fromJson(x,fromCart: true))),
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
    stock: json["stock"] == null ? null : Stock.fromJson(json["stock"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_order": idOrder,
    "id_product": idProduct,
    "id_variation": idVariation,
    "id_stock": idStock,
    "qty": qty,
    "sale_price": salePrice,
    "discount_val": discountVal,
    "discount_status": discountStatus,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "price": price,
    "variations": variations == null ? [] : List<dynamic>.from(variations!.map((x) => x.toJson())),
    "product": product?.toJson(),
    "stock": stock?.toJson(),
  };
}
