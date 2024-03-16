import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ainsighter/data/datasource/remote/dio/dio_client.dart';
import 'package:ainsighter/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ainsighter/data/model/response/base/api_response.dart';
import 'package:ainsighter/utill/app_constants.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImagesRepo {
  final DioClient dioClient;
  ImagesRepo({@required this.dioClient}); 
  Future<ApiResponse> getImageList(int skip) async {
    try {
      String deviceId = await PlatformDeviceId.getDeviceId;
      final response =
          await dioClient.get('${AppConstants.IMAGE_URI}$deviceId/$skip');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getShowcaseList() async {
    try {
      final response = await dioClient.get(AppConstants.SHOWCASE_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSuggestion() async {
    try {
      final response = await dioClient.get(AppConstants.SUGGESTION_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> createTask({String prompt, int style}) async {
    try {
      final response = await dioClient.post(
        AppConstants.CREATE_TASK_URI,
        data: {'prompt': prompt, 'style': style},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> createSquareTask({
    String prompt,
    File imageInput,
    File maskImage,
    int faceDepth,
    int creative,
  }) async {
    try {
      String deviceId = await PlatformDeviceId.getDeviceId;
      FormData formData = FormData.fromMap({
        "init_image": await MultipartFile.fromFile(imageInput.path),
        "mask_image": await MultipartFile.fromFile(maskImage.path),
        "prompt": prompt,
        "face_depth": faceDepth,
        "creative": creative,
        "device_id": deviceId,
      });
      final response = await dioClient.post(AppConstants.CREATE_SQUARE_TASK_URI,
          data: formData);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> createTextToImageTask({
    String prompt,
    int width,
    int height,
  }) async {
    try {
      String deviceId = await PlatformDeviceId.getDeviceId;
      final response = await dioClient
          .post(AppConstants.CREATE_TEXT_TO_IMAGE_TASK_URI, data: {
        "prompt": prompt,
        "width": width,
        "height": height,
        "device_id": deviceId,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> checkRemainUsage() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    try {
      String deviceId = await PlatformDeviceId.getDeviceId;
      final response = await dioClient.post(AppConstants.CHECK_TOTAL, data: {
        "device_id": deviceId,
      });
      if (response.statusCode == 200) {
        sharedPreferences.setInt(
            AppConstants.REMAIN_USAGE, response.data["remain"]);
        if (response.data["remain"] > 0) {
          return true;
        }
      }
      return false;
    } catch (e) {
      sharedPreferences.setInt(AppConstants.REMAIN_USAGE, 0);
      return false;
    }
  }

  Future<ApiResponse> createTrialTask({
    String prompt,
  }) async {
    try {
      String deviceId = await PlatformDeviceId.getDeviceId;
      final response =
          await dioClient.post(AppConstants.CREATE_TRIAL_IMAGE_TASK_URI, data: {
        "prompt": prompt,
        "device_id": deviceId,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> upscaleImage(
      {String image, int upscale, int faceEnhance}) async {
    try {
      print({
        'image': image,
        'upscale': upscale,
        'face_enhance': faceEnhance / 100
      });
      final response = await dioClient.post(
        AppConstants.UPSCALE_IMAGE_URI,
        data: {
          'image': image,
          'upscale': upscale,
          'face_enhance': faceEnhance / 100
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
