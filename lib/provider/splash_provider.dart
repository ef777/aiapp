import 'package:ainsighter/data/repository/images_repo.dart';
import 'package:ainsighter/utill/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:ainsighter/data/model/response/base/api_response.dart';
import 'package:ainsighter/data/model/response/config_model.dart';
import 'package:ainsighter/data/repository/splash_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo splashRepo;
  final ImagesRepo imagesRepo;
  SplashProvider({@required this.splashRepo, @required this.imagesRepo});

  ConfigModel _configModel;
  int _pageIndex = 0;
  bool _fromSetting = false;
  bool _firstTimeConnectionCheck = true;

  ConfigModel get configModel => _configModel;
  int get pageIndex => _pageIndex;
  bool get fromSetting => _fromSetting;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  Future<bool> initConfig(BuildContext context) async {
    ApiResponse apiResponse = await splashRepo.getConfig();
    await imagesRepo.checkRemainUsage();
 
  
    bool isSuccess;
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _configModel = ConfigModel.fromJson(apiResponse.response.data);
      isSuccess = true;
      notifyListeners();
    } else {
      isSuccess = false;
      print(apiResponse.error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(apiResponse.error.toString()),
          backgroundColor: Colors.red));
    }
    return isSuccess;
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  Future<bool> setLoggedBefore() {
    return splashRepo.setLoggedBefore();
  }

  bool isLoggedBefore() {
    return splashRepo.isLoggedBefore();
  }

  Future<bool> removeSharedData() {
    return splashRepo.removeSharedData();
  }

  void setFromSetting(bool isSetting) {
    _fromSetting = isSetting;
  }
}
