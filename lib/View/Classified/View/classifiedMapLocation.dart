import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/View/Classified/Data/classifiedController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';

class ClassifiedMapLocation extends StatelessWidget {
  ClassifiedMapLocation({super.key});
  ClassifiedController controller = Get.find();

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
        // showBackButton: false,
        // currentLatLng: apiLocation == null
        //     ? null
        //     : LatLng(apiLocation!.lat!, apiLocation!.lon!),
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
        popOnNextButtonTaped: true,
        apiKey: "AIzaSyC_-hLFYGAJC_IBMnFBKZLq2IS1qr7tJgQ",
        // canPopOnNextButtonTaped: true,
        onNext: (GeocodingResult? result) {
          if (result != null) {
            controller.locationController.text = result.formattedAddress ?? "";
            controller.lat = result.geometry.location.lat.toString();
            controller.long = result.geometry.location.lng.toString();
          } // Get.back();
        },
        onSuggestionSelected: (PlacesDetailsResponse? result) {
          controller.locationController.text =
              result!.result.formattedAddress ?? "";
          controller.lat = result.result.geometry!.location.lat.toString();
          controller.long = result.result.geometry!.location.lng.toString();
        },
      ),
    );
  }
}
