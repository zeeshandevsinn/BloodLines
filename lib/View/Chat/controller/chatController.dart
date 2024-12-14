// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:bloodlines/Components/loader.dart';
import 'package:bloodlines/View/Chat/model/mediaClass.dart';
import 'package:bloodlines/View/Chat/view/tileTopUp.dart';
import 'package:bloodlines/View/newsFeed/data/feedController.dart';
import 'package:bloodlines/View/newsFeed/view/post/newPost.dart';
import 'package:bloodlines/userModel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as form;
import 'package:bloodlines/View/Chat/controller/chatServices.dart';
import 'package:bloodlines/View/Chat/database/dbConfig.dart';
import 'package:bloodlines/View/Chat/model/chatModel.dart';
import 'package:bloodlines/View/Chat/model/inboxModel.dart';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sql.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:video_compress/video_compress.dart';
// import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ChatController extends GetxController {
  GroupedItemScrollController? scrollController;
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  TextEditingController searchController = TextEditingController();
  TextEditingController messageEditingController = TextEditingController();
  InboxServices inboxServices = InboxServices();
  InboxModel? inbox;
  TextEditingController storyMessage = TextEditingController();
  TextEditingController groupName = TextEditingController();
  TextEditingController search = TextEditingController();
  final CustomPopupMenuController customPopupMenuController =
      CustomPopupMenuController();
  final focusNode = FocusNode();
  dynamic chatDatabase;

  ///list and models
  ChatMessageItem? replyModel;
  InboxData? inboxData;
  UserModel? userData;
  final ChatDatabase _chatDatabase = ChatDatabase();
  ChatModel? chatModel;
  List<Permission> permissionsNeeded = [Permission.camera, Permission.storage];

  final ImagePicker _picker = ImagePicker();

  List<MediaClass> tempList = [];
  List<ChatMessageItem> databaseCheckList = [];

  ///String

  String? replyId;
  String? type;
  int? receiverId;
  String? inboxId;
  Socket? socket;
  Subscription? _subscription;

  /// bool
  RxBool isReplying = false.obs;
  RxBool fieldUpdate = false.obs;
  RxBool bottomContainer = false.obs;
  RxBool animatedOpacity = false.obs;
  bool wait = false;
  bool chatWait = false;
  bool loading = true;
  bool groupWait = true;
  bool isOnChat = false;
  bool isPermissionsGranted = false;
  RxBool bottomPosition = false.obs;
  RxBool onlineStatus = false.obs;
  RxBool oneTime = false.obs;
  int from = 2;
  int? selectedIndex;
  bool isEndCall = true;

  ///media
  List<XFile> imageFile = [];
  List<File> videoThumbnail = [];
  File? pdfThumbnail;
  File? file;
  dynamic pickImageError;
  FeedController controller = Get.find();
  @override
  void onInit() {
    super.onInit();
    scrollController = GroupedItemScrollController();
    getInbox();
    initDatabase();
  }

  _videoFromGallery(context) async {
    try {
      final XFile? list = await _picker.pickVideo(source: ImageSource.gallery);
      customPopupMenuController.hideMenu();
      if (list != null) {
        showCompressLoading();

        _subscription = VideoCompress.compressProgress$.subscribe((progress) {
          chatProgress.value = progress;
        });
        await VideoCompress.compressVideo(list.path,
                quality: VideoQuality.MediumQuality)
            .then((value) {
          chatProgress.value = 0;
          _subscription!.unsubscribe();
          BotToast.closeAllLoading();
          imageFile.add(XFile(value!.path!));
          tempList.add(MediaClass(filename: value.path!, type: "video"));
        });
      }

      fieldUpdate.value = !fieldUpdate.value;
      update();
    } catch (e) {
      pickImageError = e;
    }
  }

  picker(ImageSource source) async {
    return await _picker.pickMultiImage(imageQuality: 50);
  }

  imgFromCamera() async {
    try {
      final XFile? xFile = await _picker.pickImage(source: ImageSource.camera);
      if (xFile != null) {
        imageFile.add(xFile);
        customPopupMenuController.hideMenu();
        type = 'image';
        tempList.add(
            MediaClass(filename: xFile.path, type: "image", fileType: "image"));
        fieldUpdate.value = !fieldUpdate.value;
        update();
      }
    } catch (e) {
      pickImageError = e;
    }
  }

  _imgFromGallery(context) async {
    try {
      final List<XFile> results = await _picker.pickMultiImage();
      if (results.length > 10) {
        BotToast.showText(text: "You cannot select more than 10 images");
      } else {
        customPopupMenuController.hideMenu();
        imageFile.addAll(results);
        for (int i = 0; i < results.length; i++) {
          tempList.add(MediaClass(
              filename: results[i].path, type: "image", fileType: "image"));
        }
        fieldUpdate.value = !fieldUpdate.value;
        update();
      }
    } catch (e) {
      pickImageError = e;
    }
  }

  Widget popUpMenu() {
    return ChatPopUpMenu(
      onTap: (item, context) async {
        Map<Permission, PermissionStatus> statuses =
            await permissionsNeeded.request();
        if (item.title == 'Gallery') {
          if (statuses.values
              .every((status) => status == PermissionStatus.granted)) {
            isPermissionsGranted = true;
            customPopupMenuController.hideMenu();
            _imgFromGallery(context);
          } else {
            BotToast.showText(text: 'Permission not granted');
          }
        } else if (item.title == 'Video') {
          if (statuses.values
              .every((status) => status == PermissionStatus.granted)) {
            isPermissionsGranted = true;
            customPopupMenuController.hideMenu();
            _videoFromGallery(context);
          } else {
            BotToast.showText(text: 'Permission not granted');
          }
        }
      },
    );
  }

  getInbox() async {
    inbox = await inboxServices.getInbox();
    update();
  }

  clearChat() async {
    Get.back();
    final response = await inboxServices.clearChat(inboxId: inboxId!);
    if (response.statusCode == 200) {
      var chatDb = await _chatDatabase.getDatabase;
      await chatDb.delete('Chat', where: "conversation_id = '$inboxId'");
      chatModel!.data!.items!.clear();
      update();
      getInbox();
    }
  }

  deleteInbox(inboxID) async {
    final response = await inboxServices.deleteInbox(inboxId: inboxID);
    if (response.statusCode == 200) {
      var chatDb = await _chatDatabase.getDatabase;
      await chatDb.delete('Chat', where: "conversation_id = '$inboxID'");
      if (chatModel != null) {
        chatModel!.data!.items!.clear();
      }
      getInbox();
    }
  }

  initDatabase() async {
    chatDatabase = await _chatDatabase.getDatabase;
    socketInit();
  }

  updateFieldValue(child) {
    if (fieldUpdate.value) {
      return child;
    }
    return child;
  }

  socketInit() {
    print("chatting");

    Map<String, dynamic> map = {
      'auth': {
        'token': Api.singleton.sp.read("token"),
        'user_id': Api.singleton.sp.read("id")
      },
    };
    socket = io(
        socketUrl,
        OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .setAuth(map)
            .build());
    socket!.connect();
    socket!.onConnect((_) {
      socket!.emit('user-connect', {'user_id': Api.singleton.sp.read("id")});
      print('socket is connect');
    });
    socket!.onDisconnect((_) {
      print('socket is disconnect');
    });
    socket!.on('receiver-message-${Api.singleton.sp.read("id")}', (data) {
      receiveMessageEvent(data);
      controller.getUnseenMessages();
    });

    connectDisconnect();
  }

  connectDisconnect() {
    socket!.on('user-connected', (data) {
      var d = UserModel.fromJson(data);
      if (userData != null && d.id == userData!.id) {
        if (userData!.userStatus!.value != true) {
          userData!.userStatus!.value = true;
          userData!.updatedAt = DateTime.parse(data["updated_at"].toString());
        }
      }
    });

    socket!.on('user-dis-connected', (data) {
      var d = UserModel.fromJson(data);
      if (userData != null && d.id == userData!.id) {
        if (userData!.userStatus!.value != false) {
          userData!.userStatus!.value = false;
          userData!.updatedAt = DateTime.parse(data["updated_at"].toString());
        }
      }
    });
  }

  bool isSocketOn = false;
  deleteMessage(conversationId) {
    isSocketOn = true;
    socket!.on('message-delete-everyone-$conversationId', (data) async {
      var d = ChatMessageItem.fromJson(data);
      d.isDeleted = 1;
      if (isOnChat == true) {
        int index =
            chatModel!.data!.items!.indexWhere((element) => element.id == d.id);
        chatModel!.data!.items![index].isDeleted = 1;
        var dbs = await _chatDatabase.getDatabase;
        dbs.update('Chat', d.toJson(), where: 'id = ${d.id}');
        update();
      } else {
        getInbox();
      }
    });
  }

  receiveMessageEvent(data) {
    var d = ChatMessageItem.fromJson(data["message"]);
    if (isOnChat == true) {
      if (d.inboxId.toString() == inboxId.toString()) {
        chatModel!.data!.items!.insert(0, d);

        if (inbox!.data!.isNotEmpty) {
          int index = inbox!.data!
              .indexWhere((element) => element.id.toString() == inboxId);
          if (index != -1) {
            inbox!.data![index].unseenMessage!.value = 0;
          } else {
            getInbox();
          }
        }
        update();
        messageSeen(inboxId);
      }
    } else {
      getInbox();
    }
  }

  seenMessageSocket(inboxId, i) {
    socket!.on('seen-message-$inboxId', (data) {
      print(data);
      for (int i = 0; i < data["message_count"]; i++) {
        if (chatModel != null) {
          if (chatModel!.data!.items![i].isSeen == 0) {
            chatModel!.data!.items![i].isSeen = 1;
          } else {
            break;
          }
        }
      }
      update();
    });
  }

  flagMessage(messageId,index,ChatMessageItem element)async{
    var formData = form.FormData.fromMap({"message_id": messageId});
    var resp = await Api.singleton
        .post(formData, "flag-message", isProgressShow: true);
    if (resp.statusCode == 200) {
      element.isFlag = 1;
      var db = await _chatDatabase.getDatabase;
      await db.update(
        'Chat',
        element.toJson(),
        where: '(id = ${element.id})',
      );
      chatModel!.data!.items = await getChatLocalDb();
      update();
      BotToast.showText(text: "Flag request has been sent to admin");

    }
  }

  ///alert appear when user click delete button on long press popup
  alertDialog(
    ChatMessageItem element,
    index, {
    isTime = false,
  }) {
    return Get.dialog(AlertDialog(
      backgroundColor: Colors.black87,
      title: Text(
        'Delete Message',
        style:
            poppinsLight(color: DynamicColors.primaryColorLight, fontSize: 18),
      ),
      content: Text(
        'Are you sure you want to delete the message?',
        style:
            poppinsLight(color: DynamicColors.primaryColorLight, fontSize: 15),
      ),
      actions: [
        TextButton(
            child: Text(
              'Delete',
              style: poppinsLight(
                  color: DynamicColors.primaryColorLight, fontSize: 12),
            ),
            onPressed: () async {
              var db = await _chatDatabase.getDatabase;
              print(chatModel!.data!.items![index].toJson());
              await db.delete('Chat',
                  where: '(id = ${element.id})');
              chatModel!.data!.items = await getChatLocalDb();
              var formData = form.FormData.fromMap({"message_id": element.id});
              var resp = await Api.singleton
                  .post(formData, "delete-for-me", isProgressShow: true);
              if (resp.statusCode == 200) {
                element.deleteBy =
                    Api.singleton.sp.read("id");
              }
              update();
              getInbox();
              Get.back();
            }),
        isTime == true
            ? SizedBox()
            : element.senderId == Api.singleton.sp.read("id")
                ? TextButton(
                    child: Text(
                      'Delete For EveryOne',
                      style: poppinsLight(
                          color: DynamicColors.primaryColorLight, fontSize: 12),
                    ),
                    onPressed: () async {
                      var db = await _chatDatabase.getDatabase;
                      element.isDeleted = 1;
                      await db.update(
                        'Chat',
                        element.toJson(),
                        where: '(id = ${element.id})',
                      );
                      chatModel!.data!.items = await getChatLocalDb();
                      var formData =
                          form.FormData.fromMap({"message_id": element.id});
                      var resp = await Api.singleton.post(
                          formData, "delete-for-everyone",
                          isProgressShow: true);
                      if (resp.statusCode == 200) {
                        element.isDeleted = 1;
                      }
                      update();
                      getInbox();
                      Get.back();
                    })
                : SizedBox(),
        TextButton(
            child: Text(
              'No',
              style: poppinsLight(
                  color: DynamicColors.primaryColorLight, fontSize: 12),
            ),
            onPressed: () {
              Get.back();
            }),
      ],
    ));
  }

  ///every chat tile long press popup, if user long press on any tile popup will appear so he can delete or reply
  Widget chatTilePopUp(ChatMessageItem element, context, index,
      {isTime = false}) {

    return ChatTilePopUp(
      chatModel:element,
      id:element.senderId!,
      onTap: (item) async {
        if (item.title == 'Reply') {
          Navigator.pop(context);
          isReplying.value = true;
          replyModel = element;
          focusNode.requestFocus();
          update();
        } else if (item.title == 'Delete') {
          Navigator.pop(context);
          var date = DateTime.parse(element.createdAt!).toLocal();
          var difference = DateTime.now().difference(date).inHours;
          print(difference);
          if (difference > 1) {
            alertDialog(
              element,
              index,
              isTime: true,
            );
          } else {
            alertDialog(element, index);
          }
        }
        else if (item.title == 'Flagged') {
          Navigator.pop(context);
          flagMessage(element.id, index,element);

        }
      },
    );
  }

  sendMessage({isGroup = false, id}) async {
    List fileList = [];
    if (tempList.isNotEmpty) {
      for (int i = 0; i < tempList.length; i++) {
        fileList.add(form.MultipartFile.fromFileSync(tempList[i].filename!,
            filename:
                "${tempList[i].type!.toString().capitalizeFirst}.${tempList[i].filename!.split(".").last}",
            contentType: MediaType(
                tempList[i].type!, tempList[i].filename!.split(".").last)));
      }
    }
    final response = await inboxServices.sendMessage(
      text: messageEditingController.text,
      replyID: replyId,
      receiverId: receiverId,
      fileList: fileList,
      inboxId: inboxId,
    );
    if (response != null) {
      inboxId = response.inboxId;
      if (Api.singleton.sp.read("id") != receiverId) {
        if (chatModel == null) {
          chatModel = ChatModel();
          chatModel!.data = ChatData(items: [response]);
        } else {
          chatModel!.data!.items!.insert(0, response);
        }
      }
      BotToast.closeAllLoading();
      tempList.clear();
      imageFile.clear();
      update();
      insertChatDatabase(oneInsertion: true, model: response);
      clear();
      if (chatModel!.data!.items!.length > 13) {
        scrollController!
            .jumpTo(index: 0, alignment: 0.4, automaticAlignment: false);
      }
    }
  }

  ///scrollToIndex
  scroll(id, currentIndex) {
    if (id != null) {
      print(id);
      int index = chatModel!.data!.items!.indexWhere((element) {
        return element.id == id;
      });
      selectedIndex = index;
      if (chatModel!.data!.items![index].isDeleted == null ||
          chatModel!.data!.items![index].isDeleted != 1) {
        if (currentIndex <= 1 && (index - currentIndex) <= 3) {
          animatedOpacity.value = true;
          update();
          Future.delayed(Duration(milliseconds: 1000), () {
            animatedOpacity.value = false;
            update();
          });
        } else {
          if ((index - currentIndex) > 2) {
            scrollController!.jumpTo(
                index: index, alignment: 0.5, automaticAlignment: false);
            animatedOpacity.value = true;
            Future.delayed(Duration(milliseconds: 500), () {
              animatedOpacity.value = false;
              update();
            });
          } else {
            animatedOpacity.value = true;
            update();
            Future.delayed(Duration(milliseconds: 1000), () {
              animatedOpacity.value = false;
              update();
            });
          }
        }
      }
    }
  }

  getUserChat(
    int receiverID, {
    fullUrl,
    sender = false,
    fromFriend = false,
    fromChatRoom = false,
  }) async {
    if (fromFriend == true) {
      chatModel = null;
    }
    if (fullUrl == null) {
      if (chatModel != null) {
        chatModel!.data!.items!.clear();
        chatModel!.data!.items = await getChatLocalDb();
        update();
      }
    }
    ChatModel data =
        await inboxServices.getUserChat(receiverID, fullUrl: fullUrl);
    if (fullUrl == null) {
      chatModel = data;
    } else {
      int length = chatModel!.data!.items!.length;
      chatModel!.data!.items!.addAll(data.data!.items!);
      chatModel!.data!.links = data.data!.links!;
      if (length != chatModel!.data!.items!.length) {
        chatWait = false;
      }
    }
    if (fromFriend == true) {
      if (chatModel!.data!.items!.isNotEmpty) {
        inboxId = chatModel!.data!.items![0].inboxId;
        if (isSocketOn == false) {
          deleteMessage(inboxId);
        }
      }
    }
    update();
    insertChatDatabase();
  }

  clear() {
    messageEditingController.clear();
    pdfThumbnail = null;
    file = null;
    imageFile.clear();
    type = null;
    oneTime.value = false;
    videoThumbnail.clear();
    replyModel = null;
    replyId = null;
    isReplying.value = true;
    isReplying.value = false;
    fieldUpdate.value = true;
    fieldUpdate.value = false;
    update();
  }

  messageSeen(inboxId) async {
    final response = await inboxServices.messageSeen(inboxId: inboxId);
    if (response.statusCode == 200) {
      getInbox();
    }
  }

  insertChatDatabase({oneInsertion = false, ChatMessageItem? model}) async {
    final db = await chatDatabase;
    if (oneInsertion == true) {
      await db.insert(
        'Chat',
        model!.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      for (int i = 0; i < chatModel!.data!.items!.length; i++) {
        await chatDatabase.insert(
          'Chat',
          chatModel!.data!.items![i].toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      chatModel!.data!.items = await getChatLocalDb();
      update();
    }
  }

  Future<List<ChatMessageItem>> getChatLocalDb() async {
    final db = await chatDatabase;
    if (db == null) {
      return [];
    }
    final List<Map<String, dynamic>> maps =
        await db.query('Chat', where: "conversation_id = '$inboxId'");
    return List.generate(maps.length, (i) {
      return inboxServices.getLocalDbChat(maps, i);
    });
  }
}
