// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

import 'package:bloodlines/userModel.dart';
import 'package:get/get.dart';

AddressModel addressModelFromJson(String str) => AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  bool? success;
  List<AddressData>? data;
  String? message;

  AddressModel({
    this.success,
    this.data,
    this.message,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<AddressData>.from(json["data"]!.map((x) => AddressData.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class AddressData {
  ShippingAddress? billingAddress;
  ShippingAddress? shippingAddress;

  AddressData({
    this.billingAddress,
    this.shippingAddress,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
    billingAddress: json["billing_address"] == null ? null : ShippingAddress.fromJson(json["billing_address"]),
    shippingAddress: json["shipping_address"] == null ? null : ShippingAddress.fromJson(json["shipping_address"]),
  );

  Map<String, dynamic> toJson() => {
    "billing_address": billingAddress?.toJson(),
    "shipping_address": shippingAddress?.toJson(),
  };
}

class ShippingAddress {
  int? id;
  int? userId;
  String? firstName;
  String? lastName;
  String? contact;
  String? streetAddress;
  String? county;
  String? city;
  String? state;
  String? zipcode;
  String? latitude;
  String? longitude;
  int? paymentOptionId;
  int? shippingId;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? user;
  int? deliveryOptionId;
  int? differentBillingAddress;
  RxInt? defaultAddress;

  ShippingAddress({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.contact,
    this.streetAddress,
    this.county,
    this.city,
    this.latitude,
    this.longitude,
    this.state,
    this.zipcode,
    this.paymentOptionId,
    this.shippingId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.deliveryOptionId,
    this.differentBillingAddress,
    this.defaultAddress,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
    id: json["id"],
    userId: json["user_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    contact: json["contact"],
    streetAddress: json["street_address"],
    county: json["county"],
    defaultAddress:json["default_address"] == null?0.obs: int.parse(json["default_address"].toString()).obs,
    city: json["city"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    state: json["state"],
    zipcode: json["zipcode"],
    paymentOptionId: json["payment_option_id"],
    shippingId: json["shipping_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
    deliveryOptionId: json["delivery_option_id"],
    differentBillingAddress: json["different_billing_address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "contact": contact,
    "street_address": streetAddress,
    "county": county,
    "city": city,
    "state": state,
    "zipcode": zipcode,
    "latitude": latitude,
    "longitude": longitude,
    "payment_option_id": paymentOptionId,
    "shipping_id": shippingId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
    "delivery_option_id": deliveryOptionId,
    "different_billing_address": differentBillingAddress,
  };
}

