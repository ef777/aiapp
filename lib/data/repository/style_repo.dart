import 'package:flutter/material.dart';
import 'package:ainsighter/data/datasource/remote/dio/dio_client.dart';
import 'package:ainsighter/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ainsighter/data/model/response/base/api_response.dart';
import 'package:ainsighter/utill/app_constants.dart';

class StyleRepo {
  final DioClient dioClient;
  StyleRepo({@required this.dioClient});

  Future<ApiResponse> getStyleList(int type) async {
    try {
      final response = await dioClient.post(AppConstants.STYLE_URI, data: {
        "type": type,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
