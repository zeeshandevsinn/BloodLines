import 'package:get/get.dart';
import 'package:bloodlines/View/Chat/controller/chatController.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
