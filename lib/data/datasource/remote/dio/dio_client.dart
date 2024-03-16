import 'dart:io';

import 'package:ainsighter/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:ainsighter/utill/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  Dio dio = Dio();
  String token = '';

  DioClient(
    this.baseUrl,
    Dio dioC, {
    this.loggingInterceptor,
    this.sharedPreferences,
  }) {
    token = sharedPreferences.getString(AppConstants.TOKEN);
    print(token);
    dio = dioC ?? Dio();
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = 30000
      ..options.receiveTimeout = 30000
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization':
        //     'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiNzRhZjkyZjllOWYxYzBmYjg1NmM4OWViNDJmZGIwMDZhOWRkMWIyYzQyNjE3MWE5ZGQwMmY4NWVmN2E4OGEzZWI5Y2Y4OGNlZmU5YmNlZDUiLCJpYXQiOjE2MzMxMDM0ODcuNTY5MTg0MDY0ODY1MTEyMzA0Njg3NSwibmJmIjoxNjMzMTAzNDg3LjU2OTE4OTA3MTY1NTI3MzQzNzUsImV4cCI6MTY2NDYzOTQ4Ny41NjMyNjg4OTk5MTc2MDI1MzkwNjI1LCJzdWIiOiIxNSIsInNjb3BlcyI6W119.cM4nvE1F0wQFqfjJwq-xQokNVug9HvKiwHz8y_LnrfsRcR1Y0QsLvHX60EwmHWed1z22jgEV3QvEAZr1m-ge5kf5ZikGC-Kt6lQem1oWdP-7rldo9hn5IBbFAq2xAFu84PO8oHMdJz-KKkSCoFUMDVYiI-uKd2ZWMuAVt3oGHragRBU8Be39PYG3IxtM1BWsoUd0o4BEYFW7l0gLlfvi-7xwQTcgoYaC9lA71DEmpBMqFuRpPeXC1xqh-bU3IRAvQkxzExORHlidlv1_xtzBvwnf-pO-5irc9NDBHACmbdqrH_c86WknDUFtiJaqN_-hvIGTu8_9CfuOGFtFcABsOPRnTrTSYCg19Zt1K9-0-QBUlIFpZIlEk7G-92Mzt8FJCd7v1fV9xXM4WQMhOk4kgPXY0t6pLekOA9x105c3imlwEEXPrJMEo5NHc5KJ_QFVFjUiOJD-igfdRy3T8bdeLMnh1ms5d9KGfwTkaviFsjurLNlbCQmyts4hj_HY-33J819JtARfEhX3LcvbEJf2y3KzvInnhzuiAPvnSWSWqgY3JsXx7iyHXaxaCOboKePigUVSjnlJbg3FaPq-ogo6ea4BDMhSv7alStb_KLbhZzqAwVls328InkLr3z6xdiXN8mfkKFQBZDRLhC_oUaXX93pZ3vMLom1W5QQcgD3o038'
        'Authorization': 'Bearer $token'
      };
    dio.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    String diotoken = sp.getString(AppConstants.TOKEN);

    try {
      dio = dio
        ..options.headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $diotoken'
        };
      var response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<Response> post(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();

      String diotoken = sp.getString(AppConstants.TOKEN);

      dio = dio
        ..options.headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $diotoken'
        };

      var response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    String diotoken = sp.getString(AppConstants.TOKEN);

    dio = dio
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $diotoken'
      };

    try {
      var response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
  }) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    String diotoken = sp.getString(AppConstants.TOKEN);

    dio = dio
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $diotoken'
      };

    try {
      var response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }
}
