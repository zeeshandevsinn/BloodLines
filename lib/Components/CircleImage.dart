import 'dart:io';

import 'package:bloodlines/Components/Color.dart';
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

import 'Dummy.dart';

class CircleImage extends StatelessWidget {
  CircleImage(
      {this.imageString,
      this.customHeight = 15,
      this.customWidth = 4,
      this.borderColor,
      this.borderThickness = 0.5,
      this.isInitials});
  dynamic imageString;
  double customHeight = 15;
  double customWidth = 5;
  Color? borderColor;
  double borderThickness = 0.5;
  String? isInitials;
  @override
  Widget build(BuildContext context) {
    if (isInitials != null) {
      return CircleAvatar(
          radius: MediaQuery.of(context).size.height /
              (customHeight - borderThickness),
          backgroundColor: borderColor ?? DynamicColors.primaryColor,
          child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: CircleAvatar(
                backgroundColor: borderColor ?? DynamicColors.primaryColor,
                radius:
                    MediaQuery.of(context).size.height / (customHeight - 0.5),
                child: Text(isInitials![0].toUpperCase()),
              )));
    } else {
      return CircleAvatar(
        radius: MediaQuery.of(context).size.height /
            (customHeight - borderThickness),
        backgroundColor: borderColor ?? DynamicColors.primaryColor,
        child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: imageString == null
                ? CircleAvatar(
                    backgroundColor: borderColor ?? DynamicColors.primaryColor,
                    radius: MediaQuery.of(context).size.height /
                        (customHeight - 0.5),
                    backgroundImage: imageString == null
                        ? NetworkImage(
                            dummyProfile,
                            // fit: BoxFit.fill,
                          )
                        : NetworkImage(
                            imageString.path,
                          ),
                  )
                : imageString.runtimeType == String
                    ? CircleAvatar(
                        radius: MediaQuery.of(context).size.height /
                            (customHeight - 0.5),
                        backgroundColor: DynamicColors.whiteColor,
                        // backgroundImage: OptimizedCacheImageProvider(imageString),
                        child: OptimizedCacheImage(
                          imageUrl: imageString,
                          fit: BoxFit.cover,
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: MediaQuery.of(context).size.height /
                                (customHeight - 0.5),
                            backgroundImage:
                                OptimizedCacheImageProvider(imageString),
                          ),
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: DynamicColors.borderGrey,
                          ),
                        ))
                    : !imageString.path.toString().contains("http")
                        ? CircleAvatar(
                            radius: MediaQuery.of(context).size.height /
                                (customHeight - 0.5),
                            backgroundImage: FileImage(
                              File(imageString.path),
                            ))
                        : CircleAvatar(
                            radius: MediaQuery.of(context).size.height /
                                (customHeight - 0.5),
                            // backgroundImage: OptimizedCacheImageProvider(imageString),
                            child: OptimizedCacheImage(
                              imageUrl: imageString.path,
                              fit: BoxFit.cover,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: MediaQuery.of(context).size.height /
                                    (customHeight - 0.5),
                                backgroundImage: OptimizedCacheImageProvider(
                                    imageString.path),
                              ),
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ))),
      );
    }
  }
}

class CoverImage extends StatelessWidget {
  CoverImage(
      {this.imageString,
      required this.customHeight,
      required this.customWidth,
      this.borderColor,
      this.borderThickness = 0.5,
      this.onClick,
      required this.iconColor});
  String? imageString;
  GestureTapCallback? onClick;
  double customHeight;
  double customWidth = 0;
  Color? borderColor;
  double borderThickness = 0.5;
  Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return imageString == null
        ? Container(
            height: customHeight,
            width: customWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(coverImage),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: InkWell(
                    onTap: onClick ?? () {},
                    child: Icon(
                      Icons.camera_alt,
                      color: iconColor ?? DynamicColors.primaryColor,
                    ),
                  ),
                )
              ],
            ),
          )
        : imageString.toString().contains("http")
            ? SizedBox(
                height: customHeight,
                width: customWidth,
                child: Stack(
                  children: [
                    SizedBox(
                      height: customHeight,
                      width: customWidth,
                      child: Image.network(
                        imageString!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 10),
                          child: InkWell(
                            onTap: onClick ?? () {},
                            child: Icon(
                              Icons.camera_alt,
                              color: iconColor ?? DynamicColors.primaryColor,
                            ),
                          )),
                    )
                  ],
                ),
              )
            : !imageString.toString().contains("http")
                ? SizedBox(
                    height: customHeight,
                    width: customWidth,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: customHeight,
                          width: customWidth,
                          child: Image.file(
                            File(imageString!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, bottom: 10),
                              child: InkWell(
                                onTap: onClick ?? () {},
                                child: Icon(
                                  Icons.camera_alt,
                                  color:
                                      iconColor ?? DynamicColors.primaryColor,
                                ),
                              )),
                        )
                      ],
                    ),
                  )
                : Container(
                    height: customHeight,
                    width: customWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(coverImage),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 10),
                          child: InkWell(
                            onTap: onClick ?? () {},
                            child: Icon(
                              Icons.camera_alt,
                              color: iconColor ?? DynamicColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
  }
}
