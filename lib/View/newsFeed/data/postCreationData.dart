import 'dart:io';

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/model/postMedia.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PostCreationData {
  final FileType _pickingType = FileType.custom;
  final bool _multiPick = true;
  FeedController controller = Get.find();
  getAudio() async {
    List<PlatformFile>? paths;
    try {
      if (paths == null || paths.isEmpty) {
        paths = (await FilePicker.platform.pickFiles(
                type: _pickingType,
                allowMultiple: _multiPick,
                onFileLoading: (FilePickerStatus status) => print(status),
                allowedExtensions: ['mp3', 'wav'],
                allowCompression: true))
            ?.files;

        for (var element in paths!) {
          controller.tempList.add(PostMedia(
            mediaType: "audio",
            media: element.path,
          ));
          // controller.addMedia("audio", File(element.path!));
        }
      } else {
        var another = (await FilePicker.platform.pickFiles(
                type: _pickingType,
                allowMultiple: _multiPick,
                onFileLoading: (FilePickerStatus status) => print(status),
                allowedExtensions: ['mp3', 'wav'],
                allowCompression: true))
            ?.files;
        paths.addAll(another!.cast());
        for (var element in paths) {
          controller.tempList.add(PostMedia(
            mediaType: "audio",
            media: element.path,
          ));
          // controller.addMedia("audio", File(element.path!));
        }
        print(paths);
      }
      // fillColor.value = Colors.white;
      controller.backgroundColor.value = DynamicColors.primaryColorLight.value;
      controller.imageUpdate.value = !controller.imageUpdate.value;
      controller.update();
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }
  }

  imgFromGallery() async {
    try {
      List<XFile>? files = await _picker.pickMultipleMedia() ?? [];
      for (var element in files) {
        if (element.name.toLowerCase().contains("mp4") ||
            element.name.toLowerCase().contains("mov")) {
          if (Platform.isIOS) {
            final fileName = await VideoCompress.getFileThumbnail(element.path,
                position: -1 // default(-1)
                );
            controller.tempList.add(PostMedia(
              mediaType: "video",
              thumbnail: fileName.path,
            ));
            controller.update();
            VideoCompress.compressVideo(
              element.path,
              quality: VideoQuality.DefaultQuality,
              deleteOrigin: false, // It's false by default
            ).then((compress) {
              for (int i = 0; i < controller.tempList.length; i++) {
                if (controller.tempList[i].media == null &&
                    controller.tempList[i].mediaType == "video") {
                  controller.tempList[i].media = compress!.path;
                  controller.update();
                }
              }
            });
          } else {
            final fileName = await VideoThumbnail.thumbnailFile(
              video: element.path,
              thumbnailPath: (await getTemporaryDirectory()).path,
              imageFormat: ImageFormat.PNG,
              maxHeight: 64, timeMs: 3,
              // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
              quality: 100,
            );
            controller.tempList.add(PostMedia(
              mediaType: "video",
              thumbnail: fileName,
            ));
            controller.update();
            VideoCompress.compressVideo(
              element.path,
              quality: VideoQuality.DefaultQuality,
              deleteOrigin: false, // It's false by default
            ).then((compress) {
              for (int i = 0; i < controller.tempList.length; i++) {
                if (controller.tempList[i].media == null &&
                    controller.tempList[i].mediaType == "video") {
                  controller.tempList[i].media = compress!.path;
                  controller.update();
                }
              }
            });
          }
        } else {
          CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: element.path,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
            uiSettings: [
              AndroidUiSettings(
                  toolbarTitle: 'Cropper',
                  toolbarColor: DynamicColors.primaryColor,
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
              IOSUiSettings(
                title: 'Cropper',
              ),
            ],
          );
          final file =
              await controller.testCompressAndGetFile(File(croppedFile!.path));
          controller.tempList.add(PostMedia(
            mediaType: "image",
            media: file != null ? file.path : croppedFile.path,
          ));
        }
      }
      controller.backgroundColor.value = DynamicColors.primaryColorLight.value;
      controller.imageUpdate.value = !controller.imageUpdate.value;
      controller.update();
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }
  }

  final ImagePicker _picker = ImagePicker();
  imgFromCamera() async {
    XFile? files = await _picker.pickImage(source: ImageSource.camera);
    if (files != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: files.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: DynamicColors.primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      final file =
          await controller.testCompressAndGetFile(File(croppedFile!.path));
      controller.tempList.add(PostMedia(
        mediaType: "image",
        media: file != null ? file.path : croppedFile.path,
      ));
      controller.update();
    }
  }

  videoFromCamera({fromGallery = false}) async {
    XFile? files = await _picker.pickVideo(
        source: fromGallery == true ? ImageSource.gallery : ImageSource.camera);
    if (files != null) {
      if (Platform.isIOS) {
        final fileName = await VideoCompress.getFileThumbnail(files.path,
            position: -1 // default(-1)
            );
        // final compressed = await VideoCompress.compressVideo(
        //   files.path,
        // );
        controller.tempList.add(PostMedia(
          mediaType: "video",
          media: files.path,
          thumbnail: fileName.path,
        ));
        controller.update();
      } else {
        final fileName = await VideoThumbnail.thumbnailFile(
          video: files.path,
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.PNG,
          maxHeight: 64, timeMs: 3,
          // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
          quality: 100,
        );
        controller.tempList.add(PostMedia(
          mediaType: "video",
          thumbnail: fileName,
        ));
        controller.update();
        VideoCompress.compressVideo(
          files.path,
          quality: VideoQuality.DefaultQuality,
          deleteOrigin: false, // It's false by default
        ).then((compress) {
          for (int i = 0; i < controller.tempList.length; i++) {
            if (controller.tempList[i].media == null &&
                controller.tempList[i].mediaType == "video") {
              controller.tempList[i].media = compress!.path;
              controller.update();
            }
          }
        });
        controller.update();
      }
    }
  }

  void _logException(String message) {
    print(message);
    controller.scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    controller.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
