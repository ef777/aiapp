import 'dart:io';

import 'package:ainsighter/view/base/custom_button.dart';
import 'package:ainsighter/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdateScreen extends StatefulWidget {
  final bool isUpdate;
  UpdateScreen({@required this.isUpdate});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              widget.isUpdate
                  ? 'assets/image/abous_us.png'
                  : 'assets/image/abous_us.png',
              width: MediaQuery.of(context).size.height * 0.4,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              widget.isUpdate ? 'update' : 'we_are_under_maintenance',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.023,
                  color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              widget.isUpdate
                  ? 'your_app_is_deprecated'
                  : 'we_will_be_right_back',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.0175,
                  color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(
                height: widget.isUpdate
                    ? MediaQuery.of(context).size.height * 0.04
                    : 0),
            widget.isUpdate
                ? CustomButton(
                    buttonText: 'update_now',
                    onPressed: () async {
                      // if (Platform.isAndroid) {
                      //   StoreRedirect.redirect();
                      // } else {
                      //   String _appUrl = 'https://google.com';
                      //   _appUrl =
                      //       Get.find<SplashController>().configModel.appUrlIos;
                      //   if (await canLaunchUrlString(_appUrl)) {
                      //     launchUrlString(_appUrl);
                      //   } else {
                      //     showCustomSnackBar('${'can_not_launch'.tr} $_appUrl');
                      //   }
                      // }
                    })
                : SizedBox(),
          ]),
        ),
      ),
    );
  }
}
