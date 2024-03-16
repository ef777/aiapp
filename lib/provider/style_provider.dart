import 'package:ainsighter/data/model/response/base/api_response.dart';
import 'package:ainsighter/helper/api_checker.dart';
import 'package:ainsighter/view/base/update_dialog.dart';
import 'package:flutter/material.dart';

import '../data/model/response/style_model.dart';
import '../data/repository/style_repo.dart';

class StyleProvider extends ChangeNotifier {
  final StyleRepo styleRepo;

  StyleProvider({@required this.styleRepo});

  List<StyleModel> _styleList;

  List<StyleModel> get styleList => _styleList;

  Future<bool> getStyleList(BuildContext context, {type = 1}) async {
    ApiResponse apiResponse = await styleRepo.getStyleList(type);
    bool isSuccess;
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _styleList = [];
      apiResponse.response.data
          .forEach((style) => _styleList.add(StyleModel.fromJson(style)));
      isSuccess = true;
      notifyListeners();
    } else {
      isSuccess = false;
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
}
