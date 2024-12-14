// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/SingletonPattern/singletonUser.dart';
import 'package:bloodlines/apiLocation.dart';
import 'package:bloodlines/userModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Network/Url.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/notification.dart';
import 'package:page_transition/page_transition.dart';
import 'config.dart';

String? token;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseConfig.platformOptions,
  );
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.production,
  );
  Environment().initConfig(environment);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.max,
        enableVibration: true);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  getLocation();
  await FirebaseMessaging.instance.requestPermission();
  // await Permission.location.request();
  token = await FirebaseMessaging.instance.getToken();
  runApp(const MyApp());
}

ApiLocation? apiLocation;
void getLocation() async {
  final response = await Api.singleton.get("http://ip-api.com/json",
      auth: true, fullUrl: "http://ip-api.com/json");
  if (response.statusCode == 200) {
    apiLocation = ApiLocation.fromJson(response.data);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<Offset>? offset;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, -1.0))
        .animate(controller!);
    Future.delayed(Duration(seconds: 4), () {
      switch (controller!.status) {
        case AnimationStatus.completed:
          controller!.reverse();
          break;
        case AnimationStatus.dismissed:
          controller!.forward();
          break;
        default:
      }
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    // TODO: implement dispose
    super.dispose();
  }
   final red =  MaterialColor(
     0xffD50814,
     <int, Color>{
       50: Color(0xFFFFEBEE),
       100: Color(0xFFFFCDD2),
       200: Color(0xFFEF9A9A),
       300: Color(0xFFE57373),
       400: Color(0xFFEF5350),
       500: Color(0xffD50814),
       600: Color(0xFFE53935),
       700: Color(0xFFD32F2F),
       800: Color(0xffD50805),
       900: Color(0xffD50814),
     },
   );
   final white =  MaterialColor(
     0xffD50814,
     <int, Color>{
       10: Color(0xFFFFFFFF),
       50: Color(0xFFFFFFFF),
       100: Color(0xFFFFFFFF),
       200: Color(0xFFFFFFFF),
       300: Color(0xFFFFFFFF),
       400: Color(0xFFFFFFFF),
       500: Color(0xFFFFFFFF),
       600: Color(0xFFFFFFFF),
       700: Color(0xFFFFFFFF),
       800: Color(0xFFFFFFFF),
       900: Color(0xFFFFFFFF),
     },
   );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'bloodlines',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch:red,
        tabBarTheme: TabBarTheme(
          indicatorColor:  DynamicColors.primaryColorRed,
        ),

        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: DynamicColors.primaryColorLight,
        ),
        primaryColor: DynamicColors.primaryColorLight,

        textSelectionTheme: TextSelectionThemeData(
          cursorColor: DynamicColors.primaryColorRed,
          selectionColor: DynamicColors.primaryColorRed,
          selectionHandleColor: DynamicColors.primaryColorRed,
        ),
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        child = ScrollConfiguration(
          behavior: MyBehavior(),
          child: BotToastInit()(context, child),
        );
        return child;
      },
      getPages: AppPages.routes,
      navigatorObservers: [BotToastNavigatorObserver()],
      home: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
                colors: [
              DynamicColors.gradientColor1,
              DynamicColors.gradientColor,
              DynamicColors.gradientColor1,
            ])),
        child: SlideTransition(
          position: offset!,
          child: AnimatedSplashScreen.withScreenRouteFunction(
            splash: 'assets/logo.png',
            splashIconSize: 300,
            curve: Curves.decelerate,
            backgroundColor: Colors.transparent,
            splashTransition: SplashTransition.scaleTransition,
            pageTransitionType: PageTransitionType.bottomToTop,
            screenRouteFunction: () {
              // Api.singleton.sp.erase();
              return Future.delayed(Duration(seconds: 1), () async {
                if (Api.singleton.sp.read('token') != null) {
                  if (Api.singleton.sp.read('user') == null) {
                    final response = await Api.singleton
                        .interceptorGet('profile', firstTime: true);
                    if (response.statusCode == 200) {
                      UserModel user =
                          UserModel.fromJson(response.data["data"]);
                      SingletonUser.singletonClass.setUser(user);
                      Api.singleton.sp
                          .write("user", json.encode(user.toJson()));
                      if (user.profile == null) {
                        return Routes.completeProfile;
                      } else {
                        return Routes.dashboard;
                      }
                    }
                    return Routes.login;
                  } else {
                    UserModel user = UserModel.fromJson(
                        jsonDecode(Api.singleton.sp.read('user')));
                    if (user.profile == null) {
                      return Routes.completeProfile;
                    } else {
                      return Routes.dashboard;
                    }
                  }
                }
                return Routes.login;
              });
            },
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
