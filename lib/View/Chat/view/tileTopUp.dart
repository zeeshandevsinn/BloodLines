// ignore_for_file: must_be_immutable

import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/customWidget.dart';
import 'package:bloodlines/View/Chat/model/chatModel.dart';
import 'package:flutter/material.dart';

class ChatTilePopUp extends StatelessWidget {
  ChatTilePopUp({
    super.key,
    required this.onTap,
    required this.id,
    required this.chatModel,
  });
  final Function(ItemModel) onTap;
  final int id;
  final ChatMessageItem chatModel;
  late List<ItemModel> chatTileMenuList = [
    ItemModel('Delete', Icons.delete),
    ItemModel('Reply', Icons.reply),
    ItemModel('Flagged', Icons.flag),
  ];

  @override
  Widget build(BuildContext context) {
    print(Api.singleton.sp.read("id"));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: chatModel.isFlag ==1 || id == Api.singleton.sp.read("id")?150:200,
          height: 50,
          color: const Color(0xFF4C4C4C),
          child: GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            crossAxisCount:chatModel.isFlag ==1 || id == Api.singleton.sp.read("id")?2: 3,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: chatTileMenuList
                .map((item) => GestureDetector(
                      onTap: () {
                        onTap(item);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            item.icon,
                            size: 20,
                            color: Colors.white,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 2),
                            child: Text(
                              item.title,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class ChatPopUpMenu extends StatelessWidget {
  ChatPopUpMenu({
    super.key,
    required this.onTap,
  });
  final Function(ItemModel, BuildContext) onTap;
  late List<ItemModel> menuItems = [
    ItemModel('Video', Icons.video_call_outlined),
    ItemModel('Gallery', Icons.image),
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: 150,
          height: 50,
          color: const Color(0xFF4C4C4C),
          child: GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: menuItems
                .map((item) => Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          onTap(item, context);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              item.icon,
                              size: 20,
                              color: Colors.white,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 2),
                              child: Text(
                                item.title,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      );
                    }))
                .toList(),
          ),
        ),
      ),
    );
  }
}
