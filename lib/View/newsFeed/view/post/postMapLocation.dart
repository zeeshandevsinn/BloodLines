// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/View/newsFeed/view/post/newPost.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';

class PostMapLocation extends StatelessWidget {
  PostMapLocation({super.key});

  PostLocation? suggestionLocation;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: DynamicColors.primaryColorLight, // header background color
          onPrimary: DynamicColors.primaryColor, // header text color
          onSurface: DynamicColors.textColor, // body text color
        ),
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: DynamicColors.primaryColorLight,
          cursorColor: DynamicColors.primaryColorLight,
          selectionColor: DynamicColors.primaryColorLight,
        ),
      ),
      child: MapLocationPicker(
        minMaxZoomPreference: MinMaxZoomPreference(0, 11),
        currentLatLng: LatLng(37.4220604, -122.0852343),
        topCardColor: DynamicColors.primaryColorLight,
        popOnNextButtonTaped: true,
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
        onNext: (GeocodingResult? result) {
          if (suggestionLocation == null) {
            if (result != null) {
              PostLocation location = PostLocation(
                  latitude: result.geometry.location.lat,
                  longitude: result.geometry.location.lng,
                  address: result.formattedAddress ?? "");
              postLocation.value = location;
              // Get.back(result: location);
            } else {
              postLocation.value = suggestionLocation;
            }
          } else {
            postLocation.value = suggestionLocation;
          }
        },
        onSuggestionSelected: (PlacesDetailsResponse? result) {
          suggestionLocation = PostLocation(
              latitude: result!.result.geometry!.location.lat,
              longitude: result.result.geometry!.location.lng,
              address: result.result.formattedAddress ?? "");

          // Get.back(result: location);
        },
      ),
    );
  }
}
