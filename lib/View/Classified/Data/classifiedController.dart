import 'dart:io';

import 'package:bloodlines/Components/imageBottomSheet.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Classified/Data/classifiedData.dart';
import 'package:bloodlines/View/Classified/Model/categoryModel.dart';
import 'package:bloodlines/View/Classified/Model/classifiedAdModel.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:bloodlines/View/newsFeed/data/newsFeedPostServices.dart';
import 'package:dio/dio.dart' as form;
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_crop/multi_image_crop.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

class ClassifiedController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  List<String> deleteMediaIds = [];
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  String lat = "", long = "";
  loc.Location location = loc.Location();
  ClassifiedCategoriesModel? classifiedCategoriesModel;
  ClassifiedCategoriesModel? forShowingClassifiedCategoriesModel;
  ClassifiedAdModel? classifiedAdModel;
  ClassifiedAdModel? myClassifiedAdModel;
  ClassifiedAdData? classifiedAdData;
  List<ClassifiedPhotos> classifiedPhotos = [];
  NewsFeedPostServices newsFeedPostServices = NewsFeedPostServices();
  List<String> categoryList = [
    "Category 1",
    "Category 2",
    "Category 3",
  ];

  @override
  void onInit() {
    super.onInit();
    getCategories();
    getClassifiedAds();
  }

  determinePosition() async {
    bool serviceEnabled;
    await permissionServices(func: () {
      determinePosition();
    }).then(
      (value) async {
        if (value != null) {
          if (value[Permission.location]!.isGranted) {
            serviceEnabled = await location.serviceEnabled();
            if (!serviceEnabled) {
              serviceEnabled = await location.requestService();
            }

            if (serviceEnabled) {
              Get.toNamed(Routes.classifiedMapLocation);
              update();
            }
          } else {
            exit(1);
          }
        }
      },
    );
  }

  _imgFromGallery(context, {fromAddEvent = false}) async {
    List<XFile> file = [];
    try {
      file = await _picker.pickMultiImage(
          imageQuality: 50,
          maxHeight: 1200,
          maxWidth: 1200);

      if (file.isNotEmpty) {
        // MultiImageCrop.startCropping(context: context,
        //     files: List.generate(
        //         file.length, (index) => File(file[index].path)),
        //     callBack: (List<File> images) {
        //       for (var element in images) {
        //         // pedigreeCover.add(XFile(element.path));
        //         files.add(XFile(element.path));
        //         classifiedPhotos.add(PedigreePhotos(localImage: XFile(element.path)));
        //
        //       }
        //       update();
        //     },aspectRatio: 1);
        for(int i =0; i < file.length; i ++){
          CroppedFile? crop= await ImageCropper.platform.cropImage(sourcePath: file[i].path);
          if(crop!=null){
            classifiedPhotos.add(ClassifiedPhotos(localImage: XFile(crop.path)));
            update();
          }
        }
      }
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
  }

  List<XFile> files = [];
  _imgFromCamera(context, {fromAddEvent = false}) async {
    try {
     XFile? file = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxHeight: 1200,
          maxWidth: 1200);

      if (file != null) {
        CroppedFile? crop= await ImageCropper.platform.cropImage(sourcePath: file.path);
        if(crop!=null){
          classifiedPhotos.add(ClassifiedPhotos(localImage: XFile(crop.path)));

          update();
        }
      }
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
  }

  bottomSheet(context, {fromAddEvent = false}) {
    ImageBottomSheet.bottomSheet(
      context,
      onCameraTap: () async {
        _imgFromCamera(context, fromAddEvent: fromAddEvent);
        Navigator.of(context).pop();
      },
      onGalleryTap: () {
        _imgFromGallery(context, fromAddEvent: fromAddEvent);
        Navigator.of(context).pop();
      },
    );
  }

  void getCategories() async {
    classifiedCategoriesModel = await ClassifiedData().getCategories();

    forShowingClassifiedCategoriesModel = await ClassifiedData().getCategories();

    forShowingClassifiedCategoriesModel!.data!.add(ClassifiedCategoriesData(
      id: 0,
      title: "All"
    ));
    forShowingClassifiedCategoriesModel!.data!.sort((a,b)=>a.id!.compareTo(b.id!));
    update();
  }

  getClassifiedAds({int? id}) async {
    classifiedAdModel = await ClassifiedData().getClassifiedAds(id: id);
    update();
  }


  getMyClassifiedAds({int? id}) async {
    myClassifiedAdModel = await ClassifiedData().getClassifiedAds(id: 0,my:true);
    update();
  }

  getClassifiedDetails(int id) async {
    classifiedAdData = await ClassifiedData().getClassifiedDetails(id);
    update();
  }

  deleteClassified(int id,int catId) async {
    final response =
        await ClassifiedData().deleteClassified(classifiedId: id.toString());
    if (response.statusCode == 200) {

    await  getMyClassifiedAds();
      Get.back();

    }
    update();
  }

  void reportClassified({
    int? categoryId,
    int? postId,
  }) async {
    final response = await newsFeedPostServices.reportPost(id: postId,
      type:"classified",);
    if (response.statusCode == 200) {
      BotToast.showText(text: "Classified has been reported");
      getClassifiedAds(id: categoryId);
      // getClassifiedAds();
      Get.back();
    }
  }

  void createAd(int catId, { isUpdate = false, int? adId,String? status,String? week}) async {
    List<form.MultipartFile> cover = [];

    if (deleteMediaIds.isNotEmpty) {
      newsFeedPostServices.deleteClassifiedImages(
          classifiedList: deleteMediaIds);
    }
    for (int i = 0; i < classifiedPhotos.length; i++) {
      if (classifiedPhotos[i].localImage != null) {
        cover.add(form.MultipartFile.fromFileSync(
            classifiedPhotos[i].localImage!.path,
            filename:
            "Image.${classifiedPhotos[i].localImage!.path.split(".").last}",
            contentType: MediaType(
                "image", classifiedPhotos[i].localImage!.path.split(".").last)));
      }
    }
    final response = await ClassifiedData().createAd(
      title: titleController.text,
      description: descriptionController.text,
      price: priceController.text,
      location: locationController.text,
      latitude: lat,
      longitude: long,
      week: week,
      categoryId: catId,
      isUpdate: adId != null,
      adId: adId,
      status: status,
      cover: cover,
    );
    if (response.statusCode == 200) {
      Get.back();

      titleController.clear();
      descriptionController.clear();
      priceController.clear();
      locationController.clear();
      lat = "";
      long = "";
      files.clear();
      classifiedPhotos.clear();
      BotToast.showText(text: "Ad created successfully");
      if(adId != null){
        getClassifiedDetails(adId);
      }

      getClassifiedAds(id: 0);
      getMyClassifiedAds();
    }
  }
}
