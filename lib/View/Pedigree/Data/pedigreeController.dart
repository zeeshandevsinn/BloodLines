// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Pedigree/Model/cells.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:http_parser/http_parser.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/imageBottomSheet.dart';
import 'package:bloodlines/View/newsFeed/data/newsFeedPostServices.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_crop/multi_image_crop.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart' as form;
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:rich_text_view/rich_text_view.dart';

//owner before kutta after
class PedigreeController extends GetxController {
  // List<XFile> pedigreeCover = [];
  FeedController controller = Get.find();
  List<XFile> tempList = [];
  final ImagePicker _picker = ImagePicker();
  final damNameController = TextEditingController();
  final sireNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final searchTextController = TextEditingController();
  final beforeNameController = TextEditingController();
  final dogNameController = TextEditingController();
  final afterNameController = TextEditingController();
  final dobController = TextEditingController().obs;
  final colorController = TextEditingController();
  final weightController = TextEditingController();
  final descriptionController = TextEditingController();
  NewsFeedPostServices newsFeedPostServices = NewsFeedPostServices();
  PedigreeSearchModel? pedigreeSearchModel;
  PedigreeModel? damSearchModel;
  PedigreeModel? sireSearchModel;
  List<Mention> damMentionList = [];
  List<Mention> sireMentionList = [];
  PedigreeModel? pedigreeModel;
  PedigreeModel? myPedigreeModel;
  SinglePedigreeModel? singlePedigreeModel;
  late RichTextController damTextController;
  late RichTextController sireTextController;
  RxBool noSireOrDam = false.obs;

  String genderText = "";
  String beforeName = "";
  List<String> deleteMediaIds = [];
  List<PedigreePhotos> pedigreePhotos = [];
  List<String> gender = [
    "Male",
    "Female",
  ];
  List<String> beforeNameList = [
    "Male",
    "Female",
    "Test Mating",
  ];
  List<Cells> cells = [];
  List<Cells> myCells = [];
  getCameraPermission() async {
    await [
      Permission.storage,
      Permission.camera,
      //add more permission to request here.
    ].request();
  }

  @override
  void onInit() {
    super.onInit();

    getPedigreeTypeList(searchType: "dam");
    getPedigreeTypeList(searchType: "sire");
  }

  Future<List<XFile>> getImage(ImageSource imageSource) async {
    if (imageSource == ImageSource.camera) {
      XFile? file = await _picker.pickImage(
          source: imageSource, imageQuality: 50, maxHeight: 680, maxWidth: 720);
      if (file != null) {
        tempList.add(file);
      }
      return tempList;
    } else {
      return _picker.pickMultiImage(
          imageQuality: 50, maxHeight: 680, maxWidth: 720);
    }
  }

  getMultiple(context, {fromProfile = false}) {
    MultiImageCrop.startCropping(
        context: context,
        aspectRatio: 3 / 3,
        activeColor: Colors.amber,
        pixelRatio: 3,
        isLeading: false,
        files: List.generate(
            tempList.length, (index) => File(tempList[index].path)),
        callBack: (List<File> images) {
          for (var element in images) {
            // pedigreeCover.add(XFile(element.path));
            pedigreePhotos.add(PedigreePhotos(localImage: XFile(element.path)));
          }
          update();
        });
    tempList.clear();
  }

  _profileImgFromGallery(context, ImageSource source,
      {fromProfile = false}) async {
    try {
      tempList = await getImage(source);
      if (tempList.isNotEmpty) {
        getMultiple(context, fromProfile: fromProfile);
      }
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
  }

  bottomSheet(context) {
    ImageBottomSheet.bottomSheet(
      context,
      onCameraTap: () async {
        _profileImgFromGallery(
          context,
          ImageSource.camera,
        );

        Navigator.of(context).pop();
      },
      onGalleryTap: () {
        _profileImgFromGallery(context, ImageSource.gallery);
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> selectDate(BuildContext context, {fromProfile = false}) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1960, 01, 01),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                    onPrimary: DynamicColors.whiteColor, // selected text color
                    onSurface:
                        DynamicColors.primaryColorRed, // default text color
                    primary: DynamicColors.primaryColorRed // circle color
                    ),
                dialogBackgroundColor: DynamicColors.primaryColorLight,
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        textStyle: poppinsRegular(
                          color: DynamicColors.primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                        // color of button's letters
                        backgroundColor:
                            DynamicColors.primaryColorLight, // Background color
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.transparent,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(50))))),
            child: child!,
          );
        });
    if (pickedDate != null) {
      dobController.value.text = DateFormat("yyyy-MM-dd").format(pickedDate);
    }
  }

  createPedigree(context,
      {int? damId,
      int? sireId,
      int? originalPedigreeId,
      int? sourceId,
      String? source,
      bool fromSireOnly = false,
      required bool isTree,
      int? updateId}) async {
    List<form.MultipartFile> multiPart = [];

    if (deleteMediaIds.isNotEmpty) {
      newsFeedPostServices.deletePedigreeImages(
          pedigreeList: deleteMediaIds, id: updateId!);
    }

    for (int i = 0; i < pedigreePhotos.length; i++) {
      if (pedigreePhotos[i].localImage != null) {
        multiPart.add(form.MultipartFile.fromFileSync(
            pedigreePhotos[i].localImage!.path,
            filename:
                "Image.${pedigreePhotos[i].localImage!.path.split(".").last}",
            contentType: MediaType(
                "image", pedigreePhotos[i].localImage!.path.split(".").last)));
      }
    }
    final response = await newsFeedPostServices.createPedigree(
      ownerName: ownerNameController.text,
      beforeName: beforeNameController.text,
      dogName: dogNameController.text,
      afterName: afterNameController.text,
      damName: damId,
      sireName: sireId,
      dogSex: genderText.toLowerCase(),
      source: source,
      sourceId: sourceId,
      updateId: updateId,
      dogColor: colorController.text,
      dogWeight: weightController.text,
      description: descriptionController.text,
      birthday: dobController.value.text,
      media: multiPart,
    );

    if (response.statusCode == 200) {
      getAllPedigrees();
      getMyPedigrees();
      clear();
      if (fromSireOnly == false) {
        if (originalPedigreeId != null) {
          Get.offNamedUntil(
              Routes.pedigreeTree,
              arguments: {"id": originalPedigreeId},
              ModalRoute.withName(Routes.dashboard));
          controller.tabIndex.value = 1;
        } else {
          Get.offNamedUntil(
              Routes.pedigreeTree,
              arguments: {"id": response.data["data"]["id"]},
              ModalRoute.withName(Routes.dashboard));
          controller.tabIndex.value = 1;
        }
      } else {
        Get.back();
      }
      BotToast.showText(
          text:
              "Pedigree ${updateId != null ? 'Updated' : 'Created'} Successfully");
    }
  }

  clear() {
    ownerNameController.clear();
    beforeNameController.clear();
    dogNameController.clear();
    afterNameController.clear();
    colorController.clear();
    weightController.clear();
    pedigreePhotos.clear();
    descriptionController.clear();
    deleteMediaIds.clear();
    dobController.value.clear();
    genderText = "";
  }

  getSearchedData({required String searchType, required String value}) async {
    form.FormData data = form.FormData.fromMap(
      {
        "search_text": searchTextController.text,
        "search_type": searchType //dam,sire
      },
    );
    final response = await Api.singleton.post(data, 'search');
    if (response.statusCode == 200) {
      pedigreeSearchModel = PedigreeSearchModel.fromJson(response.data["data"]);
      update();
    }
  }

  getPedigreeTypeList({required String searchType}) async {
    final response =
        await Api.singleton.get(searchType == "dam" ? 'dam-list' : 'sire-list');
    if (response.statusCode == 200) {
      if (searchType == "dam") {
        damMentionList.clear();
        damSearchModel = PedigreeModel.fromJson(response.data);
        damMentionList.addAll(damSearchModel!.data!.map((u) => Mention(
            id: u.id.toString(),
            imageURL: u.photos![0].photo!,
            subtitle: '',
            title: u.fullName ?? "")));
      } else {
        sireMentionList.clear();
        sireSearchModel = PedigreeModel.fromJson(response.data);
        sireMentionList.addAll(sireSearchModel!.data!.map((u) => Mention(
            id: u.id.toString(),
            imageURL: u.photos![0].photo!,
            subtitle: '',
            title: u.fullName ?? "")));
        // sireMentionList.add(
        //     Mention(imageURL: "https://bloodlines.gologonow.app/uploads/pedigree/default.png", id: "0", subtitle: "", title: "Unknown"));
      }
      update();
    }
  }

  getAllPedigrees({bool fromForum = false, String? url}) async {
    pedigreeModel = await newsFeedPostServices.getPedigrees(url: url);
    if (fromForum == false) {
      if (pedigreeModel != null) {
        if (pedigreeModel!.data!.isNotEmpty) {
          cells.clear();
          for (int i = 0; i < pedigreeModel!.data!.length; i++) {
            cells.add(
              Cells([
                DataCell(
                  SizedBox(
                    width: Get.width / 4,
                    child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.toNamed(Routes.pedigreeTree,
                              arguments: {"id": pedigreeModel!.data![i].id});
                        },
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(children: [
                            TextSpan(
                                text: "${pedigreeModel!.data![i].ownerName} ",
                                style: poppinsRegular(
                                    fontSize: 12,
                                    color: pedigreeModel!
                                                .data![i].beforeNameTitle ==
                                            null
                                        ? DynamicColors.primaryColor
                                        : DynamicColors.primaryColorRed)),
                            TextSpan(
                                text: pedigreeModel!.data![i].beforeNameTitle ==
                                        null
                                    ? ""
                                    : "${pedigreeModel!.data![i].beforeNameTitle!.toUpperCase()} ",
                                style: poppinsRegular(
                                    fontSize: 12,
                                    color: pedigreeModel!
                                                .data![i].beforeNameTitle ==
                                            null
                                        ? DynamicColors.primaryColor
                                        : DynamicColors.primaryColorRed)),
                            TextSpan(
                                text: "${pedigreeModel!.data![i].dogName} ",
                                style: poppinsRegular(
                                    fontSize: 12,
                                    color: pedigreeModel!
                                                .data![i].beforeNameTitle ==
                                            null
                                        ? DynamicColors.primaryColor
                                        : DynamicColors.primaryColorRed)),
                            TextSpan(
                                text: pedigreeModel!.data![i].afterNameTitle ==
                                        null
                                    ? ""
                                    : "${pedigreeModel!.data![i].afterNameTitle!.toUpperCase()} ",
                                style: poppinsRegular(
                                    fontSize: 12,
                                    color: pedigreeModel!
                                                .data![i].beforeNameTitle ==
                                            null
                                        ? DynamicColors.primaryColor
                                        : DynamicColors.primaryColorRed)),
                          ]),
                        )

                        // Text("${pedigreeModel!.data![i].fullName}")

                        ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: Get.width / 4,
                    child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (pedigreeModel!.data![i].sire != null) {
                            Get.toNamed(Routes.pedigreeTree, arguments: {
                              "id": pedigreeModel!.data![i].sire!.id
                            });
                          }
                        },
                        child: pedigreeModel!.data![i].sire == null
                            ? RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    text: "Unknown",
                                    style: poppinsRegular(
                                        fontSize: 12,
                                        color: DynamicColors.primaryColor)))
                            : RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          "${pedigreeModel!.data![i].sire!.ownerName} ",
                                      style: poppinsRegular(
                                          fontSize: 12,
                                          color: pedigreeModel!.data![i].sire!
                                                      .beforeNameTitle ==
                                                  null
                                              ? DynamicColors.primaryColor
                                              : DynamicColors.primaryColorRed)),
                                  TextSpan(
                                      text: pedigreeModel!.data![i].sire!
                                                  .beforeNameTitle ==
                                              null
                                          ? ""
                                          : "${pedigreeModel!.data![i].sire!.beforeNameTitle!.toUpperCase()} ",
                                      style: poppinsRegular(
                                          fontSize: 12,
                                          color: pedigreeModel!.data![i].sire!
                                                      .beforeNameTitle ==
                                                  null
                                              ? DynamicColors.primaryColor
                                              : DynamicColors.primaryColorRed)),
                                  TextSpan(
                                      text:
                                          "${pedigreeModel!.data![i].sire!.dogName} ",
                                      style: poppinsRegular(
                                          fontSize: 12,
                                          color: pedigreeModel!.data![i].sire!
                                                      .beforeNameTitle ==
                                                  null
                                              ? DynamicColors.primaryColor
                                              : DynamicColors.primaryColorRed)),
                                  TextSpan(
                                      text: pedigreeModel!.data![i].sire!
                                                  .afterNameTitle ==
                                              null
                                          ? ""
                                          : "${pedigreeModel!.data![i].sire!.afterNameTitle!.toUpperCase()} ",
                                      style: poppinsRegular(
                                          fontSize: 12,
                                          color: pedigreeModel!.data![i].sire!
                                                      .beforeNameTitle ==
                                                  null
                                              ? DynamicColors.primaryColor
                                              : DynamicColors.primaryColorRed)),
                                ]),
                              )),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: Get.width / 4,
                    child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (pedigreeModel!.data![i].dam != null) {
                            Get.toNamed(Routes.pedigreeTree, arguments: {
                              "id": pedigreeModel!.data![i].dam!.id
                            });
                          }
                        },
                        child: pedigreeModel!.data![i].dam == null
                            ? RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    text: "Unknown",
                                    style: poppinsRegular(
                                        fontSize: 12,
                                        color: DynamicColors.primaryColor)))
                            : RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          "${pedigreeModel!.data![i].dam!.ownerName} ",
                                      style: poppinsRegular(
                                          fontSize: 12,
                                          color: pedigreeModel!.data![i].dam!
                                                      .beforeNameTitle ==
                                                  null
                                              ? DynamicColors.primaryColor
                                              : DynamicColors.primaryColorRed)),
                                  TextSpan(
                                      text: pedigreeModel!.data![i].dam!
                                                  .beforeNameTitle ==
                                              null
                                          ? ""
                                          : "${pedigreeModel!.data![i].dam!.beforeNameTitle!.toUpperCase()} ",
                                      style: poppinsRegular(
                                          fontSize: 12,
                                          color: pedigreeModel!.data![i].dam!
                                                      .beforeNameTitle ==
                                                  null
                                              ? DynamicColors.primaryColor
                                              : DynamicColors.primaryColorRed)),
                                  TextSpan(
                                      text:
                                          "${pedigreeModel!.data![i].dam!.dogName} ",
                                      style: poppinsRegular(
                                          fontSize: 12,
                                          color: pedigreeModel!.data![i].dam!
                                                      .beforeNameTitle ==
                                                  null
                                              ? DynamicColors.primaryColor
                                              : DynamicColors.primaryColorRed)),
                                  TextSpan(
                                      text: pedigreeModel!.data![i].dam!
                                                  .afterNameTitle ==
                                              null
                                          ? ""
                                          : "${pedigreeModel!.data![i].dam!.afterNameTitle!.toUpperCase()} ",
                                      style: poppinsRegular(
                                          fontSize: 12,
                                          color: pedigreeModel!.data![i].dam!
                                                      .beforeNameTitle ==
                                                  null
                                              ? DynamicColors.primaryColor
                                              : DynamicColors.primaryColorRed)),
                                ]),
                              )),
                  ),
                ),
              ]),
            );
          }
          // update();
        }
      }
    }
    update();
  }

  getMyPedigrees() async {
    myPedigreeModel =
        await newsFeedPostServices.getPedigrees(url: "my-pedigree-list");
    if (myPedigreeModel != null) {
      if (myPedigreeModel!.data!.isNotEmpty) {
        myCells.clear();
        for (int i = 0; i < myPedigreeModel!.data!.length; i++) {
          myCells.add(
            Cells([
              DataCell(
                SizedBox(
                  width: Get.width / 4,
                  child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Get.toNamed(Routes.pedigreeTree,
                            arguments: {"id": myPedigreeModel!.data![i].id});
                      },
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(children: [
                          TextSpan(
                              text: "${myPedigreeModel!.data![i].ownerName} ",
                              style: poppinsRegular(
                                  fontSize: 12,
                                  color: myPedigreeModel!
                                              .data![i].beforeNameTitle ==
                                          null
                                      ? DynamicColors.primaryColor
                                      : DynamicColors.primaryColorRed)),
                          TextSpan(
                              text: myPedigreeModel!.data![i].beforeNameTitle ==
                                      null
                                  ? ""
                                  : "${myPedigreeModel!.data![i].beforeNameTitle!.toUpperCase()} ",
                              style: poppinsRegular(
                                  fontSize: 12,
                                  color: myPedigreeModel!
                                              .data![i].beforeNameTitle ==
                                          null
                                      ? DynamicColors.primaryColor
                                      : DynamicColors.primaryColorRed)),
                          TextSpan(
                              text: "${myPedigreeModel!.data![i].dogName} ",
                              style: poppinsRegular(
                                  fontSize: 12,
                                  color: myPedigreeModel!
                                              .data![i].beforeNameTitle ==
                                          null
                                      ? DynamicColors.primaryColor
                                      : DynamicColors.primaryColorRed)),
                          TextSpan(
                              text: myPedigreeModel!.data![i].afterNameTitle ==
                                      null
                                  ? ""
                                  : "${myPedigreeModel!.data![i].afterNameTitle!.toUpperCase()} ",
                              style: poppinsRegular(
                                  fontSize: 12,
                                  color: myPedigreeModel!
                                              .data![i].beforeNameTitle ==
                                          null
                                      ? DynamicColors.primaryColor
                                      : DynamicColors.primaryColorRed)),
                        ]),
                      )

                      // Text("${myPedigreeModel!.data![i].fullName}")

                      ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: Get.width / 4,
                  child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (myPedigreeModel!.data![i].sire != null) {
                          Get.toNamed(Routes.pedigreeTree, arguments: {
                            "id": myPedigreeModel!.data![i].sire!.id
                          });
                        }
                      },
                      child: myPedigreeModel!.data![i].sire == null
                          ? RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                  text: "Unknown",
                                  style: poppinsRegular(
                                      fontSize: 12,
                                      color: DynamicColors.primaryColor)))
                          : RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(children: [
                                TextSpan(
                                    text:
                                        "${myPedigreeModel!.data![i].sire!.ownerName} ",
                                    style: poppinsRegular(
                                        fontSize: 12,
                                        color: myPedigreeModel!.data![i].sire!
                                                    .beforeNameTitle ==
                                                null
                                            ? DynamicColors.primaryColor
                                            : DynamicColors.primaryColorRed)),
                                TextSpan(
                                    text: myPedigreeModel!.data![i].sire!
                                                .beforeNameTitle ==
                                            null
                                        ? ""
                                        : "${myPedigreeModel!.data![i].sire!.beforeNameTitle!.toUpperCase()} ",
                                    style: poppinsRegular(
                                        fontSize: 12,
                                        color: myPedigreeModel!.data![i].sire!
                                                    .beforeNameTitle ==
                                                null
                                            ? DynamicColors.primaryColor
                                            : DynamicColors.primaryColorRed)),
                                TextSpan(
                                    text:
                                        "${myPedigreeModel!.data![i].sire!.dogName} ",
                                    style: poppinsRegular(
                                        fontSize: 12,
                                        color: myPedigreeModel!.data![i].sire!
                                                    .beforeNameTitle ==
                                                null
                                            ? DynamicColors.primaryColor
                                            : DynamicColors.primaryColorRed)),
                                TextSpan(
                                    text: myPedigreeModel!.data![i].sire!
                                                .afterNameTitle ==
                                            null
                                        ? ""
                                        : "${myPedigreeModel!.data![i].sire!.afterNameTitle!.toUpperCase()} ",
                                    style: poppinsRegular(
                                        fontSize: 12,
                                        color: myPedigreeModel!.data![i].sire!
                                                    .beforeNameTitle ==
                                                null
                                            ? DynamicColors.primaryColor
                                            : DynamicColors.primaryColorRed)),
                              ]),
                            )),
                ),
              ),
              DataCell(
                SizedBox(
                  width: Get.width / 4,
                  child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (myPedigreeModel!.data![i].dam != null) {
                          Get.toNamed(Routes.pedigreeTree, arguments: {
                            "id": myPedigreeModel!.data![i].dam!.id
                          });
                        }
                      },
                      child: myPedigreeModel!.data![i].dam == null
                          ? RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                  text: "Unknown",
                                  style: poppinsRegular(
                                      fontSize: 12,
                                      color: DynamicColors.primaryColor)))
                          : RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(children: [
                                TextSpan(
                                    text:
                                        "${myPedigreeModel!.data![i].dam!.ownerName} ",
                                    style: poppinsRegular(
                                        fontSize: 12,
                                        color: myPedigreeModel!.data![i].dam!
                                                    .beforeNameTitle ==
                                                null
                                            ? DynamicColors.primaryColor
                                            : DynamicColors.primaryColorRed)),
                                TextSpan(
                                    text: myPedigreeModel!.data![i].dam!
                                                .beforeNameTitle ==
                                            null
                                        ? ""
                                        : "${myPedigreeModel!.data![i].dam!.beforeNameTitle!.toUpperCase()} ",
                                    style: poppinsRegular(
                                        fontSize: 12,
                                        color: myPedigreeModel!.data![i].dam!
                                                    .beforeNameTitle ==
                                                null
                                            ? DynamicColors.primaryColor
                                            : DynamicColors.primaryColorRed)),
                                TextSpan(
                                    text:
                                        "${myPedigreeModel!.data![i].dam!.dogName} ",
                                    style: poppinsRegular(
                                        fontSize: 12,
                                        color: myPedigreeModel!.data![i].dam!
                                                    .beforeNameTitle ==
                                                null
                                            ? DynamicColors.primaryColor
                                            : DynamicColors.primaryColorRed)),
                                TextSpan(
                                    text: myPedigreeModel!
                                                .data![i].dam!.afterNameTitle ==
                                            null
                                        ? ""
                                        : "${myPedigreeModel!.data![i].dam!.afterNameTitle!.toUpperCase()} ",
                                    style: poppinsRegular(
                                        fontSize: 12,
                                        color: myPedigreeModel!.data![i].dam!
                                                    .beforeNameTitle ==
                                                null
                                            ? DynamicColors.primaryColor
                                            : DynamicColors.primaryColorRed)),
                              ]),
                            )),
                ),
              ),
            ]),
          );
        }
        //
      }
    }
    update();
  }

  getSinglePedigree(int id) async {
    singlePedigreeModel = await newsFeedPostServices.getSinglePedigree(id);
    update();
  }

  deletePedigree(int id) async {
    final response = await newsFeedPostServices.deletePedigree(id: id);
    if (response.statusCode == 200) {
      getAllPedigrees();
      getMyPedigrees();
      getPedigreeTypeList(searchType: "dam");
      getPedigreeTypeList(searchType: "sire");
      Get.offNamedUntil(
          Routes.dashboard, ModalRoute.withName(Routes.dashboard));
      controller.tabIndex.value = 1;
      Get.back();
      BotToast.showText(text: "Pedigree Deleted Successfully");
    }
  }
}
