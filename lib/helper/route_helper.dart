import 'package:ainsighter/view/screens/splash/splash_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class RouteHelper {
  static final FluroRouter router = FluroRouter();

  static String splash = '/splash';
  static Handler _splashHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          SplashScreen());

  static void setupRouter() {
    router.define(splash,
        handler: _splashHandler, transitionType: TransitionType.fadeIn);
  }
}
