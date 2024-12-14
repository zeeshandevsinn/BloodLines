import 'dart:developer';
import 'dart:io';
import 'package:bloodlines/Components/CustomMultipart.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/SingletonPattern/singletonUser.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/main.dart';
import 'package:bloodlines/userModel.dart';
import 'package:dio/dio.dart' as form;

import 'package:bloodlines/Components/imageBottomSheet.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:location/location.dart' as loc;
import 'package:multi_image_crop/multi_image_crop.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CredentialController extends GetxController {
  ///SIGN IN
  final signInEmailController = TextEditingController();
  final signInPasswordController = TextEditingController();

  ///Profile
  final nameController = TextEditingController();
  final zipCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController().obs;
  final universityController = TextEditingController();
  final schoolController = TextEditingController();
  final workController = TextEditingController();
  final locationController = TextEditingController();
  final restaurantController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final aboutController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? genderText;

  final placeController = TextEditingController();
  List<String> relationStatus = [
    "Single",
    "In a Relationship",
    "Married",
    "Divorced",
    "Widowed"
  ];

  TextfieldTagsController tags = TextfieldTagsController();
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  loc.Location location = loc.Location();

  ///SIGN UP
  final signUpEmailController = TextEditingController();
  final signUpUserNameController = TextEditingController();
  final signUpDobController = TextEditingController().obs;
  final signUpPasswordController = TextEditingController();
  final signUpConfirmPasswordController = TextEditingController();
  List<String> gender = ["Male", "Female"];
  RxBool isPassword = true.obs;
  RxBool isConfirmPassword = true.obs;
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  var googleLoading = false.obs;

  Future signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;

      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      Api.singleton.sp.write('accessToken',googleAuth.accessToken,);
      Api.singleton.sp.write('idToken',googleAuth.idToken,);
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print(credential);
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("e");
      print(e);
    }
  }

  onGoogleLogout() async {
    googleSignIn.disconnect();
    googleSignIn.signOut();
  }
  Future<void> selectDate(BuildContext context, {fromProfile = false}) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1960, 01, 01),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                    onPrimary: DynamicColors.whiteColor, // selected text color
                    onSurface:
                        DynamicColors.primaryColorRed, // default text color
                    primary: DynamicColors.primaryColorRed // circle color
                    ),
                dialogBackgroundColor: DynamicColors.primaryColorLight,
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        textStyle: poppinsRegular(
                          color: DynamicColors.primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                        // color of button's letters
                        backgroundColor:
                            DynamicColors.primaryColorLight, // Background color
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.transparent,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(50))))),
            child: child!,
          );
        });
    if (pickedDate != null) {
      if (DateTime.now().difference(pickedDate).inDays > 4745) {
        dobController.value.text = DateFormat("yyyy-MM-dd").format(pickedDate);
      } else {
        BotToast.showText(text: "Age must be greater than 13");
      }
    }
  }

  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.location]!.isPermanentlyDenied) {
      await openAppSettings().then(
        (value) async {
          if (value) {
            if (await Permission.location.status.isPermanentlyDenied == true &&
                await Permission.location.status.isGranted == false) {
              openAppSettings();
              // permissionServiceCall(); /* opens app settings until permission is granted */
            }
          }
        },
      );
    } else {
      if (statuses[Permission.location]!.isDenied) {
        determinePosition();
      }
    }
    return statuses;
  }

  determinePosition() async {
    bool serviceEnabled;
    await permissionServices().then(
      (value) async {
        if (value[Permission.location]!.isGranted) {
          serviceEnabled = await location.serviceEnabled();
          if (!serviceEnabled) {
            serviceEnabled = await location.requestService();
          }

          if (serviceEnabled) {
            Get.toNamed(Routes.mapLocation);
            update();
          }
        } else {
          exit(1);
        }
      },
    );
  }

  List photoList = [];
  XFile? cover;
  XFile? profile;
  RxList heroImageList = [].obs;
  RxList heroineImageList = [].obs;
  getCameraPermission() async {
    await [
      Permission.storage,
      Permission.camera,
      //add more permission to request here.
    ].request();
  }

  getImage(ImageSource imageSource) {
    return _picker.pickImage(
        source: imageSource, imageQuality: 50, maxHeight: 1200, maxWidth: 1200);
  }

  getMultiple(context, {fromProfile = false}) {
    MultiImageCrop.startCropping(
        context: context,
        aspectRatio: fromProfile == false ? 3 / 2 : 1 / 1,
        activeColor: Colors.amber,
        pixelRatio: 3,
        isLeading: false,
        files: List.generate(
            1,
            (index) =>
                fromProfile == true ? File(profile!.path) : File(cover!.path)),
        callBack: (List<File> images) {
          if (fromProfile == true) {
            profile = XFile(images[0].path);
          } else {
            cover = XFile(images[0].path);
          }
          update();
        });
  }

  _profileImgFromGallery(context, ImageSource source,
      {fromProfile = false}) async {
    try {
      if (fromProfile == true) {
        profile = await getImage(source);

        if (profile != null) {
          getMultiple(context, fromProfile: fromProfile);
        }
      } else {
        cover = await getImage(source);
        if (cover != null) {
          getMultiple(context, fromProfile: fromProfile);
        }
      }
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
  }

  _imgFromGallery(context, {fromHero = false}) async {
    try {
      /// file picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true, type: FileType.image, allowCompression: true);

      if (result != null) {
        if (result.files.length <= 5) {
          if (fromHero == true) {
            if (heroImageList.length + result.files.length > 5) {
              BotToast.showText(
                  text: 'Please upload less than or equals to 5 Picture');
            } else {
              MultiImageCrop.startCropping(
                  context: context,
                  fromHeroSelection: true,
                  aspectRatio: 4 / 3,
                  activeColor: Colors.amber,
                  pixelRatio: 3,
                  files: List.generate(result.files.length,
                      (index) => File(result.files[index].path!)),
                  callBack: (List<File> images) {
                    heroImageList.addAll(images);

                    update();
                  });
            }
          } else {
            if (heroineImageList.length + result.files.length > 5) {
              BotToast.showText(
                  text: 'Please upload less than or equals to 5 Picture');
            } else {
              MultiImageCrop.startCropping(
                  context: context,
                  fromHeroSelection: true,
                  aspectRatio: 4 / 3,
                  activeColor: Colors.amber,
                  pixelRatio: 3,
                  files: List.generate(result.files.length,
                      (index) => File(result.files[index].path!)),
                  callBack: (List<File> images) {
                    heroineImageList.addAll(images);

                    update();
                  });
            }
          }
        } else {
          BotToast.showText(
              text: 'Please upload less than or equals to 5 Picture');
        }

        /*}*/
      }
    } catch (e) {
      print(e.toString());
      /* BotToast.showText(
        text: e.toString(),
      );*/
    }
  }

  XFile? files;
  _imgFromCamera(context, {fromHero = false}) async {
    try {
      files = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxHeight: 1200,
          maxWidth: 1200);

      if (files != null) {
        if (fromHero == true) {
          if (heroImageList.length == 5) {
            BotToast.showText(text: 'Cannot Upload more than 5 Picture');
          } else {
            MultiImageCrop.startCropping(
                context: context,
                aspectRatio: 2 / 3,
                fromHeroSelection: true,
                activeColor: Colors.amber,
                pixelRatio: 3,
                files: List.generate(1, (index) => File(files!.path)),
                callBack: (List<File> images) {
                  /*imageFile.add(images);*/
                  heroImageList.addAll(images);

                  update();
                });
          }
        } else {
          if (heroineImageList.length == 5) {
            BotToast.showText(text: 'Cannot Upload more than 5 Picture');
          } else {
            MultiImageCrop.startCropping(
                context: context,
                fromHeroSelection: true,
                aspectRatio: 2 / 3,
                activeColor: Colors.amber,
                pixelRatio: 3,
                files: List.generate(1, (index) => File(files!.path)),
                callBack: (List<File> images) {
                  /*imageFile.add(images);*/

                  heroineImageList.addAll(images);

                  update();
                });
          }
        }
      }

      update();
    } catch (e) {
      // BotToast.showText(text: e.toString());
    }
  }

  bottomSheet(context, {fromHero = false}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext abc) {
          return Container(
            decoration: BoxDecoration(color: DynamicColors.primaryColor),
            child: Wrap(
              children: [
                ListTile(
                  onTap: () async {
                    _imgFromCamera(context, fromHero: fromHero);
                    Navigator.of(context).pop();

                    // await
                    // Get.back();
                  },
                  leading: Icon(
                    Icons.camera_alt,
                    color: DynamicColors.primaryColorLight,
                  ),
                  title: Text(
                    'Camera',
                    style: poppinsRegular(
                        fontSize: 15.0, color: DynamicColors.primaryColorLight),
                  ),
                ),
                ListTile(
                  onTap: () {
                    _imgFromGallery(context, fromHero: fromHero);
                    Navigator.of(context).pop();
                  },
                  leading: Icon(
                    Icons.image,
                    color: DynamicColors.primaryColorLight,
                  ),
                  title: Text(
                    'Gallery',
                    style: poppinsRegular(
                        fontSize: 15.0, color: DynamicColors.primaryColorLight),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.back();
                  },
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: DynamicColors.primaryColor),
                    ),
                    child: Icon(
                      Icons.close,
                      color: DynamicColors.primaryColorLight,
                    ),
                  ),
                  title: Text(
                    'Cancel',
                    style: poppinsRegular(
                        fontSize: 15.0, color: DynamicColors.primaryColorLight),
                  ),
                ),
              ],
            ),
          );
        });
  }

  profileBottomSheet(context, {fromProfile = false}) {
    ImageBottomSheet.bottomSheet(
      context,
      onCameraTap: () async {
        _profileImgFromGallery(context, ImageSource.camera,
            fromProfile: fromProfile);

        Navigator.of(context).pop();
      },
      onGalleryTap: () {
        _profileImgFromGallery(context, ImageSource.gallery,
            fromProfile: fromProfile);
        Navigator.of(context).pop();
      },
    );
  }

  ///API Calls

  signingUp() async {

    var formData = form.FormData.fromMap({
      // "fullname": nameController.text,
      "email": signUpEmailController.text,
      "password": signUpPasswordController.text,
      "username": signUpUserNameController.text,
      "device_token": token,
    });
    String hitUrl = 'register';
    // debugger();
    final response = await Api.singleton.post(formData, hitUrl, auth: true);
    if (response.statusCode == 200) {
      BotToast.showText(text: "Register Successfully");
      Get.offAllNamed(Routes.login);
    }
  }


  socialLoginFacebook({required form.FormData data}) async {

    String hitUrl = 'register';
    final response = await Api.singleton.post(data, hitUrl, auth: true);
    if (response.statusCode == 200) {
      Api.singleton.sp.write('token', response.data['token']);
      //print(Api.singleton.sp.read('token'));

      Api.singleton.sp.write('username', response.data['data']['username']);
      Api.singleton.sp.write('email', response.data['data']['email']);
      Api.singleton.sp.write('id', response.data['data']['id']);
      Api.singleton.sp.write('loginType',"facebook");
      if (response.data['data']['status'] == null ||response.data['data']['status'] == 1) {
        Get.offAllNamed(Routes.dashboard);
      } else {
        Get.offAllNamed(Routes.completeProfile, arguments: {"alterEgo": false});
      }
    }
  }


  socialLoginGoogle() async {

    UserCredential user = await signInWithGoogle();

    final token = await FirebaseMessaging.instance.getToken();
    onGoogleLogout();

      var data = {
        "email": user.additionalUserInfo!.profile!["email"]
            .toString(),
        "username":  user.user!.displayName.toString(),
        "platform": "googleSignIn",
        "device_token": token,
      };
      print(user.user!.displayName.toString());

    String hitUrl = 'register';
    final response = await Api.singleton.post(data, hitUrl, auth: true);
    if (response.statusCode == 200) {
      Api.singleton.sp.write('token', response.data['token']);
      Api.singleton.sp.write('loginType',"google");

      Api.singleton.sp.write('username', response.data['data']['username']);
      Api.singleton.sp.write('email', response.data['data']['email']);
      Api.singleton.sp.write('id', response.data['data']['id']);
      if (response.data['data']['status'] == null || response.data['data']['status'] == 1) {
        Get.offAllNamed(Routes.dashboard);
      } else {

        Get.offAllNamed(Routes.completeProfile, arguments: {"alterEgo": false});
      }
    }

  }



  socialLoginApple(data) async {

    String hitUrl = 'register';
    final response = await Api.singleton.post(data, hitUrl, auth: true);
    if (response.statusCode == 200) {
      Api.singleton.sp.write('token', response.data['token']);
      //print(Api.singleton.sp.read('token'));

      Api.singleton.sp.write('username', response.data['data']['username']);
      Api.singleton.sp.write('email', response.data['data']['email']);
      Api.singleton.sp.write('id', response.data['data']['id']);
      Api.singleton.sp.write('loginType',"apple");
      if (response.data['data']['status'] == null ||response.data['data']['status'] == 1) {
        Get.offAllNamed(Routes.dashboard);
      } else {
        Get.offAllNamed(Routes.completeProfile, arguments: {"alterEgo": false});
      }
    }

  }



  createProfile() async {
    var formData = form.FormData.fromMap({
      "phone": phoneController.text,
      "about": aboutController.text,
      "gender": genderText!.toLowerCase(),
      "age": dobController.value.text,
      "country": countryController.text,
      "state": stateController.text,
      "city": cityController.text,
      "zipcode": zipCodeController.text,
      if (profile != null) "profile_image": multiPartingImageNoObx(File(profile!.path)),
      if (cover != null) "cover_image": multiPartingImageNoObx(File(cover!.path)),
    });
    print(formData);

    final response = await Api.singleton.post(formData, "edit-profile");
    if (response.statusCode == 200) {
      BotToast.showText(text: "Profile Updated Successfully");

      FeedController controller = Get.find();
      controller.getUser();
      SingletonUser.singletonClass
          .setUser(UserModel.fromJson(response.data['data']));

      Get.offAllNamed(Routes.dashboard);
    }
  }

  login() async {
    form.FormData formData = form.FormData.fromMap({
      "email": signInEmailController.text,
      "password": signInPasswordController.text,
      'device_token': token,
    });
    form.Response response = await Api.singleton.post(
      formData,
      'login',
      auth: true,
      nonFormContent: true,
    );
    if (response.statusCode == 200) {
      Api.singleton.sp.write('token', response.data['token']);
      //print(Api.singleton.sp.read('token'));

      Api.singleton.sp.write('username', response.data['data']['username']);
      Api.singleton.sp.write('email', response.data['data']['email']);
      Api.singleton.sp.write('id', response.data['data']['id']);
      Api.singleton.sp.write('loginType',"normal");
      if (response.data['data']['status'] == 1) {
        Get.offAllNamed(Routes.dashboard);
      } else {
        Get.offAllNamed(Routes.completeProfile, arguments: {"alterEgo": false});
      }
    }
  }
}
