import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/View/Shop/Model/addressModel.dart';
import 'package:bloodlines/View/Shop/Model/cardList.dart';
import 'package:bloodlines/View/Shop/Model/cartModel.dart';
import 'package:bloodlines/View/Shop/Model/orderDetailsModel.dart';
import 'package:bloodlines/View/Shop/Model/orderHistoryModel.dart';
import 'package:bloodlines/View/Shop/Model/shopModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';

class ShopApiCalls{
  Future<ShopCategoryModel> getCategoryShops(int id,{fullUrl}) async {
    Response response =
    await Api.singleton.get('category', fullUrl: fullUrl,queryParameters:{
      "id":id
    } );
    if (response.statusCode == 200) {
      return ShopCategoryModel.fromJson(response.data);
      // return PostModel.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<ShopProductModel> getProductsShops(int id,{fullUrl}) async {
    Response response =
    await Api.singleton.get('product', fullUrl: fullUrl,queryParameters:{
      "id":id
    } );
    if (response.statusCode == 200) {
      return ShopProductModel.fromJson(response.data);
      // return PostModel.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }


  Future<CardList> getCardList({fullUrl}) async {
    Response response =
    await Api.singleton.get('list-card', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      return CardList.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<CardDetails> getCardDetails(String cardId) async {
    Response response =
    await Api.singleton.get('retrieve-card',queryParameters:{
      "card_id":cardId
    });
    if (response.statusCode == 200) {
      return CardDetails.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<OrderDetailsModel> getOrderDetails(int id,{fullUrl}) async {
    Response response =
    await Api.singleton.get('order-details', fullUrl: fullUrl,queryParameters:{
      "id":id
    } );
    if (response.statusCode == 200) {
      return OrderDetailsModel.fromJson(response.data["data"]);
      // return PostModel.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }


  Future<OrderHistoryModel> getOrderHistory({fullUrl}) async {
    Response response =
    await Api.singleton.get('my-orders', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      return OrderHistoryModel.fromJson(response.data);
      // return PostModel.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }


  Future<ShopListModel> getShopList({String? fullUrl}) async {
    Response response =
    await Api.singleton.get('shop', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      return ShopListModel.fromJson(response.data);
      // return PostModel.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }


  Future<AddressModel> getAddressList({String? fullUrl}) async {
    Response response =
    await Api.singleton.get('my-address', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      return AddressModel.fromJson(response.data);
      // return PostModel.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }


Future<bool> emptyCart() async {
    Response response =
    await Api.singleton.get('empty-cart',);
    if (response.statusCode == 200) {
      BotToast.showText(text: response.data["message"]);
      return true;

    } else {
      throw Exception(response.statusMessage);
    }
  }



    Future<CartModel> getCart({String? fullUrl}) async {
    Response response =
    await Api.singleton.get('my-cart', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      return CartModel.fromJson(response.data);
      // return PostModel.fromJson(response.data["data"]);
    } else {
      BotToast.closeAllLoading();
      throw Exception(response.statusMessage);
    }
  }

  Future<Response> addToCart(int productId,int productQuantity,List<int> attributes) async {
    var map = {
      "product_id":productId,
      "qty":productQuantity,
      "id_attribute_options[]":attributes,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'add-to-cart', isProgressShow: false);
    print(response);
    return response;
  }


    Future<Response> addNewCard(String cardNumber,String expiryMonth,String expiryYear,String cvc) async {
    var map = {
      "card_number":cardNumber,
      "exp_month":expiryMonth,
      "exp_year":expiryYear,
      "cvc":cvc,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'save-card', isProgressShow: false);
    print(response);
    return response;
  }


    Future<Response> changeDefaultCard(String cardId) async {
    var map = {
      "card_id":cardId,

    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'change-default-card', isProgressShow: false);
    print(response);
    return response;
  }


  Future<Cart> updateCart(int id,int productQuantity,) async {
    var map = {
      "id":id,
      "qty":productQuantity,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'update-cart', isProgressShow: false,noCloseLoading:true);
    if (response.statusCode == 200) {
      return Cart.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<Response> deleteCreditCard(String id,)async {
    var map = {
      "card_id":id,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'delete-card', isProgressShow: false,noCloseLoading:true);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(response.statusMessage);
    }
  }


  Future<Response> addAddress({
  required String firstName,
  required String lastName,
  required String phone,
  required String address,
  required String country,
  required String city,
  required String state,
  required String zipCode,
  required String billingPhone,
  required String billingFirstName,
  required String billingLastName,
  required String billingAddress,
  required String billingCountry,
  required String billingCity,
  required String billingState,
  required String billingZipCode,
  required int isSame,
  required double latitude,
  required double longitude,
  required double billingLatitude,
  required double billingLongitude,
  int? id,
}) async {
    var map = {
      "first_name":firstName,
      "last_name":lastName,
      "contact":phone,
      "street_address":address,
      "county":country,
      "city":city,
      if(id != null)"id":id,
      "state":state,
      "zipcode":zipCode,
      "latitude":latitude,
      "longitude":longitude,
      "billing_first_name":billingFirstName,
      "billing_last_name":billingLastName,
      "billing_contact":billingPhone,
      "billing_street_address":billingAddress,
      "billing_county":billingCountry,
      "billing_city":billingCity,
      "different_billing_address":isSame,
      "billing_state":billingState,
      "billing_zipcode":billingZipCode,
      "billing_latitude":billingLatitude,
      "billing_longitude":billingLongitude,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData,id == null? 'add-address':'edit-address', isProgressShow: false);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<Response> deleteCart(int id,) async {
    var map = {
      "id":id,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'delete-cart-item', isProgressShow: false);
    print(response);
    return response;
  }

  Future<Response> changeDefaultAddress(int id,) async {
    var map = {
      "id_shipping_address":id,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'change-default-address', isProgressShow: false);
    print(response);
    return response;
  }

  Future<Response> deleteAddress(int id,) async {
    var map = {
      "id":id,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'delete-address', isProgressShow: false);
    print(response);
    return response;
  }


  Future<Response> confirmOrder(int shippingId,int billingId,String cardId) async {
    var map = {
      "id_shipping_address":shippingId,
      "id_billing_address":billingId,
      "card_id":cardId,
    };
    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'place-order', isProgressShow: false);
    print(response);
    return response;
  }

}