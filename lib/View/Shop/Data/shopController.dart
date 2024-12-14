import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Shop/Data/shopApiCalls.dart';
import 'package:bloodlines/View/Shop/Model/addressModel.dart';
import 'package:bloodlines/View/Shop/Model/cardList.dart';
import 'package:bloodlines/View/Shop/Model/cartModel.dart';
import 'package:bloodlines/View/Shop/Model/orderDetailsModel.dart';
import 'package:bloodlines/View/Shop/Model/orderHistoryModel.dart';
import 'package:bloodlines/View/Shop/Model/shopModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

class ShopController extends GetxController {
  final cardNumber = TextEditingController();
  final expiry = TextEditingController();
  final cvv = TextEditingController();
  final cardHolder = TextEditingController();
  ShopApiCalls shopApiCalls = ShopApiCalls();
  ShopCategoryModel? categoryShopModel;
  ShopProductModel? productShopModel;
  OrderHistoryModel? orderHistoryModel;
  OrderDetailsModel? orderDetailsModel;
  ShopListModel? shopListModel;
  CartModel? cartModel;
  AddressModel? addressListModel;
  loc.Location location = loc.Location();

  ///Address
  final fName = TextEditingController();
  final lName = TextEditingController();
  final address = TextEditingController();
  final country = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final phoneController = TextEditingController();
  final zipCode = TextEditingController();
  double? latitude;
  double? longitude;

  ///Billing
  final billingFirstName = TextEditingController();
  final billingLastName = TextEditingController();
  final billingAddress = TextEditingController();
  final billingCountry = TextEditingController();
  final billingCity = TextEditingController();
  final billingState = TextEditingController();
  final billingPhoneController = TextEditingController();
  final billingZipCode = TextEditingController();
  double? billingLatitude;
  double? billingLongitude;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getShopList();
    getCart();
    getAddressList();
    // getOrderHistory();
  }

  addAddress(int isSame, {int? id}) async {
    if(isSame == 1){
      billingPhoneController.text = phoneController.text;
      billingFirstName.text = fName.text;
      billingLastName.text = lName.text;
      billingAddress.text = address.text;
      billingCountry.text = country.text;
      billingCity.text = city.text;
      billingState.text = state.text;
      billingZipCode.text = zipCode.text;
      billingLatitude= latitude;
      billingLongitude= longitude;
    }
    final response = await shopApiCalls.addAddress(
        firstName: fName.text,
        lastName: lName.text,
        id: id,
        phone: phoneController.text,
        address: address.text,
        country: country.text,
        city: city.text,
        state: state.text,
        latitude: latitude!,
        longitude: longitude!,
        billingLatitude: billingLatitude!,
        billingLongitude: billingLongitude!,
        zipCode: zipCode.text,
        billingPhone: billingPhoneController.text,
        billingFirstName: billingFirstName.text,
        billingLastName: billingLastName.text,
        billingAddress: billingAddress.text,
        billingCountry: billingCountry.text,
        billingCity: billingCity.text,
        billingState: billingState.text,
        isSame: isSame,
        billingZipCode: billingZipCode.text);

    if (response.statusCode == 200) {
      getAddressList();
      clear();
      Get.back();
      if (id == null) {
        BotToast.showText(text: "Address Add Successfully");
      } else {
        BotToast.showText(text: "Address Edited Successfully");
      }
    }
  }

  clear(){
    fName.clear();
    lName.clear();
    address.clear();
    country.clear();
    city.clear();
    state.clear();
    zipCode.clear();
    latitude = null;
    longitude = null;
    billingLatitude = null;
    billingLongitude = null;
    billingFirstName.clear();
    billingLastName.clear();
    billingAddress.clear();
    billingCountry.clear();
    billingCity.clear();
    billingState.clear();
    billingZipCode.clear();
    phoneController.clear();
    billingPhoneController.clear();
  }

  getShopList() async {
    shopListModel = await shopApiCalls.getShopList();
    update();
  }

  getAddressList() async {
    addressListModel = await shopApiCalls.getAddressList();
    update();
  }

  getCart() async {
    // if(fromCart == true){
    //   showLoading();
    // }
    cartModel = await shopApiCalls.getCart();
    BotToast.closeAllLoading();
    update();
  }

  getCategoryShops(int id) async {
    categoryShopModel = await shopApiCalls.getCategoryShops(id);
    update();
  }


  getOrderHistory() async {
    orderHistoryModel = await shopApiCalls.getOrderHistory();
    update();
  }


  getOrderDetails(int id) async {
    orderDetailsModel = await shopApiCalls.getOrderDetails(id);
    update();
  }

  getProductsShops(int id) async {
    productShopModel = await shopApiCalls.getProductsShops(id);
    update();
  }


  addToCart(int productId, int productQuantity, List<int> attributes) async {
    final response =
        await shopApiCalls.addToCart(productId, productQuantity, attributes);
    if (response.statusCode == 200) {
      BotToast.showText(text: "Added to cart successfully");
      Get.back();
      getCart();
    }
  }


  CardList? cardListModel;
  CardDetails? cardDetails;
  getCardList() async {
    cardListModel = await shopApiCalls.getCardList();
    update();
  }

  getCardDetails(cardId) async {
    cardDetails = await shopApiCalls.getCardDetails(cardId);
    update();
  }

  addNewCard(String cardNumber,String expiryMonth,String expiryYear,String cvc) async {
    final response =
        await shopApiCalls.addNewCard(cardNumber, expiryMonth, expiryYear,cvc);
    if (response.statusCode == 200) {
      BotToast.showText(text: "New Card Added successfully");
      Get.back();
      getCardList();
    }
  }

  changeDefaultCard(String cardId) async {
    final response =
        await shopApiCalls.changeDefaultCard(cardId);
    if (response.statusCode == 200) {
      BotToast.showText(text: "Card Changed Successfully");
      getCardList();
    }
  }
  deleteCreditCard(String id) async {
    final response = await shopApiCalls.deleteCreditCard(id);
    if (response.statusCode == 200) {
      getCardList();
    }
  }

  updateCart(int productId, int productQuantity, int index) async {
    await shopApiCalls.updateCart(productId, productQuantity);
    getCart();
    update();
  }

  deleteCart(int productId) async {
    final response = await shopApiCalls.deleteCart(productId);
    if (response.statusCode == 200) {
      getCart();
    }
  }

  deleteAddress(int id) async {
    final response = await shopApiCalls.deleteAddress(id);
    if (response.statusCode == 200) {
      getAddressList();
    }
  }

  changeDefaultAddress(int id) async {
    final response = await shopApiCalls.changeDefaultAddress(id);
    if (response.statusCode == 200) {
      getAddressList();
    }
  }

  emptyCart() async {
    final response = await shopApiCalls.emptyCart();
    if (response == true) {
      getCart();
    }
  }

  confirmOrder(
    int shippingId,
    int billingId,
      String cardId
  ) async {
    // print(cardId);
    final response = await shopApiCalls.confirmOrder(shippingId, billingId,cardId);
    if (response.statusCode == 200) {
      Get.offNamed(Routes.orderConfirmation);
    }
  }

  determinePositions({bool fromBilling = false,Function? callback}) async {
    bool serviceEnabled;
    await permissionServices(func: () {
      determinePositions();
    }).then(
      (value) async {
        if (value != null) {
          if (value[Permission.location]!.isGranted) {
            serviceEnabled = await location.serviceEnabled();
            if (!serviceEnabled) {
              serviceEnabled = await location.requestService();
            }

            if (serviceEnabled) {
              Get.toNamed(Routes.addressMapLocation,
                  arguments: {"fromBilling": fromBilling})!.then((value) => callback!());
              update();
            }
          } else {
            // exit(1);
          }
        }
      },
    );
  }
}
