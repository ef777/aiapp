import 'package:ainsighter/view/base/update_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:ainsighter/localization/language_constrants.dart';
import 'package:ainsighter/provider/splash_provider.dart';
import 'package:provider/provider.dart';

class NetworkInfo {
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);

  Future<bool> get isConnected async {
    ConnectivityResult _result = await connectivity.checkConnectivity();
    return _result != ConnectivityResult.none;
  }

  static void checkConnectivity(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (Provider.of<SplashProvider>(context, listen: false)
          .firstTimeConnectionCheck) {
        Provider.of<SplashProvider>(context, listen: false)
            .setFirstTimeConnectionCheck(false);
      } else {
        bool isNotConnected = result == ConnectivityResult.none;
        isNotConnected
            ? SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black87,
            builder: (BuildContext context) {
              return DefaultErrorDialog(
                asset: 'global-refresh',
                message:
                    "Connection to API server failed due to internet connection",
              );
            });
      }
    });
  }
}
