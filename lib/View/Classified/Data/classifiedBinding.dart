import 'package:bloodlines/View/Classified/Data/classifiedController.dart';
import 'package:get/get.dart';

class ClassifiedBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassifiedController>(() => ClassifiedController());
  }
}
