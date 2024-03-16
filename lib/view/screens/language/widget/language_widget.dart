import 'package:ainsighter/provider/localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/response/language_model.dart';
import '../../../../utill/app_constants.dart';

class LanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final LocalizationProvider localizationProvider;
  final int index;
  LanguageWidget(
      {@required this.languageModel,
      @required this.localizationProvider,
      @required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<LocalizationProvider>(context, listen: false)
            .setLanguage(Locale(
          AppConstants.languages[index].languageCode,
          AppConstants.languages[index].countryCode,
        ));
        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(children: [
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  languageModel.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                languageModel.languageName,
                style: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ]),
          ),
          localizationProvider.locale.countryCode == languageModel.countryCode
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(Icons.check_circle,
                      color: Theme.of(context).primaryColor, size: 20),
                )
              : SizedBox(),
        ]),
      ),
    );
  }
}
