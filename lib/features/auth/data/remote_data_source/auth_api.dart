import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio;

  AuthApi([Dio? dio]) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = 'http://185.204.197.138/api/v1';
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<void> sendOtp(String phone) async {
    try {
      final response = await _dio.post(
        '/send-otp',
        data: {'phone': phone},
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('ارسال OTP موفقیت آمیز نبود');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('خطا از سرور: ${e.response?.data}');
      } else {
        throw Exception('خطا در اتصال به سرور');
      }
    } catch (e) {
      throw Exception('خطای نامشخص: $e');
    }
  }
}
