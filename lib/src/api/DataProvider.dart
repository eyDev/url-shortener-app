import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_shortener_app/src/api/Constants.dart';
import 'package:url_shortener_app/src/models/ErrorModel.dart';
import 'package:url_shortener_app/src/models/UrlModel.dart';
import 'package:url_shortener_app/src/storage/DataStorage.dart';

class DataProvider {
  static final DataProvider _instancia = new DataProvider._();
  factory DataProvider() {
    return _instancia;
  }
  DataProvider._();

  final Constants _constants = Constants();
  final DataStorage storage = new DataStorage();
  final Map<String, String> basicHeader = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<dynamic> login(String email, String pass) async {
    final Map<String, String> body = <String, String>{
      'email': email,
      'password': pass,
    };
    return await _auth(body, '/api/auth/login');
  }

  Future<dynamic> register(String name, String email, String pass) async {
    final Map<String, String> body = <String, String>{
      'name': name,
      'email': email,
      'password': pass,
    };
    return await _auth(body, '/api/auth/register');
  }

  Future<dynamic> _auth(Map<String, String> body, String endpoint) async {
    try {
      final Uri url = Uri.http(_constants.baseUrl, endpoint);
      final http.Response response = await http.post(
        url,
        headers: basicHeader,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        final Map<String, dynamic> usuario = responseBody['usuario'];
        storage.userToken = responseBody['token'];
        storage.userName = usuario['name'];
        storage.userEmail = usuario['email'];
        return response.statusCode;
      } else {
        return _parseErrors(response);
      }
    } catch (e) {
      return _localError();
    }
  }

  Future<List<UrlModel>> getURLs() async {
    final Uri url = Uri.http(_constants.baseUrl, '/api/url');
    final http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-token': storage.userToken,
    });
    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<UrlModel> urls = Urls().modelPlaceFromJson(decodedData['urls']);
    return urls;
  }

  Future<dynamic> newURL(String urlCode, String longUrl) async {
    try {
      final Map<String, dynamic> body = <String, dynamic>{
        'urlCode': urlCode,
        'longUrl': longUrl,
      };
      final Uri url = Uri.http(_constants.baseUrl, '/api/url');

      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-token': storage.userToken,
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        return UrlModel.fromJson(jsonDecode(response.body)['url']);
      } else {
        return _parseErrors(response);
      }
    } catch (e) {
      return _localError();
    }
  }

  Future<dynamic> deleteURL(String id) async {
    try {
      final Uri url = Uri.http(_constants.baseUrl, '/api/url/$id');
      final http.Response response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-token': storage.userToken,
        },
      );
      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return _parseErrors(response);
      }
    } catch (e) {
      return _localError();
    }
  }

  List<DataError> _parseErrors(http.Response response) {
    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<DataError> errors = DataErrors().modelPlaceFromJson(decodedData['errors']);
    return errors;
  }

  List<DataError> _localError() {
    return [
      DataError(
        msg: 'Error Interno, verifique la conección a internet',
        param: 'local',
        location: 'user',
      )
    ];
  }
}
