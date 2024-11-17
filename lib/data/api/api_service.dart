import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1/';
  static const String _register = 'register';
  static const String _login = 'login';
  static const String _getStories = 'stories';
  static const String _getDetailStory = 'stories/';
  static const String _addStory = 'stories';

  Future<Map<String, String>> _getHeaders() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _handleApiCall(() async {
      final url = Uri.parse('$_baseUrl$_register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      return _processResponse<Map<String, dynamic>>(response, (data) => data);
    });
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _handleApiCall(() async {
      final url = Uri.parse('$_baseUrl$_login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      return _processResponse<Map<String, dynamic>>(response, (data) => data);
    });
  }

  Future<List<dynamic>> getAllStories() {
    return _handleApiCall(() async {
      final headers = await _getHeaders();
      final url = Uri.parse('$_baseUrl$_getStories');
      final response = await http.get(url, headers: headers);
      return _processResponse<List<dynamic>>(
          response, (data) => data['listStory']);
    });
  }

  Future<List<dynamic>> getDetailStory(String id) {
    return _handleApiCall(() async {
      final headers = await _getHeaders();
      final url = Uri.parse('$_baseUrl$_getDetailStory$id');
      final response = await http.get(url, headers: headers);
      return _processResponse<List<dynamic>>(
          response, (data) => data['listStory']);
    });
  }

  Future<Map<String, dynamic>> addStory(Map<String, dynamic> storyData) {
    return _handleApiCall(() async {
      final headers = await _getHeaders();
      final url = Uri.parse('$_baseUrl$_addStory');
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(storyData),
      );
      return _processResponse<Map<String, dynamic>>(response, (data) => data);
    });
  }

  Future<T> _handleApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid data format');
    } on HttpException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  T _processResponse<T>(
      http.Response response, T Function(Map<String, dynamic>) fromJson) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody['message'] ==
          "Password must be at least 8 characters long") {
        throw const HttpException(
            'Password must be at least 8 characters long');
      } else if (responseBody['message'] == "Email is already taken") {
        throw const HttpException('Email is already taken');
      } else if (responseBody['message'] == "\"email\" must be a valid email") {
        throw const HttpException('"email" must be a valid email');
      } else if (responseBody['message'] ==
          "\"name\" is not allowed to be empty") {
        throw const HttpException('"name" is not allowed to be empty');
      } else {
        throw HttpException(
            'Bad Request (400): ${responseBody['message'] ?? 'Unknown error'}');
      }
    } else if (response.statusCode == 404) {
      throw const HttpException('Data not found (404)');
    } else if (response.statusCode >= 500) {
      throw const HttpException('Server error (5xx)');
    } else {
      throw HttpException('Failed with status code ${response.statusCode}');
    }
  }
}