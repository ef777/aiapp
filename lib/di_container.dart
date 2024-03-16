import 'package:ainsighter/data/repository/images_repo.dart';
import 'package:ainsighter/data/repository/splash_repo.dart';
import 'package:ainsighter/data/repository/style_repo.dart';
import 'package:ainsighter/provider/images_provider.dart';
import 'package:ainsighter/provider/localization_provider.dart';
import 'package:ainsighter/provider/splash_provider.dart';
import 'package:ainsighter/provider/style_provider.dart';
import 'package:ainsighter/provider/theme_provider.dart';
import 'package:ainsighter/utill/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.BASE_URL, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(
      () => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => ImagesRepo(dioClient: sl()));
  sl.registerLazySingleton(() => StyleRepo(dioClient: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl(),imagesRepo: sl()));

  sl.registerFactory(() => ImagesProvider(imagesRepo: sl()));
  sl.registerFactory(() => StyleProvider(styleRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
