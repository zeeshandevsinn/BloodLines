// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/View/Shop/Data/shopController.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';

class EventMapLocation extends StatelessWidget {
  EventMapLocation({super.key});
  FeedController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(onPrimary: Colors.black),
          cardTheme: CardTheme(surfaceTintColor: Colors.white),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.grey[200],
            filled: true,
          )),
      child: MapLocationPicker(
        // showBackButton: false,
        // currentLatLng: apiLocation == null
        //     ? null
        //     : LatLng(apiLocation!.lat!, apiLocation!.lon!),
        currentLatLng: LatLng(37.4220604, -122.0852343),
        minMaxZoomPreference: MinMaxZoomPreference(0, 11),
        topCardColor: DynamicColors.primaryColorLight,
        bottomCardColor: DynamicColors.primaryColorLight,
        backButton: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: DynamicColors.borderGrey,
          ),
        ),
        apiKey: "AIzaSyC_-hLFYGAJC_IBMnFBKZLq2IS1qr7tJgQ",
        popOnNextButtonTaped: true,
        onNext: (GeocodingResult? result) {
          print(result);
          if (result != null) {
            controller.eventLocation.text = result.formattedAddress ?? "";
            controller.eventLatitude = result.geometry.location.lat.toString();
            controller.eventLongitude = result.geometry.location.lng.toString();
            List<dynamic> countries = result.addressComponents
                .where((entry) => entry.types.contains('country'))
                .toList()
                .map((entry) => entry.longName)
                .toList();
            List<dynamic> localities = result.addressComponents
                .where((entry) => entry.types.contains('locality'))
                .toList()
                .map((entry) => entry.longName)
                .toList();
            List<dynamic> state = result.addressComponents
                .where((entry) =>
                    entry.types.contains('administrative_area_level_1'))
                .toList()
                .map((entry) => entry.longName)
                .toList();
          }
        },
        onSuggestionSelected: (PlacesDetailsResponse? result) {
          controller.eventLocation.text = result!.result.formattedAddress ?? "";
          controller.eventLatitude =
              result.result.geometry!.location.lat.toString();
          controller.eventLongitude =
              result.result.geometry!.location.lng.toString();
        },
      ),
    );
  }
}

class AddressMapLocation extends StatelessWidget {
  AddressMapLocation({super.key});
  ShopController controller = Get.find();
  bool fromBilling = Get.arguments["fromBilling"];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(onPrimary: Colors.black),
          cardTheme: CardTheme(surfaceTintColor: Colors.white),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.grey[200],
            filled: true,
          )),
      child: MapLocationPicker(
        // showBackButton: false,
        // currentLatLng: apiLocation == null
        //     ? null
        //     : LatLng(apiLocation!.lat!, apiLocation!.lon!),
        minMaxZoomPreference: MinMaxZoomPreference(0, 11),
        currentLatLng: LatLng(37.4220604, -122.0852343),
        topCardColor: DynamicColors.primaryColorLight,
        bottomCardColor: DynamicColors.primaryColorLight,
        backButton: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: DynamicColors.borderGrey,
          ),
        ),
        apiKey: "AIzaSyC_-hLFYGAJC_IBMnFBKZLq2IS1qr7tJgQ",
        popOnNextButtonTaped: true,
        onNext: (GeocodingResult? result) {
          print(result);
          if (result != null) {
            if (fromBilling == true) {
              controller.billingAddress.text = result.formattedAddress ?? "";
              controller.billingLatitude = result.geometry.location.lat;
              controller.billingLongitude = result.geometry.location.lng;
            } else {
              controller.address.text = result.formattedAddress ?? "";
              controller.latitude = result.geometry.location.lat;
              controller.longitude = result.geometry.location.lng;
            }
            List<dynamic> countries = result.addressComponents
                .where((entry) => entry.types.contains('country'))
                .toList()
                .map((entry) => entry.longName)
                .toList();
            List<dynamic> localities = result.addressComponents
                .where((entry) => entry.types.contains('locality'))
                .toList()
                .map((entry) => entry.longName)
                .toList();
            List<dynamic> state = result.addressComponents
                .where((entry) =>
                    entry.types.contains('administrative_area_level_1'))
                .toList()
                .map((entry) => entry.longName)
                .toList();
            List<dynamic> code = result.addressComponents
                .where((entry) => entry.types.contains('postal_code'))
                .toList()
                .map((entry) => entry.longName)
                .toList();
            if (fromBilling == true) {
              controller.billingCountry.text = countries[0];
              controller.billingCity.text = localities[0];
              controller.billingState.text = state[0];
              controller.billingZipCode.text = code[0];
            } else {
              controller.country.text = countries[0];
              controller.city.text = localities[0];
              controller.state.text = state[0];
              controller.zipCode.text = code[0];
            }
            controller.update();
          }
        },
        onSuggestionSelected: (PlacesDetailsResponse? result) {
          if (fromBilling == true) {
            controller.billingAddress.text =
                result!.result.formattedAddress ?? "";
            controller.billingLatitude = result.result.geometry!.location.lat;
            controller.billingLongitude = result.result.geometry!.location.lng;
          } else {
            controller.address.text = result!.result.formattedAddress ?? "";
            controller.latitude = result.result.geometry!.location.lat;
            controller.longitude = result.result.geometry!.location.lng;
          }
          List<dynamic> countries = result.result.addressComponents
              .where((entry) => entry.types.contains('country'))
              .toList()
              .map((entry) => entry.longName)
              .toList();
          List<dynamic> localities = result.result.addressComponents
              .where((entry) => entry.types.contains('locality'))
              .toList()
              .map((entry) => entry.longName)
              .toList();
          List<dynamic> state = result.result.addressComponents
              .where((entry) =>
                  entry.types.contains('administrative_area_level_1'))
              .toList()
              .map((entry) => entry.longName)
              .toList();
          List<dynamic> code = result.result.addressComponents
              .where((entry) => entry.types.contains('postal_code'))
              .toList()
              .map((entry) => entry.longName)
              .toList();
          if (fromBilling == true) {
            controller.billingCountry.text = countries[0];
            controller.billingCity.text = localities[0];
            controller.billingState.text = state[0];
            controller.billingZipCode.text = code[0];
          } else {
            controller.country.text = countries[0];
            controller.city.text = localities[0];
            controller.state.text = state[0];
            controller.zipCode.text = code[0];
          }
          controller.update();
        },
      ),
    );
  }
}
