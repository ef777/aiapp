import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../localization/language_constrants.dart';
import 'custom_button.dart';

class UpdateDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 40),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 24, top: 60, right: 24, bottom: 40),
            margin: EdgeInsets.only(top: 47),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(width: 4, color: Color(0xff898EF8)),
              color: Color(0xff1B2029),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  getTranslated('update_available_title', context),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  getTranslated('update_available_description', context),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                CustomButton(
                  buttonText: getTranslated('update_button', context),
                  padding: 4,
                  onPressed: () {
                    StoreRedirect.redirect(
                      androidAppId: 'realai.photo.generator',
                      iOSAppId: '1668920563',
                    );
                  },
                ),
              ],
            )),
        Positioned(
          left: 15,
          right: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 84,
                width: 84,
                alignment: Alignment.center,
                child: ClipRRect(
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [
                          Color(0xff898EF8),
                          Color(0xff7269DB),
                        ])),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/image/refresh.svg",
                        height: 48,
                        width: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class MaintenanceDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 40),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _contentBox(
          context,
          getTranslated('maintenance_mode', context),
          getTranslated('maintenance_text', context),
          getTranslated('done', context)),
    );
  }
}

class ReportDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 40),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _contentBox(
          context,
          getTranslated('report_dialog_title', context),
          getTranslated('report_dialog_content', context),
          getTranslated('done', context)),
    );
  }
}

_contentBox(context, String title, String content, String done) {
  return Stack(
    children: <Widget>[
      Container(
          padding: EdgeInsets.only(left: 24, top: 60, right: 24, bottom: 40),
          margin: EdgeInsets.only(top: 47),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 4, color: Color(0xff898EF8)),
            color: Color(0xff1B2029),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? "",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                content ?? "",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 28,
              ),
              CustomButton(
                buttonText: done ?? "",
                padding: 4,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )),
      Positioned(
        left: 15,
        right: 15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 84,
              width: 84,
              alignment: Alignment.center,
              child: ClipRRect(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        Color(0xff898EF8),
                        Color(0xff7269DB),
                      ])),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/image/danger.svg",
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ],
  );
}

class DefaultErrorDialog extends StatelessWidget {
  DefaultErrorDialog({this.asset, this.message});

  final String asset;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 60),
      child: contentBox(
        context,
        asset,
        message,
      ),
    );
  }

  contentBox(
    context,
    String asset,
    String message,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/image/$asset.svg",
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          CustomButton(
            buttonText: getTranslated('done', context),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
