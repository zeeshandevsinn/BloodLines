import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
        appId: '1:827625882025:android:9dcbf846ce6a6e231104b8',
        apiKey: 'AIzaSyBk_knb1KHw990VQQ7YVCSfb8jd6aH5sa4',
        projectId: 'bloodlines-71fea',
        messagingSenderId: '827625882025',
        androidClientId:
            "827625882025-7mn41qjhokudami4aa71suh33qronl2k.apps.googleusercontent.com",
        storageBucket: "bloodlines-71fea.appspot.com",
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:827625882025:ios:d0feb7db8ffd85071104b8',
        apiKey: 'AIzaSyDQicfuUmXsSaXS7YmvFC3ckqpxr-dd2zA',
        projectId: 'bloodlines-71fea',
        messagingSenderId: '827625882025',
        iosClientId:
            "827625882025-t3hl1g5nn2couem0ijao4m9vjtf15gv7.apps.googleusercontent.com",
        storageBucket: "bloodlines-71fea.appspot.com",
        iosBundleId: "com.gologonow.bloodlines",
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:827625882025:android:9dcbf846ce6a6e231104b8',
        apiKey: 'AIzaSyBk_knb1KHw990VQQ7YVCSfb8jd6aH5sa4',
        projectId: 'bloodlines-71fea',
        messagingSenderId: '827625882025',
        androidClientId:
            "827625882025-7mn41qjhokudami4aa71suh33qronl2k.apps.googleusercontent.com",
        storageBucket: "bloodlines-71fea.appspot.com",
      );
    }
  }
}
