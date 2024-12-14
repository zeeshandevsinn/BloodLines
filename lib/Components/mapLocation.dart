
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Credentials/controller/credentialController.dart';
import 'package:map_location_picker/map_location_picker.dart';

class MapLocation extends StatelessWidget {
  MapLocation({super.key});
  CredentialController controller = Get.find();

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
          controller.locationController.text = result!.formattedAddress ?? "";
          // Get.back();
        },
        onSuggestionSelected: (PlacesDetailsResponse? result) {
          controller.locationController.text =
              result!.result.formattedAddress ?? "";
        },
      ),
    );
  }
}
