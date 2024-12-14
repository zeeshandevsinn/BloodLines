import 'package:bloodlines/View/Account/Data/accountController.dart';
import 'package:get/get.dart';

class AccountBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountController>(() => AccountController());
  }
}
