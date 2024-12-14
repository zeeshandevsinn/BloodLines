import 'dart:io';
import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/loader.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class VideoPlayerClass extends StatefulWidget {
  const VideoPlayerClass({Key? key}) : super(key: key);

  @override
  State<VideoPlayerClass> createState() => _VideoPlayerClassState();
}

class _VideoPlayerClassState extends State<VideoPlayerClass> {
  String url = Get.arguments["url"];
  String type = Get.arguments["type"];
  BetterPlayerController? betterPlayerController;

  betterPlayerConfig({File? file}) {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        file == null && type == "network"
            ? BetterPlayerDataSourceType.network
            : BetterPlayerDataSourceType.file,
        file == null ? url : file.path);
    betterPlayerController = BetterPlayerController(BetterPlayerConfiguration(
      autoDetectFullscreenDeviceOrientation: true,
    ));

    betterPlayerController!.setupDataSource(dataSource);
    betterPlayerController!.setOverriddenAspectRatio(0.58);
    betterPlayerController!.setOverriddenFit(BoxFit.contain);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (type == "file") {
      betterPlayerConfig();
    } else {
      getCacheFile();
    }
  }

  @override
  void dispose() {
    betterPlayerController?.dispose();
    super.dispose();
  }

  getCacheFile() async {
    var files = await DefaultCacheManager().getFileFromCache(url);
    if (files == null) {
      betterPlayerConfig();
    } else {
      betterPlayerConfig(file: files.file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: AppBarWidgets(),
        title: Text(
          "Video Player",
          style: poppinsSemiBold(color: DynamicColors.whiteColor, fontSize: 28),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: betterPlayerController != null
          ? BetterPlayer(
              controller: betterPlayerController!,
            )
          : Center(
              child: LoaderClass(
                colorOne: Colors.white,
                colorTwo: Colors.white54,
              ),
            ),
    );
  }
}
