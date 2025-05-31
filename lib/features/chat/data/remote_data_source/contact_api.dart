import 'package:dio/dio.dart';

import '../models/contact.dart';

class ContactApi {
  final String apiBaseUrl = 'http://185.204.197.138/api/v1';
  final String mqttHost = '185.204.197.138';
  final int mqttPort = 1883;
  final String mqttUsername = 'challenge';
  final String mqttPassword = r'sdjSD12$5sd';

  final String userToken;

  late Dio _dio;

  ContactApi({
    required this.userToken,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
  }

  Future<List<Contact>> fetchContacts() async {
    try {
      final response = await _dio.get('/contacts');
      if (response.statusCode == 200) {
        final dataJson = response.data['data'] as List;
        return dataJson.map((e) => Contact.fromJson(e)).toList();
      } else {
        throw Exception('Error in get data');
      }
    } on DioException catch (e) {
      throw Exception('network error: ${e.message}');
    }
  }
}
