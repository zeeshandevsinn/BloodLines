import 'package:better_player/better_player.dart';
import 'package:bloodlines/Components/Network/API.dart';
import 'package:get/get.dart';

class MediaClass {
  MediaClass({
    this.id,
    this.filename,
    this.fileType,
    this.thumbnail,
    this.isInitialize,
    this.betterPlayerController,
    this.type,
  });

  String? id;
  String? filename;
  String? fileType;
  String? thumbnail;
  BetterPlayerController? betterPlayerController;
  RxBool? isInitialize;
  String? type;

  factory MediaClass.fromJson(Map<String, dynamic> json) {
    return MediaClass(
      id: json["file_id"],
      filename: json["filename"] == null
          ? null
          : json["filename"].toString().contains(imageUrl)
          ? json["filename"]
          : imageUrl + json["filename"],
      fileType: json["file_type"],
      isInitialize: false.obs,
      betterPlayerController: json["file_type"] == "video"
          ? BetterPlayerController(
        BetterPlayerConfiguration(
          // autoPlay: true,
          // autoDispose: true,
        ),
        betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          json["filename"].toString().contains(imageUrl)
              ? json["filename"]
              : imageUrl + json["filename"],
        ),
      )
          : null,
      thumbnail: json["thumbnail"] == null
          ? null
          : json["thumbnail"].toString().contains(imageUrl)
          ? json["thumbnail"]
          : imageUrl + json["thumbnail"],
      type: "Network",
    );
  }

  Map<String, dynamic> toJson() => {
    "filename": filename,
    "file_type": fileType,
    "thumbnail": thumbnail,
  };
}
