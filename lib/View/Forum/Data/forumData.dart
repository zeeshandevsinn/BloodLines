import 'package:bloodlines/Components/Network/API.dart';
import 'package:bloodlines/View/Forum/Model/forumDetailsModel.dart';
import 'package:bloodlines/View/Forum/Model/forumModel.dart';
import 'package:bloodlines/View/Forum/Model/topicModel.dart';
import 'package:dio/dio.dart';

class ForumData {
  Future<Response> createTopic({
    int? id,
    int? topicId,
    MultipartFile? media,
    String? title,
    String? content,
    bool isUpdate = false,
  }) async {
    var map = {
      "title": title,
      "content": content,
      if(media != null)"media":media,
     if(topicId == null) "forum_id": id,
    };

    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response =
        await Api.singleton.post(formData,isUpdate == true?"topic/update?id=$id": 'topic/create', multiPart: true);
    return response;
  }

  Future<Response> deleteTopic({
    int? id,

  }) async {
    var map = {
      "topic_id": id,
    };

    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response =
        await Api.singleton.post(formData, 'topic/delete', multiPart: true);
    return response;
  }

  Future<Response> deleteResponse({
    int? id,

  }) async {
    var map = {
      "response_id": id,
    };

    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response =
        await Api.singleton.post(formData, 'response/delete', multiPart: true);
    return response;
  }


  Future<Response> deleteResponseComment({
    int? id,

  }) async {
    var map = {
      "comment_id": id,
    };

    FormData formData = FormData.fromMap(map);
    print(formData);

    Response response =
        await Api.singleton.post(formData, 'response/comment/delete', multiPart: true);
    return response;
  }

  Future<Response> createResponse({
    int? topicId,
    int? responseId,
    List<int>? pedigrees = const [],
    List<int>? peoples,
    String? content,
  }) async {
    var map = {
      "topic_id": topicId,
      "content": content,
      if(pedigrees!.isNotEmpty) "pedigree[]":pedigrees,
      if(peoples!.isNotEmpty) "people[]":peoples,
    };

    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData,responseId != null?'response/update?id=$responseId': 'response/create', isProgressShow: false);
    return response;
  }


  Future<Response> createComment({
    int? responseId,
    int? commentId,
    String? content,
  }) async {
    var map = {
      "response_id": responseId,
      "comment": content,
    };

    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData,commentId == null? 'response/comment':'response/comment/edit?id=$commentId', isProgressShow: false);
    return response;
  }

  Future<Response> createForum({
    String title = "",
    String content = "",
    int? forumId,
  }) async {
    var map = {
      "title": title,
      "content": content,
      "forum_id": forumId,
    };

    FormData formData = FormData.fromMap(map);

    Response response = await Api.singleton
        .post(formData, 'topic/create', isProgressShow: true);
    return response;
  }

  Future<ForumModel> getForums({fullUrl}) async {
    Response response = await Api.singleton.get('forums', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      return ForumModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<ForumDetailsModel> getTopicDetails(id, {fullUrl}) async {
    Response response = await Api.singleton
        .get('topic', fullUrl: fullUrl, queryParameters: {"id": id});
    if (response.statusCode == 200) {
      return ForumDetailsModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<TopicModel> getAllTopics(id, {fullUrl}) async {
    Response response = await Api.singleton.get('forum/topics',
        fullUrl: fullUrl, queryParameters: {"forum_id": id});
    if (response.statusCode == 200) {
      return TopicModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<bool> getUnseenMessages() async {
    Response response = await Api.singleton.get('unseen-message');
    if (response.statusCode == 200) {
      return response.data["data"]["unseen_status"];
    } else {
      throw Exception(response.statusMessage);
    }
  }

}
