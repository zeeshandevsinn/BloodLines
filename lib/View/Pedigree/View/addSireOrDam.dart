// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/View/Pedigree/Data/pedigreeController.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rich_text_view/rich_text_view.dart';

class AddSireOrDam extends StatelessWidget {
  AddSireOrDam({
    Key? key,

    required this.column,
    required this.data,
    required this.source,
    required this.id,
    required this.onChanged,
  }) : super(key: key);
  int? sourceId;
  int id;
  String source;
  PedigreeController controller = Get.find();
  Widget column;
  PedigreeSearchData data;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    // String value =
    //     "cat cake the ate salman osama hamza salman osama hello brother hello";
    // List<String> a = value.split(' ');
    //
    // List<String> a = [];
    // String b = "";
    // value.split(' ');
    // value.codeUnits.forEach((e) {
    //   String s = String.fromCharCode(e);
    //   if (s != " ") {
    //     b = b + String.fromCharCode(e);
    //   } else {
    //     if (!a.contains(b)) {
    //       a.add(b);
    //     }
    //     b = "";
    //   }
    // });
    // a.sort((a, b) => a.compareTo(b));
    // String s = a.toString().replaceAll(",", "");
    // print(s);
    return Scaffold(
      backgroundColor: DynamicColors.primaryColorLight,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: DynamicColors.textColor,
            )),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          "Add ${source.capitalizeFirst}",
          style:
          poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 10,),
              switchSireOrDam(context),
              SizedBox(height: 10,),
              Obx(() {
                return CheckboxListTile(value: !controller.noSireOrDam.value,
                    onChanged:onChanged,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Select If ${source
                          .capitalizeFirst} Name Cannot Be Found To Add To Database Manually",
                      style: poppinsRegular(color: Colors.black, fontSize: 13),
                    ));
              }),
              SizedBox(height: 10,),
              Obx(() {if(controller.noSireOrDam.value == false){
                return Container();
              }
                return Column(
                  children: [
                    Center(
                      child: CustomButton(
                        text: "Add ${source.capitalizeFirst}",
                        isLong: false,
                        onTap: () {
                          if(sourceId != null){
                            controller.createPedigree(context,
                                // sourceId: sourceId,
                                isTree: true,
                                damId: source == "sire"?0:sourceId,
                                sireId: source == "dam"?0:sourceId,
                                fromSireOnly: true,
                                source: source,
                                updateId: id);
                          }else{
                            BotToast.showText(text: "You didn't select $source yet");
                          }
                        },
                        padding: EdgeInsets.symmetric(vertical: 7,
                            horizontal: 40),
                        color: DynamicColors.primaryColorRed,
                        borderColor: DynamicColors.primaryColorRed,
                        borderRadius: BorderRadius.circular(5),
                        style: poppinsLight(color: DynamicColors
                            .primaryColorLight),
                      ),
                    ),
                    SizedBox(height: 10,),
                  ],
                );
              }),
              column
            ],
          ),
        ),
      ),
    );
  }

  Widget switchSireOrDam(context) {
    switch (source) {
      case "sire":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search Sire By Name",
              style: poppinsLight(fontSize: 21, fontWeight: FontWeight.bold),
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
                    paddingSuggestion:
                    EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    margin: EdgeInsets.only(left: 5, top: 12),
                    textInputAction: TextInputAction.done,
                    suggestionColor: DynamicColors.primaryColorLight,
                    backgroundColor: DynamicColors.lightTextColor,
                    maxLines: 4,
                    onChanged: (value) {},
                    controller: controller.sireTextController,
                    style: poppinsRegular(),
                    decoration: InputDecoration(
                      hintText: "Burt De",
                      hintStyle: poppinsLight(
                          color: DynamicColors.accentColor, fontSize: 15),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: DynamicColors.primaryColorRed),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: DynamicColors.primaryColorRed),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: DynamicColors.primaryColorRed),
                      ),
                    ),
                    suggestionController: SuggestionController(
                      mentionSymbol: '',
                      itemHeight: 50,
                      position: SuggestionPosition.bottom,
                      intialMentions: controller.sireMentionList,
                      mentionSuggestions: controller.sireMentionList,
                      onSearchMention: (term) async {
                        return controller.sireMentionList;
                      },
                      onMentionSelected: (suggestion) {
                        sourceId = int.parse(suggestion.id!);
                        // controller.mentionedUsersIds.add(suggestion.id!);
                        controller.sireTextController.text += suggestion.title;
                        controller.sireTextController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset:
                                controller.sireTextController.text.length));
                      },
                    ))),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search Dam By Name",
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
                  suggestionColor: DynamicColors.primaryColorLight,
                  backgroundColor: DynamicColors.lightTextColor,
                  // maxLines: 4,
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
                      sourceId = int.parse(suggestion.id!);
                      controller.damTextController.text +=
                          suggestion.title;
                      controller.damTextController.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: controller
                                  .damTextController.text.length));
                    },
                  )),
            ),

          ],
        );
    }
  }
}
