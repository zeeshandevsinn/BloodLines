// ignore_for_file: must_be_immutable

import 'package:bloodlines/Credentials/data/appleLogin.dart';
import 'package:bloodlines/Credentials/data/facebookLoginService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Buttons.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/textField.dart';
import 'package:bloodlines/Credentials/controller/credentialController.dart';
import 'package:bloodlines/Routes/app_pages.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  CredentialController controller = Get.find();
  final formKey = GlobalKey<FormState>();
  RxBool isPassword = true.obs;

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
                child: Text("Log in",
                    style: poppinsBold(
                        color: DynamicColors.primaryColor, fontSize: 30)),
              ),
              SizedBox(height: height / 15),
              Text(
                "Username or Email",
                style: montserratSemiBold(fontSize: 21),
              ),
              CustomTextField(
                controller: controller.signInEmailController,
                mainPadding: EdgeInsets.zero,
                hint: "Josef Black",
                isEmail: false,
                validationError: "Email",
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Password",
                style: montserratSemiBold(fontSize: 21),
              ),
              Obx(() {
                return CustomTextField(
                  controller: controller.signInPasswordController,
                  obscureText: isPassword.value,
                  mainPadding: EdgeInsets.zero,
                  hint: "****************",
                  validationError: "Password",
                  suffixIcon: InkWell(
                    onTap: () {
                      isPassword.value = !isPassword.value;
                    },
                    child: Icon(
                      isPassword.value == true
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
              Row(
                children: [
                  Spacer(),
                  Text(
                    "Forget Password?",
                    style: poppinsRegular(fontSize: 10, color: DynamicColors.red),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.signUp);
                  },
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "New user?",
                          style: poppinsRegular(
                              fontSize: 15, color: DynamicColors.primaryColor)),
                      TextSpan(
                          text: " Create an account",
                          style: poppinsRegular(
                              color: DynamicColors.primaryColorRed,
                              fontSize: 15)),
                    ]),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: CustomButton(
                text: "Log In",
                isLong: false,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    controller.login();
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
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      controller.socialLoginGoogle();

                    },
                    child: Image.asset(
                      "assets/google.png",
                      height: height / 7,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      FacebookLoginService().facebookLogin(context: context, inAppOpenView: false);
                    },
                    child: Image.asset(
                      "assets/fb.png",
                      height: height / 7,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      AppleLoginService().checkAppleLoginState(
                          context: context,
                          inAppOpenView: false);
                    },
                    child: Image.asset(
                      "assets/apple.png",
                      height: height / 7,
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      )),
    );
  }
}
