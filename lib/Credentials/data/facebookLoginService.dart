
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Credentials/controller/credentialController.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as form;

class FacebookLoginService {
  // ///TODO FACEBOOK AUTH

  signInWithFacebook() async {
    AuthCredential? authCredential;
    LoginResult loginCredential;
    try {
      print("not Exsiting User");
      loginCredential = await FacebookAuth.instance.login(
        permissions: [
          'public_profile',
          'email',
        ],
      );
      print("Fb User");
      Api.singleton.sp.write("accessToken", loginCredential.accessToken!.token);

      authCredential =
          FacebookAuthProvider.credential(loginCredential.accessToken!.token);
      return await FirebaseAuth.instance.signInWithCredential(
        authCredential,
      );
    } catch (e) {
      print("e");
      print(e);
      print("e");
    }
  }

  facebookLogin({
    required BuildContext context,
    required bool inAppOpenView,
  }) async {
    dynamic result;
    CredentialController controller = Get.find();
    result = await signInWithFacebook();
    print("result");
    print(result);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User currentUser = auth.currentUser!;
    var firebaseToken = await FirebaseMessaging.instance.getToken();
    if (result != null) {
      var data = {
        "email": result.additionalUserInfo!.profile!["email"].toString(),
        "username":  currentUser.displayName.toString(),
        "platform": "facebook",
        "device_token": firebaseToken.toString(),
      };

      print("Email");


    } else {
      onFacebookLogout();
      BotToast.showText(text: "Something went wrong please try again later");
    }
  }

  onFacebookLogout() async {
    await FacebookAuth.instance.logOut();
  }
}
