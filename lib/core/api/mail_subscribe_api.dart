import 'package:dio/dio.dart';

class MailSubscribeApi {
  final String _endpoint =
      'https://nodejs-serverless-function-express-lac-pi.vercel.app/api';
  final Dio dio;

  MailSubscribeApi(this.dio);

  Future<Response> sendBulkEmails() async {
    try {
      final response = await dio.post(
        '$_endpoint/sendBulkEmails',
      );
      return response;
    } catch (e) {
      print('Error subscribing: $e');
      return Response(requestOptions: RequestOptions(path: ''));
    }
  }

  Future<Response> subscribe(String email, String location) async {
    try {
      final response = await dio.post(
        '$_endpoint/subscribe',
        data: {
          'email': email,
          'location': location,
        },
      );
      return response;
    } catch (e) {
      print('Error subscribing: $e');
      return Response(requestOptions: RequestOptions(path: ''));
    }
  }

  Future<Response> unsubscribe(String email) async {
    try {
      final response = await dio.delete(
        '$_endpoint/subscribe',
        data: {
          'emailToDelete': email,
        },
      );
      return response;
    } catch (e) {
      print('Error unsubscribing: $e');
      return Response(requestOptions: RequestOptions(path: ''));
    }
  }

  Future<Response> resendVerification(String email) async {
    try {
      final response = await dio.post(
        '$_endpoint/verifyEmail',
        data: {
          'email': email,
        },
      );
      return response;
    } catch (e) {
      print('Error resending verification: $e');
      return Response(requestOptions: RequestOptions(path: ''));
    }
  }
}
