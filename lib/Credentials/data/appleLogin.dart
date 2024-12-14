// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bloodlines/Credentials/controller/credentialController.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginService {

  checkAppleLoginState(
      {required BuildContext context,
        required bool inAppOpenView,}) async {
    String? deviceId;
    String id = "";
    deviceId = await PlatformDeviceId.getDeviceId;
    DocumentSnapshot credential = await FirebaseFirestore.instance
        .collection("appleIdentifier")
        .doc(deviceId)
        .get();
    if (credential.exists) {
      id = credential.get("userIdentifier");
    }

    if (id != "") {
      CredentialState credentialState =
      await SignInWithApple.getCredentialState(
          credential["userIdentifier"]);

      switch (credentialState.name) {
        case "authorized":
          {
            if (credential["email"] != null) {
              if (credential["email"].isNotEmpty) {
                print("authorized");
                print(credential["email"]);
                onAppleSocialAuthorized(
                    context: context,
                    email: credential["email"],
                    inAppOpenView: inAppOpenView,);
              }
            } else {
              print("authorized but");
              onAppleSocialAuth(
                  context: context,
                  inAppOpenView: inAppOpenView,);
            }

            break;
          }
        case "revoked":
          {
            print("revoked");

            onAppleSocialAuth(
                context: context,
                inAppOpenView: inAppOpenView,);
            break;
          }
        case "notFound":
          {
            print("notFound");
            onAppleSocialAuth(
                context: context,
                inAppOpenView: inAppOpenView,);
            break;
          }
      }
    } else {
      print("first time apple login");
      onAppleSocialAuth(
          context: context,
          inAppOpenView: inAppOpenView,);
    }
  }

  ///AppLe Login
  onAppleSocialAuth({
    required BuildContext context,
    required bool inAppOpenView,
  }) async {
    // try {
    final existingUser = FirebaseAuth.instance.currentUser;
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    if (credential.email == null ) {
      BotToast.showText(text: "Email is Required");
    } else {
      final oAthProvider = OAuthProvider("apple.com");
      final credentials = oAthProvider.credential(
          accessToken: credential.authorizationCode,
          idToken: credential.identityToken);
      String? deviceId;

      deviceId = await PlatformDeviceId.getDeviceId;



      UserCredential user =
      await FirebaseAuth.instance.signInWithCredential(credentials);
      await FirebaseFirestore.instance
          .collection("appleIdentifier")
          .doc(deviceId)
          .set({
        "authorizationCode": credential.authorizationCode,
        "identityToken": credential.identityToken,
        "userIdentifier": credential.userIdentifier,
        "email": credential.email,
        "uid": user.user!.uid,
      }, SetOptions(merge: true));
      signAppleService(
        context: context,
        user: user,
        name:credential.givenName,
        id:credential.userIdentifier??"",
        email: credential.email,
        inAppOpenView: inAppOpenView,
      );
    }
  }

  ///AppLe Login
  onAppleSocialAuthorized(
      {required BuildContext context,
        required String email,
        required bool inAppOpenView,
        bool isBusinessShoutout = false}) async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oAthProvider = OAuthProvider("apple.com");
    final credentials = oAthProvider.credential(
        accessToken: credential.authorizationCode,
        idToken: credential.identityToken);
    String? deviceId = await PlatformDeviceId.getDeviceId;
    UserCredential user =
    await FirebaseAuth.instance.signInWithCredential(credentials);
    await FirebaseFirestore.instance
        .collection("appleIdentifier")
        .doc(deviceId)
        .set({
      "authorizationCode": credential.authorizationCode,
      "identityToken": credential.identityToken,
      "userIdentifier": credential.userIdentifier,
      "uid": user.user!.uid,
    }, SetOptions(merge: true));
    signAppleService(
        context: context,
        user: user,
        name:credential.givenName,
        id:credential.userIdentifier??"",
        email: email,
        inAppOpenView: inAppOpenView,
        isBusinessShoutout: isBusinessShoutout);
  }

  signAppleService({
    required BuildContext context,
    required UserCredential user,
    String? email,
    String? name,
    required String id,
    required bool inAppOpenView,
    bool isBusinessShoutout = false,
  }) async {
    CredentialController controller = Get.find();

    var firebaseToken = await FirebaseMessaging.instance.getToken();
    print("user");
    print(user);
      print(user.user!.providerData[0].displayName);

      var data = {
        if(email != null) "email": email.toString(),
        "platform": "Apple",
        if(name != null)"username":name,
        // if(name != null)"Display Name":name,
        // if(name != null)"Full Name":name,
        "apple_id": id,
        "device_token": firebaseToken.toString(),
      };
      controller.socialLoginApple(data);

  }
}
