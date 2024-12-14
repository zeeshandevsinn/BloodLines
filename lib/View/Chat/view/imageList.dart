import 'package:bloodlines/Components/Color.dart';
import 'package:bloodlines/Components/TextStyle.dart';
import 'package:bloodlines/Components/appbarWidget.dart';
import 'package:bloodlines/Components/utils.dart';
import 'package:bloodlines/Routes/app_pages.dart';
import 'package:bloodlines/View/Chat/model/mediaClass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class ImageListView extends StatelessWidget {
  ImageListView({Key? key}) : super(key: key);
  final List<MediaClass> media = Get.arguments["list"];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: DynamicColors.primaryColorLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: AppBarWidgets(),
        centerTitle: true,
        title: Text(
          "Photos",
          style:
          poppinsSemiBold(color: DynamicColors.primaryColor, fontSize: 28),
        ),
        elevation: 0,

      ),
      body: ListView.builder(
          itemCount: media.length,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemBuilder: (context,index){
        return GestureDetector(
          onTap: (){
            if(media[index].filename!.split(".").last == "mp4" || media[index].filename!.split(".").last == "mov"){
              Get.toNamed(Routes.videoPlayerClass, arguments: {
                "url": media[index].filename!,
                "type": "network"
              });
            }else{
              Get.toNamed(Routes.photo,arguments: {
                "image": media[index].filename!
              });
            }

          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: OptimizedCacheImage(
              imageUrl:media[index].filename!.split(".").last == "mp4" || media[index].filename!.split(".").last == "mov"? media[index].thumbnail!:media[index].filename!,
              fit: BoxFit.cover,
              width: Utils.width(context) ,
              // height:height??100,
            ),
          ),
        );
      }),
    );
  }
}
