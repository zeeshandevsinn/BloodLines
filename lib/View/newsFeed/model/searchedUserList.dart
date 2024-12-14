import 'package:bloodlines/View/Classified/Model/classifiedAdModel.dart';
import 'package:bloodlines/View/Groups/Model/groupModel.dart';
import 'package:bloodlines/View/Pedigree/Model/pedigreeSearchModel.dart';
import 'package:bloodlines/View/newsFeed/model/eventsModel.dart';
import 'package:bloodlines/View/newsFeed/model/postModel.dart';
import 'package:bloodlines/userModel.dart';

class SearchClassUsersList {
  SearchClassUsersList({
    this.currentPage,
    this.userData,
    this.classifiedData,
    this.postData,
    this.groupData,
    this.pedigreeData,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.eventData,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<UserModel>? userData;
  List<ClassifiedAdData>? classifiedData;
  List<PostModel>? postData;
  List<PedigreeSearchData>? pedigreeData;
  List<EventsData>? eventData;
  List<GroupData>? groupData;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String?  nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory SearchClassUsersList.fromJson(Map<String, dynamic> json,
      {String? searchValue}) => SearchClassUsersList(
    currentPage: json["current_page"],
    userData: json["data"] == null
        ? []
        :searchValue == "user"? List<UserModel>.from(
        json["data"]!.map((x) => UserModel.fromJson(x))):
    null,
    classifiedData: json["data"] == null
        ? []
        :searchValue == "classified"?List<ClassifiedAdData>.from(
        json["data"]!.map((x) => ClassifiedAdData.fromJson(x))):
    null,
    postData: json["data"] == null
        ? []
        :searchValue == "post"?List<PostModel>.from(
        json["data"]!.map((x) => PostModel.fromJson(x))):
    null,
    eventData: json["data"] == null
        ? []
        :searchValue == "event"?List<EventsData>.from(
        json["data"]!.map((x) => EventsData.fromJson(x))):
    null,
    groupData: json["data"] == null
        ? []
        :searchValue == "group"?List<GroupData>.from(
        json["data"]!.map((x) => GroupData.fromJson(x))):
    null,
    pedigreeData: json["data"] == null
        ? []
        :searchValue == "pedigree" || searchValue == "dam" || searchValue == "sire"?List<PedigreeSearchData>.from(
        json["data"]!.map((x) => PedigreeSearchData.fromJson(x))):
    null,
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null
        ? []
        : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": userData == null
        ? []
        : List<dynamic>.from(userData!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null
        ? []
        : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}