import 'dart:async';
import 'dart:io';

import 'package:ainsighter/data/model/response/base/api_response.dart';
import 'package:ainsighter/data/model/response/image_model.dart';
import 'package:ainsighter/data/model/response/showcase_model.dart';
import 'package:ainsighter/helper/api_checker.dart';
import 'package:ainsighter/utill/app_constants.dart';
import 'package:ainsighter/view/base/update_dialog.dart';
import 'package:ainsighter/view/screens/result_screen.dart';
import 'package:ainsighter/view/screens/result_square_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../data/model/response/style_model.dart';
import '../data/repository/images_repo.dart';
import '../data/repository/style_repo.dart';
import '../localization/language_constrants.dart';

class ImagesProvider extends ChangeNotifier {
  final ImagesRepo imagesRepo;

  ImagesProvider({@required this.imagesRepo});

  List<ImageModel> _imageList;
  bool _isFetchLoading = false;
  bool _isCreateLoading = false;
  int _remain =
      GetIt.instance<SharedPreferences>().getInt(AppConstants.REMAIN_USAGE);

  List<ImageModel> get imageList => _imageList;
  bool get isFetchLoading => _isFetchLoading;
  int get remain => _remain;
  bool get isCreateLoading => _isCreateLoading;

  List<ShowcaseModel> _showcaseList = [];

  List<ShowcaseModel> get showcaseList => _showcaseList;

  Future<bool> getShowcase(BuildContext context) async {
    ApiResponse apiResponse = await imagesRepo.getShowcaseList();
    bool isSuccess;
    _isFetchLoading = true;
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _showcaseList = [];
      apiResponse.response.data
          .forEach((style) => _showcaseList.add(ShowcaseModel.fromJson(style)));
      isSuccess = true;
      _isFetchLoading = false;
      notifyListeners();
    } else {
      isSuccess = false;
      _isFetchLoading = false;
      showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black87,
          builder: (BuildContext context) {
            return DefaultErrorDialog(
              asset: 'global-refresh',
              message: apiResponse.error,
            );
          });
    }
    return isSuccess;
  }

  Future<String> getSuggestion(BuildContext context) async {
    String suggestion;
    ApiResponse apiResponse = await imagesRepo.getSuggestion();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      print(apiResponse.response.data);
      suggestion = apiResponse.response.data['name'];
    } else {
      throw Exception('Failed to load');
    }
    notifyListeners();
    return suggestion;
  }

  Future<List<ImageModel>> getImageList(BuildContext context, int skip) async {
    List<ImageModel> imageList = [];
    ApiResponse apiResponse = await imagesRepo.getImageList(skip);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      apiResponse.response.data.forEach(
        (style) => imageList.add(ImageModel.fromJson(style)),
      );
    } else {
      throw Exception('Failed to load');
    }
    notifyListeners();
    return imageList;
  }

  void showLoading(BuildContext context) {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        indicator: Center(
            child: Column(
          children: [
            Lottie.asset('assets/animations/animation.json',
                height: MediaQuery.of(context).size.width * .4),
            Text(
              getTranslated('average_time', context),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )));
  }

  void showDownloadLoading(BuildContext context) {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        indicator: Center(
            child: Column(
          children: [
            Lottie.asset('assets/animations/animation.json',
                height: MediaQuery.of(context).size.width * .4),
          ],
        )));
  }

  Future<void> createTask(BuildContext context,
      {String prompt, int style, bool fromResult = false}) async {
    showLoading(context);
    ApiResponse apiResponse =
        await imagesRepo.createTask(prompt: prompt, style: style);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      EasyLoading.dismiss();
      if (fromResult) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => ResultScreen(
            imageUrl: apiResponse.response.data['url'],
            prompt: prompt,
            style: style,
          ),
        ));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ResultScreen(
            imageUrl: apiResponse.response.data['url'],
            prompt: prompt,
            style: style,
          ),
        ));
      }
    } else {
      EasyLoading.dismiss();
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> createSquareTask(
    BuildContext context, {
    String prompt,
    File imageInput,
    File maskImage,
    bool fromResult = false,
    String resolution,
    int faceDepth,
    int creative,
    StreamController stream,
    StreamController faceDepthStream,
  }) async {
    showLoading(context);
    ApiResponse apiResponse = await imagesRepo.createSquareTask(
      prompt: prompt,
      imageInput: imageInput,
      maskImage: maskImage,
      faceDepth: faceDepth,
      creative: creative,
    );
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      await DefaultCacheManager()
          .downloadFile(apiResponse.response.data['url'])
          .then((_) {
        _calculateImageDimension(apiResponse.response.data['url'])
            .then((calculatedResolution) {
          EasyLoading.dismiss();

          if (fromResult) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => ResultSquareScreen(
                imageUrl: apiResponse.response.data['url'],
                prompt: prompt,
                imageInput: imageInput,
                maskedInput: maskImage,
                resolution: calculatedResolution,
                stream: stream,
                faceDepthStream: faceDepthStream,
                faceDepth: faceDepth,
                creative: creative,
              ),
            ));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ResultSquareScreen(
                  imageUrl: apiResponse.response.data['url'],
                  prompt: prompt,
                  imageInput: imageInput,
                  maskedInput: maskImage,
                  resolution: calculatedResolution,
                  stream: stream,
                  faceDepth: faceDepth,
                  faceDepthStream: faceDepthStream),
            ));
          }
        });
      }, onError: (err) {
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      ApiChecker.checkApi(context, apiResponse);
    }
    await imagesRepo.checkRemainUsage();
    _remain =
        GetIt.instance<SharedPreferences>().getInt(AppConstants.REMAIN_USAGE);
    notifyListeners();
  }

  Future<void> createTextToImageTask(BuildContext context,
      {String prompt,
      bool fromResult = false,
      String resolution,
      int width,
      int height,
      StreamController stream}) async {
    showLoading(context);
    ApiResponse apiResponse = await imagesRepo.createTextToImageTask(
      prompt: prompt,
      width: width,
      height: height,
    );
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      await DefaultCacheManager()
          .downloadFile(apiResponse.response.data['url'])
          .then((_) {
        _calculateImageDimension(apiResponse.response.data['url'])
            .then((calculatedResolution) {
          EasyLoading.dismiss();

          if (fromResult) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => ResultSquareScreen(
                imageUrl: apiResponse.response.data['url'],
                prompt: prompt,
                resolution: calculatedResolution,
                stream: stream,
                isTextToImage: true,
                height: height,
                width: width,
              ),
            ));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ResultSquareScreen(
                imageUrl: apiResponse.response.data['url'],
                prompt: prompt,
                resolution: calculatedResolution,
                stream: stream,
                isTextToImage: true,
                height: height,
                width: width,
              ),
            ));
          }
        });
      }, onError: (err) {
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      ApiChecker.checkApi(context, apiResponse);
    }

    await imagesRepo.checkRemainUsage();
    _remain =
        GetIt.instance<SharedPreferences>().getInt(AppConstants.REMAIN_USAGE);
    notifyListeners();
  }

  Future<String> createTrialTask(BuildContext context, {String prompt}) async {
    showLoading(context);
    ApiResponse apiResponse = await imagesRepo.createTrialTask(
      prompt: prompt,
    );
    String imageUrl;
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      imageUrl = apiResponse.response.data['url'];
      await DefaultCacheManager()
          .downloadFile(apiResponse.response.data['url'])
          .then((_) {
        EasyLoading.dismiss();
      }, onError: (err) {
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return imageUrl;
  }

  Future<void> upscaleImage(
    BuildContext context, {
    String image,
    String prompt,
    int style,
    int upscale,
    double faceDepth,
    int faceEnhance,
    StreamController stream,
    StreamController faceDepthStream,
    File imageInput,
    File maskImage,
    bool fromGallery = false,
    bool isTextToImage = false,
    int height,
    int width,
  }) async {
    showLoading(context);
    ApiResponse apiResponse = await imagesRepo.upscaleImage(
        image: image, upscale: upscale, faceEnhance: faceEnhance);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      await DefaultCacheManager()
          .downloadFile(apiResponse.response.data['url'])
          .then(
        (_) {
          _calculateImageDimension(apiResponse.response.data['url']).then(
            (calculatedResolution) {
              EasyLoading.dismiss();
              navigatorResultSquareScreen.pushReplacement(MaterialPageRoute(
                builder: (_) => ResultSquareScreen(
                  oldImageUrl: image,
                  imageUrl: apiResponse.response.data['url'],
                  prompt: prompt,
                  style: style,
                  isUpscaled: true,
                  stream: stream,
                  faceDepthStream: faceDepthStream,
                  imageInput: imageInput,
                  faceDepth: faceDepth != null ? faceDepth.toInt() : null,
                  maskedInput: maskImage,
                  fromGallery: fromGallery,
                  resolution: calculatedResolution,
                  isTextToImage: isTextToImage,
                  height: height,
                  width: width,
                ),
              ));
            },
          );
        },
      );
    } else {
      EasyLoading.dismiss();
      ApiChecker.checkApi(context, apiResponse);
    }
    await imagesRepo.checkRemainUsage();
    _remain =
        GetIt.instance<SharedPreferences>().getInt(AppConstants.REMAIN_USAGE);
    notifyListeners();
  }

  void saveNetworkImage(context, url) async {
    showDownloadLoading(context);
    GallerySaver.saveImage(url, albumName: 'Ai Art').then((bool success) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xff6C5DD3),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              getTranslated('image_successfully_saved', context),
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.white),
            ),
          )));
    }).catchError((err) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            getTranslated('image_download_error', context),
          )));
    });
  }

  Future<String> _calculateImageDimension(url) {
    Completer<String> completer = Completer();
    Image image = Image.network(url);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          String resolution =
              "${myImage.width.toInt()} x ${myImage.height.toInt()}";
          completer.complete(resolution);
        },
      ),
    );
    return completer.future;
  }
}
