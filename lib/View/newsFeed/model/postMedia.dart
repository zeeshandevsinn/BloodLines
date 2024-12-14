import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/Components/utils.dart';

class PostMedia {
  PostMedia({
    this.id,
    this.media,
    this.mediaType,
    this.thumbnail,
    this.createdAt,
    this.updatedAt,
  });

  int? id;

  String? media;
  String? mediaType;
  String? thumbnail;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PostMedia.fromJson(Map<String, dynamic> json) {
    if(json["type"] == "video"){
      getDownloadedFile( imageUrl + json["file"]);
    }
    return PostMedia(
      id: json["id"],
      media: json["file"] == null ? null : imageUrl + json["file"],
      mediaType: json["type"],
      thumbnail:
      json["thumbnail"] == null ? null : imageUrl + json["thumbnail"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "file": media,
        "type": mediaType,
        "thumbnail": thumbnail,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
