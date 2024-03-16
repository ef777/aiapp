import 'dart:async';
import 'dart:ui';

import 'package:ainsighter/helper/route_helper.dart';
import 'package:ainsighter/provider/localization_provider.dart';
import 'package:ainsighter/provider/splash_provider.dart';
import 'package:ainsighter/provider/images_provider.dart';
import 'package:ainsighter/provider/style_provider.dart';
import 'package:ainsighter/provider/theme_provider.dart';
import 'package:ainsighter/theme/dark_theme.dart';
import 'package:ainsighter/theme/light_theme.dart';
import 'package:ainsighter/utill/app_constants.dart';
import 'package:ainsighter/view/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io' show Platform;

import 'data/components.dart';
import 'di_container.dart' as di;
import 'localization/app_localization.dart';

// import 'helper/notification_helper.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = (Platform.isAndroid || Platform.isIOS) ? FlutterLocalNotificationsPlugin() : null;

Future<void> initPlatformState() async {
  // await Purchases.setDebugLogsEnabled(true);

  appData.isPro = false;

  String deviceId = await PlatformDeviceId.getDeviceId;

  PurchasesConfiguration configuration;
  if (Platform.isAndroid) {
    configuration = PurchasesConfiguration("goog_uSiozbxxCHdjYmZBNtAcsxkcNWL");
  } else if (Platform.isIOS) {
    configuration = PurchasesConfiguration("appl_DbiBnOSvhqItdoeRFAIPgurztHP");
  }
  await Purchases.configure(configuration..appUserID = deviceId);
}

Future<void> main() async {
  // setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();

  FirebasePerformance performance = FirebasePerformance.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  // FirebaseCrashlytics.instance.crash();

  await initPlatformState();

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..radius = 10.0
    ..maskColor = Colors.black54
    ..backgroundColor = Colors.transparent
    ..boxShadow = <BoxShadow>[]
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorColor = Colors.transparent
    ..progressColor = Colors.transparent
    ..textColor = Colors.white
    ..userInteractions = false
    ..dismissOnTap = false;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ImagesProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<StyleProvider>()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    RouteHelper.setupRouter();
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> _locals = [];
    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode, language.countryCode));
    });
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        return (kIsWeb && splashProvider.configModel == null)
            ? SizedBox()
            : MaterialApp(
                title: AppConstants.APP_NAME,
                // initialRoute: RouteHelper.splash,
                onGenerateRoute: RouteHelper.router.generator,
                debugShowCheckedModeBanner: false,
                navigatorKey: MyApp.navigatorKey,
                theme: dark,
                locale: Provider.of<LocalizationProvider>(context).locale,
                localizationsDelegates: [
                  AppLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                builder: EasyLoading.init(),
                supportedLocales: _locals,
                home: SplashScreen());
      },
    );
  }
}
