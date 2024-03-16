import 'package:ainsighter/data/model/response/language_model.dart';

class AppConstants {
  static const String APP_NAME = 'Real AI';
  static const double APP_VERSION = 3;

  static const String BASE_URL = 'https://realai3.aiart.limited';
  // static const String BASE_URL = 'http://192.168.0.10/realai';

  static const String CONFIG_URI = '/api/v1/config';
  static const String BANNER_URI = '/api/v1/banners';
  static const String IMAGE_URI = '/api/v1/images/';
  static const String SHOWCASE_URI = '/api/v1/get-showcase/';
  static const String SUGGESTION_URI = '/api/v1/get-suggestion/';
  static const String CREATE_TASK_URI = '/api/v1/task/create';
  static const String CREATE_SQUARE_TASK_URI = '/api/v1/task/create-square';
  static const String CREATE_TEXT_TO_IMAGE_TASK_URI =
      '/api/v1/task/text-to-image';
  static const String CREATE_TRIAL_IMAGE_TASK_URI =
      '/api/v1/task/create-trial-task';
  static const String UPSCALE_IMAGE_URI = '/api/v1/task/upscale';
  static const String CHECK_TOTAL = '/api/v1/task/user-check-total';
  static const String IMAGE_BASE_CREATE = '/api/v1/task/image-base-create';
  static const String STYLE_URI = '/api/v1/styles';
  static const String CATEGORY_URI = '/api/v1/categories';

  // Shared Key
  static const String THEME = 'theme';
  static const String TOKEN = 'token';
  static const String COUNTRY_CODE = 'country_code';
  static const String REMAIN_USAGE = 'remain_usage';
  static const String LANGUAGE_CODE = 'language_code';
  static const String SUBSCRIBE = 'subscribe';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: 'assets/image/english.png',
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: 'assets/image/french.png',
        languageName: 'French',
        countryCode: 'FR',
        languageCode: 'fr'),
    LanguageModel(
        imageUrl: 'assets/image/spanish.png',
        languageName: 'Spanish',
        countryCode: 'ES',
        languageCode: 'es'),
    LanguageModel(
        imageUrl: 'assets/image/italian.png',
        languageName: 'Italian',
        countryCode: 'IT',
        languageCode: 'it'),
    LanguageModel(
        imageUrl: 'assets/image/turkish.png',
        languageName: 'Turkish',
        countryCode: 'TR',
        languageCode: 'tr'),
    LanguageModel(
        imageUrl: 'assets/image/arabian.png',
        languageName: 'اَلْعَرَبِيَّةُ‎',
        countryCode: 'SA',
        languageCode: 'ar'),
    LanguageModel(
        imageUrl: 'assets/image/germany.png',
        languageName: 'Germany',
        countryCode: 'DE',
        languageCode: 'de'), 
    LanguageModel(
        imageUrl: 'assets/image/portugal.png',
        languageName: 'Portugal',
        countryCode: 'PT',
        languageCode: 'pt'),
    LanguageModel(
        imageUrl: 'assets/image/brazil.png',
        languageName: 'Brazil',
        countryCode: 'BR',
        languageCode: 'br'),
    LanguageModel(
        imageUrl: 'assets/image/russia.png',
        languageName: 'Russia',
        countryCode: 'RU',
        languageCode: 'ru'),
    LanguageModel(
        imageUrl: 'assets/image/japan.png',
        languageName: 'Japan',
        countryCode: 'JP',
        languageCode: 'ja'),
        
  ];
}
