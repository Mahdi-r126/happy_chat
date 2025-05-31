import 'package:dio/dio.dart';

class OtpApi {
  final Dio dio;
  final String baseUrl;

  OtpApi({Dio? dio, this.baseUrl = 'http://185.204.197.138/api/v1'})
      : dio = dio ?? Dio();

  Future<String> verifyOtp({
    required String phone,
    required int otp,
  }) async {
    final url = '$baseUrl/verify-otp';
    try {
      final response = await dio.post(
        url,
        data: {
          'phone': phone,
          'otp': otp,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['token'] != null) {
          return data['token'] as String;
        } else {
          throw Exception('خطا در دریافت توکن از سرور');
        }
      } else {
        throw Exception('کد OTP نامعتبر است');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response?.data?['message'] ?? 'خطا در ارسال درخواست';
        throw Exception(msg);
      }
      throw Exception('خطا در ارتباط با سرور: ${e.message}');
    }
  }
}
