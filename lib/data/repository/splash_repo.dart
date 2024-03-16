import 'package:ainsighter/data/datasource/remote/dio/dio_client.dart';
import 'package:ainsighter/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ainsighter/data/model/response/base/api_response.dart';
import 'package:ainsighter/utill/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({@required this.sharedPreferences, @required this.dioClient});

  Future<ApiResponse> getConfig() async {
    try {
      final response = await dioClient.get(AppConstants.CONFIG_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> initSharedData() {
    if (!sharedPreferences.containsKey(AppConstants.THEME)) {
      return sharedPreferences.setBool(AppConstants.THEME, false);
    }
    if (!sharedPreferences.containsKey(AppConstants.COUNTRY_CODE)) {
      return sharedPreferences.setString(AppConstants.COUNTRY_CODE, 'US');
    }
    if (!sharedPreferences.containsKey(AppConstants.LANGUAGE_CODE)) {  
      return sharedPreferences.setString(AppConstants.LANGUAGE_CODE, 'en');
    }
    return Future.value(true);
  }

  Future<bool> setLoggedBefore() {
    return sharedPreferences.setBool('logged', true);
  }

  bool isLoggedBefore() {
    return sharedPreferences.getBool('logged');
  }

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }
}
