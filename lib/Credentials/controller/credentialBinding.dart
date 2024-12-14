import 'package:get/get.dart';
import 'package:bloodlines/Credentials/controller/credentialController.dart';

class CredentialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CredentialController>(() => CredentialController());
  }
}
