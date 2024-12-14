import 'dart:io';

import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/model/postMedia.dart';
import 'package:camera_filters/camera_filters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// class CameraFilterClass extends StatelessWidget {
//   CameraFilterClass({Key? key}) : super(key: key);
//
//   FeedController controller = Get.find();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CameraScreenPlugin(onDone: (value) async{
//         CroppedFile? croppedFile = await ImageCropper().cropImage(
//           sourcePath: value,
//           aspectRatioPresets: [
//             CropAspectRatioPreset.square,
//             CropAspectRatioPreset.ratio3x2,
//             CropAspectRatioPreset.original,
//             CropAspectRatioPreset.ratio4x3,
//             CropAspectRatioPreset.ratio16x9
//           ],
//           uiSettings: [
//             AndroidUiSettings(
//                 toolbarTitle: 'Cropper',
//                 toolbarColor: DynamicColors.primaryColor,
//                 toolbarWidgetColor: Colors.white,
//                 initAspectRatio: CropAspectRatioPreset.original,
//                 lockAspectRatio: false),
//             IOSUiSettings(
//               title: 'Cropper',
//             ),
//           ],
//         );
//         final file = await controller.testCompressAndGetFile(File(croppedFile!.path));
//         controller.tempList.add(PostMedia(
//           mediaType: "image",
//           media: file != null ? file.path : croppedFile.path,
//         ));
//         // controller.addMedia(
//         //   "image",
//         //   File(
//         //     file != null ? file.path : croppedFile.path,
//         //   ),
//         // );
//         Get.back();
//         Get.back();
//         controller.backgroundColor.value = DynamicColors.primaryColorLight.value;
//         controller.imageUpdate.value = !controller.imageUpdate.value;
//         controller.update();
//       },
//
//           /// value returns the video path you can save here or navigate to some screen
//           onVideoDone: (value) async {
//         if (Platform.isIOS) {
//           final fileName = await VideoCompress.getFileThumbnail(value,
//               position: -1 // default(-1)
//               );
//           controller.tempList.add(PostMedia(
//             mediaType: "video",
//             media: value,
//             thumbnail: fileName.path,
//           ));
//           // controller.addMedia(
//           //   "video",
//           //   File(value),
//           //   thumb: fileName,
//           // );
//         } else {
//           final fileName = await VideoThumbnail.thumbnailFile(
//             video: value,
//             thumbnailPath: (await getTemporaryDirectory()).path,
//             imageFormat: ImageFormat.PNG,
//             maxHeight: 64, timeMs: 3,
//             // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
//             quality: 100,
//           );
//           controller.tempList.add(PostMedia(
//             mediaType: "video",
//             media: value,
//             thumbnail: fileName,
//           ));
//           // controller.addMedia(
//           //   "video",
//           //   File(value),
//           //   thumb: fileName,
//           // );
//         }
//         Get.back();
//         Get.back();
//         controller.backgroundColor.value = DynamicColors.primaryColorLight.value;
//         controller.imageUpdate.value = !controller.imageUpdate.value;
//         controller.update();
//       }
//
//           /// profileIconWidget: , if you want to add profile icon on camera you can your widget here
//
//           ///filterColor: ValueNotifier<Color>(Colors.transparent),  your first filter color when you open camera
//
//           /// filters: [],
//           ///you can pass your own list of colors like this List<Color> colors = [Colors.blue, Colors.blue, Colors.blue ..... Colors.blue]
//           ///make sure to pass transparent color to first index so the first index of list has no filter effect
//           ),
//     );
//   }
// }
