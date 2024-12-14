import 'dart:io';

import 'package:dio/dio.dart' as form;
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

multiPartingImage(Rx<XFile?> image) {
  return form.MultipartFile.fromFileSync(image.value!.path,
      filename: "Image.${image.value!.path.split(".").last}",
      contentType: MediaType("image", image.value!.path.split(".").last));
}

multiPartingImageNoObx(File? image,{type}) {
  return form.MultipartFile.fromFileSync(image!.path,
      filename:type == null? "Image.${image.path.split(".").last}":"${type.toString().replaceAll("/", "").toString().capitalizeFirst}.${image.path.split(".").last}",
      contentType: MediaType("image", image.path.split(".").last));
}

multiPartingAudioNoObx(File? image,{type}) {
  return form.MultipartFile.fromFileSync(image!.path,
      filename:type == null? "Audio.${image.path.split(".").last}":"${type.toString().replaceAll("/", "").toString().capitalizeFirst}.${image.path.split(".").last}",
      contentType: MediaType("audio", image.path.split(".").last));
}

multiPartingVideo(File? video,{type}) {
  return form.MultipartFile.fromFileSync(video!.path,
      filename:type == null? "Video.${video.path.split(".").last}":"${type.toString().replaceAll("/", "").toString().capitalizeFirst}.${video.path.split(".").last}",
      contentType: MediaType("video", video.path.split(".").last));
}
