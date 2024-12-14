// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:bloodlines/Components/dropDownClass.dart';
import 'package:bloodlines/Components/textFieldComponent.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/View/Pedigree/Data/pedigreeController.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:bloodlines/View/Pedigree/View/addSireOrDam.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/textField.dart';
import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:rich_text_view/rich_text_view.dart';

class AddNewPedigree extends StatefulWidget {
  AddNewPedigree({Key? key}) : super(key: key);

  @override
  State<AddNewPedigree> createState() => _AddNewPedigreeState();
}

class _AddNewPedigreeState extends State<AddNewPedigree> {
  PedigreeController controller = Get.find();
  PedigreeSearchData? data =
      Get.arguments == null ? null : Get.arguments["data"];
  final formKey = GlobalKey<FormState>();

  int? sourceId = Get.arguments == null ? null : Get.arguments["sourceId"];
  bool isTree = Get.arguments == null ? false : Get.arguments["tree"] ?? false;

  int? originalPedigreeId =
      Get.arguments == null ? null : Get.arguments["originalId"];
  String? source = Get.arguments == null ? null : Get.arguments["source"];
  int sireId = 0;
  int damId = 0;
  int? id;

  @override
  void initState() {
    controller.getPedigreeTypeList(searchType: "dam");

    controller.getPedigreeTypeList(searchType: "sire");

    controller.damTextController = RichTextController(
      onMatch: (List<String> matches) {},
      patternMatchMap: {
        RegExp(r"\B@[a-zA-Z0-9]*([\s]{1}[a-zA-Z0-9]*)\b"): poppinsLight(
          fontWeight: FontWeight.w500,
          color: DynamicColors.textColor,
        ),
      },
      regExpCaseSensitive: false,
      deleteOnBack: true,
    );
    controller.sireTextController = RichTextController(
      onMatch: (List<String> matches) {},
      patternMatchMap: {
        RegExp(r"\B@[a-zA-Z0-9]*([\s]{1}[a-zA-Z0-9]*)\b"): poppinsLight(
          fontWeight: FontWeight.w500,
          color: DynamicColors.textColor,
        ),
      },
      regExpCaseSensitive: false,
      deleteOnBack: true,
    );
    // TODO: implement initState
    super.initState();

    if (data != null) {
      id = data!.id;
      controller.damNameController.text =
          data!.dam == null ? "Unknown" : data!.dam!.dogName ?? "Unknown";
      controller.sireNameController.text =
          data!.sire == null ? "Unknown" : data!.sire!.dogName ?? "Unknown";
      controller.ownerNameController.text = data!.ownerName!;
      // controller.searchTextController.text =
      controller.beforeNameController.text = data!.beforeNameTitle ?? "";
      controller.dogNameController.text = data!.dogName!;
      controller.afterNameController.text = data!.afterNameTitle ?? "";
      controller.dobController.value.text =
          data!.dob == null ? "" : DateFormat("yyyy-MM-dd").format(data!.dob!);
      controller.colorController.text = data!.color ?? "";
      controller.weightController.text = data!.weight ?? "";
      controller.descriptionController.text = data!.brief ?? "";
      controller.genderText = data!.sex!.toString().capitalizeFirst!;
      sireId = data!.sireId ?? 0;
      damId = data!.damId ?? 0;
      controller.pedigreePhotos.addAll(data!.photos!);
    }
    if (source != null) {
      controller.noSireOrDam.value = true;
      controller.genderText = "";
      controller.genderText = source == "sire" ? "Male" : "Female";
    }
  }

  clearAll() {
    id = data!.id;
    controller.damNameController.clear();
    controller.sireNameController.clear();
    controller.ownerNameController.clear();
    // controller.searchTextController.text =
    controller.beforeNameController.clear();
    controller.dogNameController.clear();
    controller.afterNameController.clear();
    controller.dobController.value.clear();
    controller.colorController.clear();
    controller.weightController.clear();
    controller.descriptionController.clear();
    // controller.genderText = "";
    sireId = 0;
    damId = 0;
    controller.pedigreePhotos.clear();
  }

  Future<bool> onWillPop() async {
    controller.tempList.clear();
    controller.clear();
    Get.back();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (source != null) {
      return Obx(() {
        return AddSireOrDam(
          source: source!,
          data: data!,
          id: originalPedigreeId!,
          column: controller.noSireOrDam.value == true
              ? Container()
              : buildGetBuilder(context),
          onChanged: (value) {
            clearAll();
            controller.noSireOrDam.value = !controller.noSireOrDam.value;
          },
        );
      });
    }

    return buildWillPopScope(context);
  }

  Widget buildWillPopScope(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: DynamicColors.primaryColorLight,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                onWillPop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: DynamicColors.textColor,
              )),
          backgroundColor: Colors.transparent,
          title: Text(
            "Add New Pedigree",
            style: poppinsSemiBold(
                color: DynamicColors.primaryColor, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: buildGetBuilder(context),
      ),
    );
  }

  Widget buildGetBuilder(BuildContext context) {
    return GetBuilder<PedigreeController>(builder: (controller) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  width: double.infinity,
                  child: DottedBorder(
                    dashPattern: [8],
                    color: DynamicColors.primaryColor,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(6),
                    padding: EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: controller.pedigreePhotos.isEmpty
                          ? Center(
                              child: InkWell(
                                onTap: () {
                                  controller.bottomSheet(context);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: DynamicColors.primaryColor,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Add Photos",
                                      style: poppinsRegular(
                                          color: DynamicColors.accentColor,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Stack(
                              children: [
                                buildGridView(controller),
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      controller.bottomSheet(context);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: DynamicColors.primaryColor,
                                              shape: BoxShape.circle),
                                          child: Center(
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Add Photos",
                                          style: poppinsRegular(
                                              color: DynamicColors.accentColor,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextFieldComponent(
                          title: "Owner's Name",
                          hint: "Colby’s, STP’s, Carver’s, etc",
                          // nameOnly: true,
                          allowDashes: true,
                          underLineBorderColor: DynamicColors.primaryColorRed,
                          controller: controller.ownerNameController),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 5,
                      child: TextFieldComponent(
                          title: "Dog Name",
                          hint: "Dibo, Frisco, Black Widow, etc",
                          nameOnly: true,
                          allowDashes: true,
                          underLineBorderColor: DynamicColors.primaryColorRed,
                          controller: controller.dogNameController),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextFieldComponent(
                          title: "Before Name Titles",
                          hint: "GR CH, CH, etc",
                          underLineBorderColor: DynamicColors.textColor,
                          fromPedigree: true,
                          controller: controller.beforeNameController),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 5,
                      child: TextFieldComponent(
                          title: "After Name Titles",
                          hint: "ROM, POR, etc",
                          fromPedigree: true,
                          underLineBorderColor: DynamicColors.textColor,
                          controller: controller.afterNameController),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: originalPedigreeId != null &&
                              controller.genderText.isNotEmpty
                          ? TextFieldComponent(
                              title: "Sex",
                              hint: controller.genderText,
                              readOnly: true,
                              fromPedigree: true,
                              controller: TextEditingController(
                                  text: controller.genderText))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Sex",
                                  style: poppinsRegular(fontSize: 21),
                                ),
                                DropDownClass(
                                  initialValue: controller.genderText.isEmpty
                                      ? null
                                      : controller.genderText,
                                  list: controller.gender,
                                  hint: "Must Choose",
                                  validationError: "Gender",
                                  listener: (value) {
                                    controller.genderText = value;
                                  },
                                ),
                              ],
                            ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFieldComponent(
                          title: "Color",
                          hint: "Brown, Brindle, Red, etc",
                          underLineBorderColor: DynamicColors.textColor,
                          fromPedigree: true,
                          controller: controller.colorController),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Birthdate",
                            style: poppinsRegular(fontSize: 21),
                          ),
                          Obx(() {
                            return CustomTextField(
                              controller: controller.dobController.value,
                              mainPadding: EdgeInsets.zero,
                              readOnly: true,
                              hint: "04 / 25 / 2020",
                              underLineBorderColor: DynamicColors.textColor,
                              fromPedigree: true,
                              suffixIcon: InkWell(
                                onTap: () {
                                  controller.selectDate(context);
                                },
                                child: Icon(
                                  Linecons.calendar,
                                  color: DynamicColors.primaryColorRed,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 5,
                      child: TextFieldComponent(
                          title: "Weight",
                          fromPedigree: true,
                          hint: "40 (In Pounds)",
                          underLineBorderColor: DynamicColors.textColor,
                          // textInputType: TextInputType.number,
                          controller: controller.weightController),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFieldComponent(
                    title: "Description & Comments",
                    hint: "Type Comments Here",
                    maxLength: 500,
                    fromPedigree: true,
                    underLineBorderColor: DynamicColors.textColor,
                    maxLines: 3,
                    controller: controller.descriptionController),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: kToolbarHeight,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Center(
                    child: CustomButton(
                      text:source == null? "Next":"Add",
                      isLong: false,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          if (controller.genderText.isEmpty) {
                            BotToast.showText(text: "Please select gender");
                          } else if(source == null) {
                            Get.to(() => NextPedigree(
                                sourceId: sourceId,
                                source: source,
                                damId: damId,
                                data: data,
                                isTree: isTree,
                                sireId: sireId,
                                originalPedigreeId: originalPedigreeId,
                                id: id));
                          }else{
                            controller.createPedigree(context,
                                damId: damId,
                                sireId: sireId,
                                sourceId: sourceId,
                                source: source,
                                originalPedigreeId: originalPedigreeId,
                                isTree: isTree,);
                          }
                        }
                      },
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 40),
                      color: DynamicColors.primaryColorRed,
                      borderColor: DynamicColors.primaryColorRed,
                      borderRadius: BorderRadius.circular(5),
                      style:
                          poppinsLight(color: DynamicColors.primaryColorLight),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  GridView buildGridView(PedigreeController controller) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: controller.pedigreePhotos.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [
            controller.pedigreePhotos[index].id != null
                ? OptimizedCacheImage(
                    imageUrl: controller.pedigreePhotos[index].photo!,
                    fit: BoxFit.fill,
                    width: Utils.width(context) / 2)
                : Image.file(
                    File(controller.pedigreePhotos[index].localImage!.path),
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 5),
                child: InkWell(
                  onTap: () {
                    if (controller.pedigreePhotos[index].id != null) {
                      controller.deleteMediaIds
                          .add(controller.pedigreePhotos[index].id.toString());
                    }
                    controller.pedigreePhotos.removeAt(index);
                    controller.update();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: DynamicColors.whiteColor,
                          shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Icon(
                          Icons.close,
                          color: DynamicColors.primaryColor,
                        ),
                      )),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class NextPedigree extends StatefulWidget {
  NextPedigree(
      {Key? key,
      this.sourceId,
      this.source,
      this.id,
      this.data,
      this.originalPedigreeId,
      required this.isTree,
      this.damId = 0,
      this.sireId = 0})
      : super(key: key);
  int damId;
  int sireId;
  int? sourceId;
  int? id;
  int? originalPedigreeId;
  bool isTree;
  String? source;
  PedigreeSearchData? data;

  @override
  State<NextPedigree> createState() => _NextPedigreeState();
}

class _NextPedigreeState extends State<NextPedigree> {
  PedigreeController controller = Get.find();

  RxBool damUnknown = false.obs;

  RxBool sireUnknown = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data != null) {
      for (int i = 0; i < controller.sireMentionList.length; i++) {
        if (controller.sireMentionList[i].id == widget.data!.id.toString()) {
          controller.sireMentionList.remove(controller.sireMentionList[i]);
        }
      }
      for (int i = 0; i < controller.damMentionList.length; i++) {
        if (controller.damMentionList[i].id == widget.data!.id.toString()) {
          controller.damMentionList.remove(controller.damMentionList[i]);
        }
      }
    }
    if (widget.data != null) {
      if (widget.data!.sire != null) {
        controller.sireTextController.text = widget.data!.sire!.fullName ?? "";
        widget.sireId = widget.data!.sire!.id!;
      } else if (widget.data!.dam != null) {
        controller.damTextController.text = widget.data!.dam!.fullName ?? "";
        widget.damId = widget.data!.dam!.id!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColors.primaryColorLight,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: DynamicColors.textColor,
            )),
        backgroundColor: Colors.transparent,
        title: Text(
          "Add New Pedigree",
          style:
              poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 20),
        ),
        centerTitle: true,
        // actions: [
        //   AppBarWidgets(
        //     icon: Icons.info_outline,
        //     onTap: () {
        //       alertCustomMethod(
        //         context,
        //         theme: DynamicColors.primaryColor,
        //         titleText:
        //             "Use the sire & dam search fields above to search sire/dam by name. If the sire/dam search fields do not find the names you are looking for then this means they haven’t been added to the database yet. Check the “Unknown” box for now and click the “Add” button at the bottom of the page. Then add the sire/dam manually by viewing the 4 generation pedigree and clicking on the unknown parent.",
        //         titleStyle: poppinsRegular(fontSize: 13),
        //         click: () {
        //           Get.back();
        //         },
        //         buttonText: "OK",
        //       );
        //     },
        //   )
        // ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Center(
                child: CustomButton(
                  text: widget.id != null ? "Update" : "Add",
                  isLong: false,
                  onTap: () {
                    controller.createPedigree(context,
                        damId: widget.damId,
                        sireId: widget.sireId,
                        sourceId: widget.sourceId,
                        source: widget.source,
                        originalPedigreeId: widget.originalPedigreeId,
                        isTree: widget.isTree,
                        updateId: widget.id);
                  },
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 40),
                  color: DynamicColors.primaryColorRed,
                  borderColor: DynamicColors.primaryColorRed,
                  borderRadius: BorderRadius.circular(5),
                  style: poppinsLight(color: DynamicColors.primaryColorLight),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sire Name",
                            style: poppinsLight(
                                fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Theme(
                              data: Theme.of(context).copyWith(
                                textTheme: TextTheme(
                                  bodyLarge: TextStyle(fontSize: 9),
                                ),
                              ),
                              child: RichTextEditor(
                                  padding: EdgeInsets.zero,
                                  radius: 13,
                                  minLines: 1,
                                  paddingSuggestion: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  margin: EdgeInsets.only(left: 5, top: 12),
                                  textInputAction: TextInputAction.done,
                                  suggestionColor:
                                      DynamicColors.primaryColorLight,
                                  backgroundColor: DynamicColors.lightTextColor,
                                  maxLines: 1,
                                  onChanged: (value) {},
                                  controller: controller.sireTextController,
                                  style: poppinsRegular(),
                                  decoration: InputDecoration(
                                    hintText: "Burt De",
                                    hintStyle: poppinsLight(
                                        color: DynamicColors.accentColor,
                                        fontSize: 15),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: DynamicColors.primaryColorRed),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: DynamicColors.primaryColorRed),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: DynamicColors.primaryColorRed),
                                    ),
                                  ),
                                  suggestionController: SuggestionController(
                                    mentionSymbol: '',
                                    itemHeight: 50,
                                    position: SuggestionPosition.bottom,
                                    intialMentions: controller.sireMentionList,
                                    mentionSuggestions:
                                        controller.sireMentionList,
                                    onSearchMention: (term) async {
                                      return controller.sireMentionList;
                                    },
                                    onMentionSelected: (suggestion) {
                                      widget.sireId = int.parse(suggestion.id!);
                                      // controller.mentionedUsersIds.add(suggestion.id!);
                                      controller.sireTextController.text +=
                                          suggestion.title;
                                      controller.sireTextController.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: controller
                                                      .sireTextController
                                                      .text
                                                      .length));
                                    },
                                  ))),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              sireUnknown(!sireUnknown.value);

                              if (sireUnknown.value == true) {
                                widget.sireId = 0;
                                controller.sireTextController.text = "Unknown";
                              } else {
                                controller.sireTextController.clear();
                              }
                            },
                            child: Obx(() {
                              return Row(
                                children: [
                                  Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        color: sireUnknown.value == true
                                            ? DynamicColors.primaryColorRed
                                            : Colors.grey),
                                    child: Center(
                                        child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12,
                                    )),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "Unknown",
                                    style: poppinsRegular(
                                        color: sireUnknown.value == true
                                            ? DynamicColors.primaryColorRed
                                            : Colors.grey),
                                  )
                                ],
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dam Name",
                            style: poppinsLight(
                                fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              textTheme: TextTheme(
                                bodyLarge: TextStyle(fontSize: 9),
                              ),
                            ),
                            child: RichTextEditor(
                                padding: EdgeInsets.zero,
                                radius: 13,
                                paddingSuggestion: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                margin: EdgeInsets.only(left: 5, top: 12),
                                // minLines: 1,
                                textInputAction: TextInputAction.done,
                                suggestionColor:
                                    DynamicColors.primaryColorLight,
                                backgroundColor: DynamicColors.lightTextColor,
                                maxLines: 1,
                                onChanged: (value) {
                                  // controller.getSearchedData(searchType: "dam");
                                },
                                controller: controller.damTextController,
                                style: poppinsRegular(),
                                decoration: InputDecoration(
                                  hintText: "Burt De",
                                  hintStyle: poppinsLight(
                                      color: DynamicColors.accentColor,
                                      fontSize: 15),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: DynamicColors.primaryColorRed),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: DynamicColors.primaryColorRed),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: DynamicColors.primaryColorRed),
                                  ),
                                ),
                                suggestionController: SuggestionController(
                                  mentionSymbol: '',
                                  itemHeight: 50,
                                  // containerMaxHeight: 200,
                                  position: SuggestionPosition.bottom,
                                  intialMentions: controller.damMentionList,
                                  mentionSuggestions: controller.damMentionList,
                                  onSearchMention: (term) async {
                                    return controller.damMentionList;
                                  },
                                  onMentionSelected: (suggestion) {
                                    widget.damId = int.parse(suggestion.id!);
                                    controller.damTextController.text +=
                                        suggestion.title;
                                    controller.damTextController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: controller.damTextController
                                                .text.length));
                                  },
                                )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              damUnknown(!damUnknown.value);

                              if (damUnknown.value == true) {
                                widget.damId = 0;
                                controller.damTextController.text = "Unknown";
                              } else {
                                controller.damTextController.clear();
                              }
                            },
                            child: Obx(() {
                              return Row(
                                children: [
                                  Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        color: damUnknown.value == true
                                            ? DynamicColors.primaryColorRed
                                            : Colors.grey),
                                    child: Center(
                                        child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12,
                                    )),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "Unknown",
                                    style: poppinsRegular(
                                        color: damUnknown.value == true
                                            ? DynamicColors.primaryColorRed
                                            : Colors.grey),
                                  )
                                ],
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: kToolbarHeight,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Use the sire & dam search fields above to search sire/dam by name. If the sire/dam search fields do not find the names you are looking for then this means they haven’t been added to the database yet. Check the “Unknown” box for now and click the “Add” button at the bottom of the page. Then add the sire/dam manually by viewing the 4 generation pedigree and clicking on the unknown parent.",
                  style: poppinsRegular(
                      fontSize: 13,
                      color: DynamicColors.textColor.withOpacity(0.6)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
