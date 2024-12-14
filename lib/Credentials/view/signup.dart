// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/textFieldComponent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/textField.dart';
import 'package:bloodlines/Credentials/controller/credentialController.dart';
import 'package:bloodlines/Routes/app_pages.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  CredentialController controller = Get.find();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 70),
              Center(
                child: Image.asset(
                  "assets/logo.png",
                  height: height / 4,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text("Let's Sign up",
                    style: poppinsBold(
                        color: DynamicColors.primaryColor, fontSize: 30)),
              ),
              SizedBox(height: height / 15),
              //     TextFieldComponent(
              //         title: "Full Name",
              //         hint: "Josef Black",
              //         controller: controller.nameController),
              //     SizedBox(
              //       height: 20,
              //     ),
              Text(
                "Your Email",
                style: montserratSemiBold(fontSize: 21),
              ),
              CustomTextField(
                controller: controller.signUpEmailController,
                mainPadding: EdgeInsets.zero,
                isEmail: true,
                hint: "abc@bloodlines.com",
                validationError: "Email",
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Create Username",
                style: montserratSemiBold(fontSize: 21),
              ),
              CustomTextField(
                controller: controller.signUpUserNameController,
                mainPadding: EdgeInsets.zero,
                hint: "Josef123",
                validationError: "username",
              ),
              SizedBox(
                height: 15,
              ),
              // Text(
              //   "Date of Birth",
              //   style: poppinsRegular(fontSize: 21),
              // ),
              // Obx(() {
              //   return CustomTextField(
              //     controller: controller.signUpDobController.value,
              //     mainPadding: EdgeInsets.zero,
              //     hint: "20 Jun 2001",
              //     validationError: "birthday",
              //     suffixIcon: InkWell(
              //       onTap: () {
              //         controller.selectDate(context);
              //       },
              //       child: Icon(
              //         Linecons.calendar,
              //         color: DynamicColors.textColor,
              //       ),
              //     ),
              //   );
              // }),
              // SizedBox(
              //   height: 15,
              // ),
              // Text(
              //   "Gender",
              //   style: poppinsRegular(fontSize: 21),
              // ),
              // DropDownClass(
              //   list: controller.gender,
              //   hint: "Gender",
              //   validationError: "Gender",
              // ),
              // SizedBox(
              //   height: 15,
              // ),
              Text(
                "Password",
                style: montserratSemiBold(fontSize: 21),
              ),
              Obx(() {
                return CustomTextField(
                  controller: controller.signUpPasswordController,
                  obscureText: controller.isPassword.value,
                  mainPadding: EdgeInsets.zero,
                  hint: "****************",
                  validationError: "Password",
                  fromSignUp: true,
                  suffixIcon: InkWell(
                    onTap: () {
                      controller.isPassword.value = !controller.isPassword.value;
                    },
                    child: Icon(
                      controller.isPassword.value == true
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: DynamicColors.textColor,
                    ),
                  ),
                );
              }),
              SizedBox(
                height: 10,
              ),
              Text(
                "Confirm Password",
                style: montserratSemiBold(fontSize: 21),
              ),
              Obx(() {
                return CustomTextField(
                  controller: controller.signUpConfirmPasswordController,
                  obscureText: controller.isConfirmPassword.value,
                  mainPadding: EdgeInsets.zero,
                  hint: "****************",
                  validationError: "Confirm Password",
                  suffixIcon: InkWell(
                    onTap: () {
                      controller.isConfirmPassword.value =
                          !controller.isConfirmPassword.value;
                    },
                    child: Icon(
                      controller.isConfirmPassword.value == true
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: DynamicColors.textColor,
                    ),
                  ),
                );
              }),
              SizedBox(
                height: 10,
              ),
              Text(
                "(contains at least 8 characters)",
                style: poppinsRegular(
                    fontSize: 10, color: DynamicColors.accentColor),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Already have an account?",
                          style: poppinsRegular(
                              fontSize: 15,
                            color: DynamicColors.primaryColorRed,
                          )
                      ),
                      TextSpan(
                          text: " Sign in",
                          style: poppinsRegular(
                              color: DynamicColors.black, fontSize: 15)),
                    ]),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: CustomButton(
                text: "Sign up",
                isLong: false,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    controller.signingUp();
                  }
                },
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                color: DynamicColors.primaryColor,
                borderColor: Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                style: poppinsSemiBold(
                    color: DynamicColors.primaryColorLight, fontSize: 14),
              )),
              SizedBox(
                height: 20,
              ),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text:
                            "By clicking Sign up, I agree that I have read and accepted\n the",
                        style: poppinsRegular(
                          fontSize: 10,
                          color: DynamicColors.accentColor.withOpacity(0.5),
                        )),
                    TextSpan(
                        text: " Terms of Use ",
                        style: poppinsRegular(
                            color: DynamicColors.primaryColor, fontSize: 10)),
                    TextSpan(
                        text: "and", //
                        style: poppinsRegular(
                          fontSize: 10,
                          color: DynamicColors.accentColor.withOpacity(0.5),
                        )),
                    TextSpan(
                        text: " Privacy Policy.",
                        style: poppinsRegular(
                            color: DynamicColors.primaryColor, fontSize: 10)),
                  ]),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SocialIcons(height: height),
              SizedBox(
                height: 30,
              ),
            ]),
          ),
        ),
      )),
    );
  }
}

class SocialIcons extends StatelessWidget {
  const SocialIcons({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            "Continue with",
            style: montserratBold(
              fontSize: 12,
              color: DynamicColors.primaryColor,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/google.png",
                height: height / 8,
              ),
              Image.asset(
                "assets/fb.png",
                height: height / 8,
              ),
              Image.asset(
                "assets/apple.png",
                height: height / 8,
              ),
            ],
          ),
        )
      ],
    );
  }
}
