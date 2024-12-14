// To parse this JSON data, do
//
//     final orderHistoryModel = orderHistoryModelFromJson(jsonString);

import 'dart:convert';

import 'package:bloodlines/View/Shop/Model/shopModel.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';

OrderHistoryModel orderHistoryModelFromJson(String str) => OrderHistoryModel.fromJson(json.decode(str));

String orderHistoryModelToJson(OrderHistoryModel data) => json.encode(data.toJson());

class OrderHistoryModel {
  bool? success;
  Data? data;
  String? message;

  OrderHistoryModel({
    this.success,
    this.data,
    this.message,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) => OrderHistoryModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  int? currentPage;
  List<OrderHistoryData>? data;
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

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<OrderHistoryData>.from(json["data"]!.map((x) => OrderHistoryData.fromJson(x))),
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

class OrderHistoryData {
  int? id;
  int? userId;
  String? orderNumber;
  int? idShipping;
  int? idBilling;
  int? idStatus;
  String? createdAt;
  String? updatedAt;
  String? orderDate;
  String? totalAmount;
  List<OrderItem>? orderItems;

  OrderHistoryData({
    this.id,
    this.userId,
    this.orderNumber,
    this.idShipping,
    this.idBilling,
    this.idStatus,
    this.createdAt,
    this.updatedAt,
    this.orderDate,
    this.totalAmount,
    this.orderItems,
  });

  factory OrderHistoryData.fromJson(Map<String, dynamic> json) => OrderHistoryData(
    id: json["id"],
    userId: json["user_id"],
    orderNumber: json["order_number"],
    idShipping: json["id_shipping"],
    idBilling: json["id_billing"],
    idStatus: json["id_status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    orderDate: json["order_date"],
    totalAmount: json["totalAmount"],
    orderItems: json["order_items"] == null ? [] : List<OrderItem>.from(json["order_items"]!.map((x) => OrderItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "order_number": orderNumber,
    "id_shipping": idShipping,
    "id_billing": idBilling,
    "id_status": idStatus,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "order_date": orderDate,
    "totalAmount": totalAmount,
    "order_items": orderItems == null ? [] : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
  };
}

class OrderItem {
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
  Product? product;

  OrderItem({
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
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
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
    product: json["product"] == null?null:Product.fromJson(json["product"]),
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
  };
}
