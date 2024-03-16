import 'package:ainsighter/data/model/response/base/api_response.dart';
import 'package:ainsighter/provider/splash_provider.dart';
import 'package:ainsighter/view/base/update_dialog.dart';
import 'package:ainsighter/view/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApiChecker {
  static void checkApi(BuildContext context, ApiResponse apiResponse) {
    if (apiResponse.error is! String &&
        apiResponse.error.errors[0].message == 'Giriş yapmalısınız!') {
      Provider.of<SplashProvider>(context, listen: false).removeSharedData();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black87,
          builder: (BuildContext context) {
            return DefaultErrorDialog(
              asset: 'global-refresh',
              message: _errorMessage,
            );
          });
    }
  }
}
