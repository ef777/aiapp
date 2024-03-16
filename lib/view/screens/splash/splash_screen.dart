import 'dart:async';
import 'dart:io';

import 'package:ainsighter/data/components.dart';
import 'package:ainsighter/localization/language_constrants.dart';
import 'package:ainsighter/provider/splash_provider.dart';
import 'package:ainsighter/provider/style_provider.dart';
import 'package:ainsighter/view/base/update_dialog.dart';
import 'package:ainsighter/view/screens/home/home_screen.dart';
import 'package:ainsighter/view/screens/onboarding.dart';
import 'package:ainsighter/view/screens/update/update_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart' show PlatformException;

import '../../../utill/app_constants.dart';
import '../../base/custom_button.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    bool loggedBefore =
        Provider.of<SplashProvider>(context, listen: false).isLoggedBefore();
    // bool loggedBefore = false;
    // bool _firstTime = true;
    // _onConnectivityChanged = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   if (!_firstTime) {
    //     bool isNotConnected = result != ConnectivityResult.wifi &&
    //         result != ConnectivityResult.mobile;
    //     print('-----------------${isNotConnected ? 'Not' : 'Yes'}');
    //     isNotConnected
    //         ? SizedBox()
    //         : ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: isNotConnected ? Colors.red : Colors.green,
    //       duration: Duration(seconds: isNotConnected ? 6000 : 3),
    //       content: Text(
    //         isNotConnected
    //             ? getTranslated('no_connection', context)
    //             : getTranslated('connected', context),
    //         textAlign: TextAlign.center,
    //       ),
    //     ));
    //     if (!isNotConnected) {
    //       _route();
    //     }
    //   }
    //   _firstTime = false;
    // });

    Future.microtask(() async {
      CustomerInfo customerInfo;
      try {
        customerInfo = await Purchases.getCustomerInfo();
        if (customerInfo.entitlements.all['premium'] != null) {
          print('yes premium!!!');
          appData.isPro = customerInfo.entitlements.all['premium'].isActive;
        } else {
          print('no premium!!!');
          appData.isPro = false;
        }
      } on PlatformException catch (e) {
        print(e);
      }
    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<SplashProvider>(context, listen: false).setLoggedBefore();

    _route(loggedBefore);
  }

  void _route(bool loggedBefore) {
    Provider.of<StyleProvider>(context, listen: false)
        .getStyleList(context)
        .then((bool isStylesSuccess) {
      if (isStylesSuccess) {
        Provider.of<SplashProvider>(context, listen: false)
            .initConfig(context)
            .then((bool isSuccess) {
          if (isSuccess) {
            Timer(Duration(seconds: 1), () async {
              double _minimumVersion = 0;
              if (Platform.isAndroid) {
                _minimumVersion =
                    Provider.of<SplashProvider>(context, listen: false)
                        .configModel
                        .appMinimumVersionAndroid;
              } else if (Platform.isIOS) {
                _minimumVersion =
                    Provider.of<SplashProvider>(context, listen: false)
                        .configModel
                        .appMinimumVersionIos;
              }
              if (AppConstants.APP_VERSION < _minimumVersion) {
                showUpdateDialog();
              } else if (Provider.of<SplashProvider>(context, listen: false)
                  .configModel
                  .maintenanceMode) {
                showMaintenanceDialog();
              } else {
                if (loggedBefore == true) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                      (route) => false);
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => OnboardingScreen(
                          slide1: Provider.of<SplashProvider>(context,
                                  listen: false)
                              .configModel
                              .slide1,
                          slide2: Provider.of<SplashProvider>(context,
                                  listen: false)
                              .configModel
                              .slide2,
                          slide3: Provider.of<SplashProvider>(context,
                                  listen: false)
                              .configModel
                              .slide3,
                          slide4: Provider.of<SplashProvider>(context,
                                  listen: false)
                              .configModel
                              .slide4,
                          prompt1: Provider.of<SplashProvider>(context,
                                  listen: false)
                              .configModel
                              .prompt1,
                          prompt2: Provider.of<SplashProvider>(context,
                                  listen: false)
                              .configModel
                              .prompt2,
                          prompt3: Provider.of<SplashProvider>(context,
                                  listen: false)
                              .configModel
                              .prompt3,
                        ),
                      ),
                      (route) => false);
                }
              }
            });
          }
        });
      }
    });
  }

  Future showUpdateDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return UpdateDialog();
        });
  }

  Future showMaintenanceDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MaintenanceDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff12151B),
        key: _globalKey,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/image/fullscreen.png',
                fit: BoxFit.cover,
              )
            ],
          ),
        ));
  }
}
