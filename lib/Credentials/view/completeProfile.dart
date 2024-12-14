// ignore_for_file: prefer_null_aware_operators

import 'dart:io';

import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/dropDownClass.dart';
import 'package:bloodlines/Components/textFieldComponent.dart';
import 'package:bloodlines/userModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Dummy.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/textField.dart';
import 'package:bloodlines/Credentials/controller/credentialController.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class CompleteProfile extends StatefulWidget {
  CompleteProfile({Key? key}) : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  CredentialController controller = Get.find();

  final formKey = GlobalKey<FormState>();

  String? cover;
  String? profile;
  RxBool isSelected = false.obs;
  Rx<PhoneNumber> number = PhoneNumber(isoCode: 'US').obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments != null) {
      UserModel data = Get.arguments["data"];
      if (data.profile != null) {
        controller.nameController.text = data.profile!.fullname ?? "";
        controller.phoneController.text = data.profile!.phone ?? "";
        controller.aboutController.text = data.profile!.about ?? "";
        controller.countryController.text = data.profile!.country ?? "";
        controller.stateController.text = data.profile!.state ?? "";
        controller.cityController.text = data.profile!.city ?? "";
        controller.zipCodeController.text = data.profile!.zipcode ?? "";
        controller.genderText = data.profile!.gender;
        controller.dobController.value.text = data.profile!.age ?? "";

        if(data.profile!.coverImage != checkImageUrl("cover")){
          cover = data.profile!.coverImage;
        }
        if(data.profile!.profileImage != checkImageUrl("profile")){
          profile = data.profile!.profileImage;
        }

        getPhone(data.profile!.phone);
      }
    }
  }

  getPhone(profile) async {
    if (profile != null) {
      var num = await PhoneNumber.getRegionInfoFromPhoneNumber(profile!);
      var a = await PhoneNumber.getParsableNumber(num);
      number.value = PhoneNumber(
          phoneNumber: a, isoCode: num.isoCode, dialCode: num.dialCode);
      controller.phoneController.text = profile!;
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
          "Complete Your Profile",
          style:
          poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 22),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(14),
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              height: 2,
              width: double.infinity,
              color: DynamicColors.accentColor,
            ),
          ),
        ),
      ),
      body: GetBuilder<CredentialController>(builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                  ),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 3.5,
                    child: Stack(
                      children: [
                        DottedBorder(
                          dashPattern: [8],
                          color: DynamicColors.primaryColor,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(6),
                          padding: EdgeInsets.all(6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            child: SizedBox(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height / 4.5,
                              width: double.infinity,
                              child: cover != null ?
                              Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: OptimizedCacheImage(
                                      imageUrl:
                                      cover!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                        onTap: () {
                                          cover = null;
                                          controller.update();
                                        },
                                        child: Icon(
                                          FontAwesome.cancel_circled,
                                          color: DynamicColors.textColor,
                                        )),
                                  )
                                ],
                              )
                                  : controller.cover == null
                                  ? InkWell(
                                onTap: () {
                                  controller.profileBottomSheet(context);
                                },
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Upload Cover Photo",
                                      style: poppinsRegular(
                                          color:
                                          DynamicColors.primaryColor,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Image.asset(
                                      "assets/image.png",
                                      height: 23,
                                      color: DynamicColors.primaryColor,
                                    ),
                                  ],
                                ),
                              )
                                  : Stack(
                                children: [
                                  Image.file(
                                    File(controller.cover!.path),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    alignment: Alignment.topCenter,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                        onTap: () {
                                          controller.cover = null;
                                          controller.update();
                                        },
                                        child: Icon(
                                          FontAwesome.cancel_circled,
                                          color: DynamicColors.textColor,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 20,
                          child: Container(
                            color: Colors.white,
                            child: DottedBorder(
                              dashPattern: [8],
                              color: DynamicColors.primaryColor,
                              borderType: BorderType.RRect,
                              radius: Radius.circular(6),
                              padding: EdgeInsets.all(6),
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(12)),
                                child: SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: profile != null ?
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: OptimizedCacheImage(
                                          imageUrl:
                                          profile!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                            onTap: () {
                                              profile = null;
                                              controller.update();
                                            },
                                            child: Icon(
                                              FontAwesome.cancel_circled,
                                              color:
                                              DynamicColors.textColor,
                                            )),
                                      )
                                    ],
                                  ) : controller.profile == null
                                      ? InkWell(
                                    onTap: () {
                                      controller.profileBottomSheet(
                                          context,
                                          fromProfile: true);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/image.png",
                                          height: 23,
                                          color:
                                          DynamicColors.primaryColor,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Profile",
                                          style: poppinsRegular(
                                              color: DynamicColors
                                                  .primaryColor,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  )
                                      : Stack(
                                    children: [
                                      Image.file(
                                        File(controller.profile!.path),
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                            onTap: () {
                                              controller.profile = null;
                                              controller.update();
                                            },
                                            child: Icon(
                                              FontAwesome.cancel_circled,
                                              color:
                                              DynamicColors.textColor,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "Your Phone Number",
                    style: poppinsRegular(fontSize: 21),
                  ),
                  Obx(() {
                    return InternationalPhoneNumberInput(
                      isFromSignUp: true,
                      onInputChanged: (PhoneNumber number) {
                        //print(number.phoneNumber);

                        validateMobile(number.phoneNumber!);
                        controller.update();
                        // print(number.phoneNumber);
                        controller.phoneController.text =
                            number.phoneNumber.toString();
                      },
                      inputDecoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 0,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: DynamicColors.primaryColorRed, width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: DynamicColors.primaryColorRed, width: 2),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: DynamicColors.primaryColorRed, width: 1),
                        ),
                        labelText: "Enter Phone No",
                        labelStyle: poppinsRegular(
                          fontSize: 14,
                          color: DynamicColors.accentColor.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      labelStyle: poppinsRegular(
                        fontSize: 14,
                        color: DynamicColors.accentColor.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                      ),
                      onInputValidated: (bool value) {},
                      onFieldSubmitted: (value) {
                        // getPhoneNumber(signUpController.phoneController.text);
                      },
                      textStyle: poppinsRegular(
                        fontSize: 15,
                        color: DynamicColors.textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,

                      selectorTextStyle: poppinsRegular(
                        fontSize: 15,
                        color: DynamicColors.accentColor.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: "Enter Phone No",
                      initialValue: number.value,
                      formatInput: false,
                      spaceBetweenSelectorAndTextField: 0,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: InputBorder.none,
                      onSaved: (PhoneNumber number) {
                        // print('On Saved: $number');
                      },
                      // textFieldController: controller.phoneController,
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Gender",
                    style: poppinsRegular(fontSize: 21),
                  ),
                  DropDownClass(
                    initialValue: controller.genderText == null
                        ? null
                        : controller.genderText
                        .toString()
                        .capitalize,
                    list: controller.gender,
                    hint: "Male",
                    validationError: "Gender",
                    listener: (val) {
                      controller.genderText = val;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Date of Birth",
                    style: poppinsRegular(fontSize: 21),
                  ),
                  Obx(() {
                    return CustomTextField(
                      controller: controller.dobController.value,
                      mainPadding: EdgeInsets.zero,
                      hint: "20 Jun 2001",
                      suffixIcon: InkWell(
                        onTap: () {
                          controller.selectDate(context);
                        },
                        child: Icon(
                          Linecons.calendar,
                          color: DynamicColors.textColor,
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Location",
                    style: poppinsRegular(fontSize: 21),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CSCPicker(
                    currentCountry: controller.countryController.text.isEmpty
                        ? null
                        : controller.countryController.text,
                    currentCity: controller.cityController.text.isEmpty
                        ? null
                        : controller.cityController.text,
                    currentState: controller.stateController.text.isEmpty
                        ? null
                        : controller.stateController.text,
                    dropdownDecoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: DynamicColors.primaryColorRed),
                        )),
                    disabledDropdownDecoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: DynamicColors.primaryColorRed),
                        )),
                    selectedItemStyle: poppinsRegular(
                      fontSize: 14,
                      color: DynamicColors.accentColor.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                    onCountryChanged: (value) {
                      var newValue = value.split("    ");
                      controller.countryController.text = newValue[1];
                      controller.cityController.text = "";
                      controller.stateController.text = "";
                      controller.update();
                    },
                    onStateChanged: (value) {
                      if (value != null) {
                        controller.cityController.text = "";
                        controller.stateController.text = value.toString();
                      }
                      controller.update();
                    },
                    onCityChanged: (value) {
                      if (value != null) {
                        controller.cityController.text = value.toString();
                      }

                      if (value != null) {
                        isSelected.value = false;
                      }
                      controller.update();
                    },
                  ),
                  Obx(() =>
                  isSelected.value == false
                      ? Container()
                      : Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 5, bottom: 5),
                    child: Text(
                      controller.countryController.text.isEmpty
                          ? "Please Select Country"
                          : controller.stateController.text.isEmpty
                          ? "Please Select State"
                          : "Please Select City",
                      style: TextStyle(
                          color: Color(0xffd51820), fontSize: 12),
                    ),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldComponent(
                    title: "ZipCode",
                    hint: "123456",
                    controller: controller.zipCodeController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldComponent(
                    title: "About",
                    hint: "about",
                    maxLines: 5,
                    controller: controller.aboutController,
                  ),
                  SizedBox(
                    height: kToolbarHeight,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        Spacer(),
                        CustomButton(
                          text: "Update",
                          isLong: false,
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              if (controller
                                  .countryController.text.isNotEmpty) {
                                controller.createProfile();
                              } else {
                                BotToast.showText(
                                    text: "Please select country");
                              }
                            } else {
                              if (controller.countryController.text.isEmpty) {
                                isSelected.value = true;
                              }
                            }
                          },
                          padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 40),
                          color: DynamicColors.primaryColorLight,
                          borderColor: DynamicColors.primaryColorRed,
                          borderRadius: BorderRadius.circular(5),
                          style: poppinsLight(
                              color: DynamicColors.primaryColorRed),
                        )
                      ],
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
      }),
    );
  }
}
