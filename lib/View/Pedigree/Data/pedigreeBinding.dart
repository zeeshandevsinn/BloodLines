import 'package:bloodlines/View/Pedigree/Data/pedigreeController.dart';
import 'package:get/get.dart';

class PedigreeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PedigreeController>(() => PedigreeController());
  }
}
