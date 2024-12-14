import 'package:bloodlines/View/Shop/Data/shopController.dart';
import 'package:get/get.dart';

class ShopBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopController>(() => ShopController());
  }
}
