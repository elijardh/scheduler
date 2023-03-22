import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:scheduler/app/config.dart';

class NotificationSender {
  final Dio dio = Dio();

  Future<Map<String, dynamic>> sendNotifications(
      Map<String, dynamic> data) async {
    try {
      log(data.toString());
      final Response response = await dio.post(
          "https://fcm.googleapis.com/fcm/send",
          data: data,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey'
          }));

      log("send notification: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("notification sent succesfuly");
        return response.data;
      } else {
        throw response.data;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
