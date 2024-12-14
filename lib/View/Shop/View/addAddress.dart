import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Dummy.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/textFieldComponent.dart';
import 'package:bloodlines/View/Shop/Data/shopController.dart';
import 'package:bloodlines/View/Shop/Model/addressModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AddAddress extends StatefulWidget {
  AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  ShopController controller = Get.find();

  Rx<PhoneNumber> number = PhoneNumber(isoCode: 'US').obs;

  Rx<PhoneNumber> billingNumber = PhoneNumber(isoCode: 'US').obs;

  final formKey = GlobalKey<FormState>();

  RxBool isSelected = false.obs;

  RxBool isBillingSelected = false.obs;
  bool isFromLocation = false;

  RxBool isSameAsShipping = true.obs;
  ShippingAddress? data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments != null) {
      ShippingAddress shipping = Get.arguments["shipping"];
      data = Get.arguments["shipping"];
      ShippingAddress billing = Get.arguments["billing"];
      controller.fName.text = shipping.firstName!;
      controller.lName.text = shipping.lastName!;
      controller.address.text = shipping.streetAddress!;
      controller.country.text = shipping.county ?? "";
      controller.city.text = shipping.city ?? "";
      controller.state.text = shipping.state ?? "";
      controller.latitude = shipping.latitude == null? 0.0: double.parse(shipping.latitude!) ;
      controller.longitude = shipping.longitude == null? 0.0: double.parse(shipping.longitude!) ;
      getPhone(shipping.contact);
      controller.zipCode.text = shipping.zipcode!;

      controller.billingFirstName.text = billing.firstName??"";
      controller.billingLastName.text = billing.lastName??"";
      controller.billingAddress.text = billing.streetAddress??"";
      controller.billingCountry.text = billing.county ?? "";
      controller.billingCity.text = billing.city ?? "";
      controller.billingState.text = billing.state ?? "";
      controller.billingLatitude = billing.latitude == null? shipping.latitude == null? 0.0: double.parse(shipping.latitude!): double.parse(billing.latitude!) ;
      controller.billingLongitude = billing.longitude == null? shipping.longitude == null? 0.0: double.parse(shipping.longitude!): double.parse(billing.longitude!) ;
      getPhone(billing.contact, fromBilling: true);
      controller.billingZipCode.text = billing.zipcode??"";
    }
  }

  Future<bool> onWillPop()async{
    controller.clear();
    Get.back();
    return true;
  }
  // final UniqueKey<CSCPickerState> _cscPickerKey = UniqueKey();



  getPhone(profile, {bool fromBilling = false}) async {
    if (profile != null) {
      var num = await PhoneNumber.getRegionInfoFromPhoneNumber(profile!);
      var a = await PhoneNumber.getParsableNumber(num);
      if (fromBilling == false) {
        number.value = PhoneNumber(
            phoneNumber: a, isoCode: num.isoCode, dialCode: num.dialCode);
        controller.phoneController.text = profile!;
      } else {
        billingNumber.value = PhoneNumber(
            phoneNumber: a, isoCode: num.isoCode, dialCode: num.dialCode);
        controller.billingPhoneController.text = profile!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:onWillPop,
      child: Scaffold(
        backgroundColor: DynamicColors.primaryColorLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: AppBarWidgets(
            onTap: (){
              onWillPop();
            },
          ),
          title: Text(
            "Add Address",
            style:
                poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 24),
          ),
          elevation: 0,
        ),
        body: GetBuilder<ShopController>(builder: (controller) {




          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Shipping Details",
                      style: poppinsBold(fontSize: 18),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: TextFieldComponent(
                            title: "First Name",
                            hint: "Jose",
                            titleFontSize: 15,
                            controller: controller.fName,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 8,
                          child: TextFieldComponent(
                            title: "Last Name",
                            hint: "Micheal",
                            titleFontSize: 15,
                            controller: controller.lName,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Phone",
                      style:
                          poppinsLight(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
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
                      height: 10,
                    ),
                    TextFieldComponent(
                        title: "Address",
                        hint: "Cineplex Cinema UK",
                        titleFontSize: 15,
                        onTap: () {
                          controller.determinePositions(
                              callback: (){
                                setState(() {
                                  isFromLocation = true;
                                  // _cscPickerKey.currentState!.initState();
                                });
                              }
                          );
                        },
                        readOnly: true,
                        controller: controller.address,
                        suffix: InkWell(
                          onTap: () {
                            controller.determinePositions(
                              callback: (){
                                setState(() {
                                  isFromLocation = true;
                                  // _cscPickerKey.currentState!.initState();
                                });
                              }
                            );
                          },
                          child: Icon(
                            Icons.location_pin,
                            color: DynamicColors.primaryColorRed,
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldComponent(
                      title: "ZipCode",
                      hint: "123456",
                      textInputType: TextInputType.number,
                      titleFontSize: 15,
                      controller: controller.zipCode,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Location",
                      style: poppinsRegular(fontSize: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // isFromLocation == false? cscPicker():
                    CSCPicker(
                      key: UniqueKey(),
                      currentCountry: controller.country.text.isEmpty
                          ? null
                          : controller.country.text,
                      currentCity: controller.city.text.isEmpty
                          ? null
                          : controller.city.text,
                      currentState: controller.state.text.isEmpty
                          ? null
                          : controller.state.text,
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
                        color: DynamicColors.textColor,
                        fontWeight: FontWeight.w500,
                      ),

                      onCountryChanged: (value) {
                        var newValue = value.split("    ");
                        controller.country.text = newValue[1];
                        controller.city.text = "";
                        controller.state.text = "";

                        controller.update();
                      },
                      onStateChanged: (value) {
                        if (value != null) {
                          controller.city.text = "";
                          controller.state.text = value.toString();
                        }
                        controller.update();
                      },
                      onCityChanged: (value) {
                        if (value != null) {
                          controller.city.text = value.toString();
                        }
                        if (value != null) {
                          isSelected.value = false;
                        }
                        controller.update();
                      },
                    ),
                    Obx(() => isSelected.value == false
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 5, bottom: 5),
                            child: Text(
                              controller.country.text.isEmpty
                                  ? "Please Select Country"
                                  : controller.state.text.isEmpty
                                      ? "Please Select State"
                                      : "Please Select City",
                              style: TextStyle(
                                  color: Color(0xffd51820), fontSize: 12),
                            ),
                          )),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        isSameAsShipping(!isSameAsShipping.value);
                        controller.billingFirstName.text=controller.fName.text;
                        controller.billingLastName.text=controller.lName.text;
                        controller.billingAddress.text=controller.address.text;
                        controller.billingCountry.text=controller.country.text;
                        controller.billingCity.text=controller.city.text;
                        controller.billingState.text=controller.state.text;
                        controller.billingLatitude =controller.latitude ;
                        controller.billingLongitude =controller.longitude ;
                        controller.billingZipCode.text=controller.zipCode.text;
                        controller.billingPhoneController.text=controller.phoneController.text;
                      },
                      child: Row(
                        children: [
                          Text(
                            "Billing Address Is Same As Shipping Address",
                            style: poppinsLight(fontSize: 14),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Obx(() {
                            return Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                  color: isSameAsShipping.value == true
                                      ? DynamicColors.primaryColorRed
                                      : DynamicColors.accentColor),
                              child: Center(
                                  child: Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )),
                            );
                          }),
                        ],
                      ),
                    ),
                    Obx(() {
                      if (isSameAsShipping.value == true) {
                        return Container();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Billing Details",
                            style: poppinsBold(fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: TextFieldComponent(
                                  title: "First Name",
                                  hint: "Jose",
                                  titleFontSize: 15,
                                  controller: controller.billingFirstName,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 8,
                                child: TextFieldComponent(
                                  title: "Last Name",
                                  hint: "Micheal",
                                  titleFontSize: 15,
                                  controller: controller.billingLastName,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Billing Phone",
                            style: poppinsRegular(fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Obx(() {
                            return InternationalPhoneNumberInput(
                              isFromSignUp: true,
                              onInputChanged: (PhoneNumber number) {
                                //print(number.phoneNumber);

                                validateMobile(number.phoneNumber!);
                                controller.update();
                                // print(number.phoneNumber);
                                controller.billingPhoneController.text =
                                    number.phoneNumber.toString();
                              },
                              inputDecoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  left: 0,
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: DynamicColors.primaryColorRed,
                                      width: 1),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: DynamicColors.primaryColorRed,
                                      width: 2),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: DynamicColors.primaryColorRed,
                                      width: 1),
                                ),
                                labelText: "Enter Phone No",
                                labelStyle: poppinsRegular(
                                  fontSize: 14,
                                  color:
                                      DynamicColors.accentColor.withOpacity(0.5),
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
                              initialValue: billingNumber.value,
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
                            height: 10,
                          ),
                          TextFieldComponent(
                              title: "Billing Address",
                              hint: "Cineplex Cinema UK",
                              titleFontSize: 15,
                              controller: controller.billingAddress,
                              suffix: InkWell(
                                onTap: () {
                                  controller.determinePositions(
                                      fromBilling: true);
                                },
                                child: Icon(
                                  Icons.location_pin,
                                  color: DynamicColors.primaryColorRed,
                                ),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldComponent(
                            title: "Billing ZipCode",
                            hint: "123456",
                            textInputType: TextInputType.number,
                            titleFontSize: 15,
                            controller: controller.billingZipCode,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Billing Location",
                            style: poppinsRegular(fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CSCPicker(
                            key: UniqueKey(),
                            currentCountry: controller.billingCountry.text.isEmpty
                                ? null
                                : controller.billingCountry.text,
                            currentCity: controller.billingCity.text.isEmpty
                                ? null
                                : controller.billingCity.text,
                            currentState: controller.billingState.text.isEmpty
                                ? null
                                : controller.billingState.text,
                            dropdownDecoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  width: 1.0,
                                  color: DynamicColors.primaryColorRed),
                            )),
                            disabledDropdownDecoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  width: 1.0,
                                  color: DynamicColors.primaryColorRed),
                            )),
                            selectedItemStyle: poppinsRegular(
                              fontSize: 14,
                              color: DynamicColors.accentColor.withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                            ),
                            onCountryChanged: (value) {
                              var newValue = value.split("    ");
                              controller.billingCountry.text = newValue[1];
                              controller.billingCity.text = "";
                              controller.billingState.text = "";
                              controller.update();
                            },
                            onStateChanged: (value) {
                              if (value != null) {
                                controller.billingCity.text = "";
                                controller.billingState.text = value.toString();
                              }
                              controller.update();
                            },
                            onCityChanged: (value) {
                              if (value != null) {
                                controller.billingCity.text = value.toString();
                              }
                              controller.update();
                            },
                          ),
                          Obx(() => isBillingSelected.value == false
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 5, bottom: 5),
                                  child: Text(
                                    controller.billingCountry.text.isEmpty
                                        ? "Please Select Country"
                                        : controller.billingState.text.isEmpty
                                            ? "Please Select State"
                                            : "Please Select City",
                                    style: TextStyle(
                                        color: Color(0xffd51820), fontSize: 12),
                                  ),
                                )),
                        ],
                      );
                    }),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: CustomButton(
                        text: data != null ? "Update" : "Save",
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            if(isSameAsShipping.value == false){
                              if (controller.country.text.isNotEmpty &&
                                  controller.billingCountry.text.isNotEmpty) {
                                controller.addAddress(
                                    isSameAsShipping.value == false ? 0 : 1,
                                    id: data == null ? null : data!.id);
                              } else {
                                BotToast.showText(
                                    text: "Please select country");
                              }
                            }else{
                              if (controller.country.text.isNotEmpty) {
                                controller.addAddress(
                                    isSameAsShipping.value == false ? 0 : 1,
                                    id: data == null ? null : data!.id);
                              } else {
                                BotToast.showText(
                                    text: "Please select country");
                              }
                            }
                          } else {
                            if (controller.country.text.isEmpty) {
                              isSelected.value = true;
                            } else if (controller.billingCountry.text.isEmpty) {
                              isBillingSelected.value = true;
                            }
                          }
                        },
                        isLong: false,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        borderRadius: BorderRadius.circular(5),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        color: DynamicColors.primaryColorRed,
                        borderColor: DynamicColors.primaryColorRed,
                        style: montserratSemiBold(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: DynamicColors.whiteColor),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
