import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;
import "package:newsbriefapp/data/category_model.dart";

Future<Map<String, dynamic>> loginRequest(
    Map<String, String> credentials) async {
  var uri = Uri.parse('https://newsbriefapp.com/api/app/login');
  var response = await http.post(uri,
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': credentials['email'] ?? '',
        'password': credentials['password'] ?? '',
      }));
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return <String, dynamic>{
      'success': true,
      'token': jsonResponse['token'],
      'user': jsonResponse['user']
    };
  }
  return <String, dynamic>{'success': false, 'message': 'Please try again'};
}

Future<Map<String, dynamic>> socialLoginRequest(
    Map<String, String> credentials) async {
  var uri = Uri.parse('https://newsbriefapp.com/api/app/social-login');
  var response = await http.post(uri,
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': credentials['email'] ?? '',
      }));
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return <String, dynamic>{
      'success': true,
      'token': jsonResponse['token'],
      'user': jsonResponse['user']
    };
  }
  return <String, dynamic>{'success': false, 'message': 'Please try again'};
}

Future<Map<String, dynamic>> registerRequest(
    Map<String, String> credentials) async {
  var uri = Uri.parse('https://newsbriefapp.com/api/app/register');
  var response = await http.post(uri,
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': credentials['email'] ?? '',
        'username': credentials['username'] ?? '',
        'password': credentials['password'] ?? '',
      }));
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return <String, dynamic>{
      'success': true,
      'token': jsonResponse['token'],
      'user': jsonResponse['user']
    };
  }
  return <String, dynamic>{'success': false, 'message': 'Please try again'};
}

Future<bool> findUser(Map<String, String> credentials) async {
  var uri = Uri.parse('https://newsbriefapp.com/api/app/find-user');
  var response = await http.post(uri,
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': credentials['email'] ?? '',
      }));
  print(response.body);
  if (response.statusCode == 200) {
    // var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return true;
  }
  return false;
}

Future<bool> sendForgetPasswordEmail(Map<String, String> credentials) async {
  var uri = Uri.parse('https://newsbriefapp.com/api/app/password/email');
  var response = await http.post(uri,
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': credentials['email'] ?? '',
      }));
  if (response.statusCode == 200) {
    // var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return true;
  }
  return false;
}

Future<Map<String, dynamic>> getUser(String? token) async {
  if (token != null) {
    var uri = Uri.parse('https://newsbriefapp.com/api/app/user');
    var response = await http.get(
      uri,
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return <String, dynamic>{'success': true, 'user': jsonResponse};
    }
  }
  return <String, dynamic>{'success': false, 'message': 'Please try again'};
}

Future<Map<String, dynamic>> updateProfile(
    String? token, Map<String, String> userData, File? avatar) async {
  if (token != null) {
    var uri = Uri.parse('https://newsbriefapp.com/api/app/update-profile');
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(<String, String>{
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (avatar != null) {
      request.files
          .add(await http.MultipartFile.fromPath('avatar', avatar.path));
    }
    request.fields.addAll(<String, String>{
      'name': userData['name'] ?? '',
      'username': userData['username'] ?? '',
      'website': userData['website'] ?? '',
      'bio': userData['bio'] ?? '',
      'email': userData['email'] ?? ''
    });
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseString) as Map<String, dynamic>;
      return <String, dynamic>{'success': true, 'user': jsonResponse['user']};
    }
  }
  return <String, dynamic>{'success': false, 'message': 'Please try again'};
}

Future<Map<String, dynamic>> getUserLocations(String? token) async {
  if (token != null) {
    var uri = Uri.parse('https://newsbriefapp.com/api/app/locations');
    var response = await http.get(
      uri,
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List<dynamic>;
      return <String, dynamic>{'success': true, 'locations': jsonResponse};
    }
  }
  return <String, dynamic>{'success': false, 'message': 'Please try again'};
}

Future<bool> setUserLocation(
    String? token, Map<String, dynamic> location) async {
  if (token != null) {
    var uri = Uri.parse('https://newsbriefapp.com/api/app/set-location');
    var response = await http.post(uri,
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(location));
    if (response.statusCode == 200) {
      return true;
    }
  }
  return false;
}

Future<bool> removeUserLocation(
    String? token, Map<String, dynamic> location) async {
  if (token != null && location['id'] != null) {
    var uri = Uri.parse(
        'https://newsbriefapp.com/api/app/remove-location/${location['id']}');
    var response = await http.post(
      uri,
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    }
  }
  return false;
}

Future<bool> setUserLanguage(String? token, String lang) async {
  if (token != null) {
    var uri = Uri.parse('https://newsbriefapp.com/api/app/set-language');
    var response = await http.post(uri,
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'lang': lang}));
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    }
  }
  return false;
}

Future<Map<String, dynamic>> getAllInterests({String lang = 'en'}) async {
  var uri = Uri.parse('https://newsbriefapp.com/api/categories?locale=$lang');
  var response = await http.get(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body) as List<dynamic>;
    List<CategoryModel> categories =
        data.map((item) => CategoryModel.fromJson(item)).toList();

    return {'success': true, 'data': categories};
  }

  return {'success': false};
}

Future<bool> setUserInterests(String? token, List<dynamic> interests) async {
  if (token != null) {
    var uri = Uri.parse('https://newsbriefapp.com/api/app/set-interests');
    var response = await http.post(uri,
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'interests': interests}));
    if (response.statusCode == 200) {
      return true;
    }
  }
  return false;
}
