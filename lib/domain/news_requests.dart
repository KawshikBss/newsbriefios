import "dart:convert";

import "package:http/http.dart" as http;
import "package:newsbriefapp/data/article_model.dart";
import "package:newsbriefapp/data/comment_model.dart";

Future<Map<String, dynamic>> getAllNews(
    {String? token, int page = 1, String? lang}) async {
  var uri = Uri.parse(
      'https://newsbriefapp.com/api${token != null && token.isNotEmpty ? '/app' : ''}/news?page=$page&locale=$lang');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }
  var response = await http.get(uri, headers: headers);
  List<ArticleModel> data = [];
  int nextPage = page;
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    jsonResponse = jsonResponse['data'];
    var jsonData = jsonResponse['data'] as List<dynamic>;
    data = jsonData.map((item) {
      return ArticleModel.fromJson(item as Map<String, dynamic>);
    }).toList();
    if (page + 1 <= jsonResponse['last_page']) {
      nextPage++;
    }
  }
  return {'data': data, 'next-page': nextPage};
}

Future<Map<String, dynamic>> getTrendingNews(
    {String? token, int page = 1, String? lang}) async {
  var uri = Uri.parse(
      'https://newsbriefapp.com/api${token != null && token.isNotEmpty ? '/app' : ''}/trending?page=$page&locale=$lang');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }
  var response = await http.get(uri, headers: headers);
  List<ArticleModel> data = [];
  int nextPage = page;
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    jsonResponse = jsonResponse['data'];
    var jsonData = jsonResponse['data'] as List<dynamic>;
    data = jsonData.map((item) {
      return ArticleModel.fromJson(item as Map<String, dynamic>);
    }).toList();
    if (page + 1 <= jsonResponse['last_page']) {
      nextPage++;
    }
  }
  return {'data': data, 'next-page': nextPage};
}

Future<List<ArticleModel>> getSavedNews({String? token, String? lang}) async {
  var uri =
      Uri.parse('https://newsbriefapp.com/api/app/saved-news?locale=$lang');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }
  var response = await http.get(uri, headers: headers);
  List<ArticleModel> data = [];
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body) as List<dynamic>;
    data = jsonResponse.map((item) {
      return ArticleModel.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
  return data;
}

Future<bool> readNews(String token, int newsId) async {
  var uri = Uri.parse('https://newsbriefapp.com/api/app/$newsId/read');
  var response = await http.get(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<bool> saveNews(String token, int newsId) async {
  var uri = Uri.parse('https://newsbriefapp.com/api/app/$newsId/save');
  var response = await http.get(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<bool> shareNews(String token, int newsId) async {
  var uri = Uri.parse('https://newsbriefapp.com/api/app/$newsId/share');
  var response = await http.get(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<Map<String, dynamic>> getComments(String? token, int newsId,
    {String? lang}) async {
  var uri = Uri.parse(
      'https://newsbriefapp.com/api${token != null && token.isNotEmpty ? '/app' : ''}/article/$newsId/comments?locale=$lang');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }
  var response = await http.get(uri, headers: headers);
  List<CommentModel> data = [];
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    var commentData = jsonResponse['data'] as List<dynamic>;
    data = commentData.map((item) {
      return CommentModel.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
  return {
    'data': data,
  };
}

Future<bool> sendReply(
    String token, int newsId, int? parentId, String comment) async {
  var uri = Uri.parse('https://newsbriefapp.com/api/app/comment/reply/$newsId');
  Map<String, dynamic> requestBody = {'comment': comment};
  if (parentId != null) {
    requestBody['parent'] = parentId;
  }
  var response = await http.post(uri,
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(requestBody));
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<bool> voteComment(String token, int commentId,
    {int voteType = 1}) async {
  var uri =
      Uri.parse('https://newsbriefapp.com/api/app/comment/vote/$commentId');
  var response = await http.post(uri,
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'vote_type': voteType,
      }));
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<bool> saveComment(
  String token,
  int commentId,
) async {
  var uri =
      Uri.parse('https://newsbriefapp.com/api/app/comment/save/$commentId');
  var response = await http.post(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<bool> reportComment(
  String token,
  int commentId,
) async {
  var uri =
      Uri.parse('https://newsbriefapp.com/api/app/comment/report/$commentId');
  var response = await http.post(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}
