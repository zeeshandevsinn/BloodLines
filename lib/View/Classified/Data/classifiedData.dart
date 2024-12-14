import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/View/Classified/Model/categoryModel.dart';
import 'package:bloodlines/View/Classified/Model/classifiedAdModel.dart';
import 'package:dio/dio.dart';

class ClassifiedData {
  Future<Response> createAd({
    String location = "",
    String latitude = "",
    String longitude = "",
    String price = "",
    String description = "",
    String title = "",
    String? status = "",
    String? week = "",
    int? categoryId,
    bool isUpdate = false,
    int? adId,
    List<MultipartFile>? cover,
  }) async {
    var map = {
      "category_id": categoryId,
      "title": title,
      "active_till_week": week!.toLowerCase(),
      "description": description,
      "price": price,
      if(isUpdate == true)"status":status,
    };

    if (cover!.isNotEmpty) {
      map["cover[]"] = cover;
    }
    if (location.isNotEmpty) {
      map["location"] = location;
      map["latitude"] = latitude;
      map["longitude"] = longitude;
    }

    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response = await Api.singleton.post(formData,
        adId == null ? 'classified/create' : 'classified/update?id=$adId',
        multiPart: true);
    return response;
  }

  Future<Response> invitePeople({
    int? eventId,
    List<int> members = const [],
  }) async {
    var map = {
      "event_id": eventId,
      "member[]": members,
    };

    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'event/invite-people', isProgressShow: false);
    return response;
  }

  Future<Response> deleteClassified({
    String classifiedId = "",
  }) async {
    var map = {
      "id": classifiedId,
    };

    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton.post(
      formData,
      'classified/delete',
    );
    return response;
  }

  Future<ClassifiedCategoriesModel> getCategories({fullUrl}) async {
    Response response =
        await Api.singleton.get('classified/categories', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      return ClassifiedCategoriesModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<ClassifiedAdModel> getClassifiedAds(
      {int? id, fullUrl, bool my = false}) async {
    Response response = await Api.singleton.get(
        my == true ? 'classified/list/auth' : 'classified/list',
        fullUrl: fullUrl,
        queryParameters: {
          if (my == false) "category_id": id ?? 0,
        });
    if (response.statusCode == 200) {
      return ClassifiedAdModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<ClassifiedAdData> getClassifiedDetails(int id) async {
    Response response = await Api.singleton.get('classified', queryParameters: {
      "id": id,
    });
    if (response.statusCode == 200) {
      return ClassifiedAdData.fromJson(response.data["data"]);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}
