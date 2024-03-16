import 'package:ainsighter/provider/localization_provider.dart';
import 'package:ainsighter/utill/app_constants.dart';
import 'package:ainsighter/view/screens/language/widget/language_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../localization/language_constrants.dart';

class ChooseLanguageScreen extends StatefulWidget {
  final bool fromMenu;
  ChooseLanguageScreen({this.fromMenu = false});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xff12151B),
        // toolbarHeight: 80,
        elevation: 0,
        title: Text(
            'Real AI'
        ),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            renderLeadingButton()
          ],
        ),
      ),
      body: SafeArea(
        child: Consumer<LocalizationProvider>(
            builder: (context, localizationProvider, child) {
          return Column(children: [
            Expanded(
                child: Center(
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: (1 / 1),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10
                              ),
                              itemCount: AppConstants.languages.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => LanguageWidget(
                                languageModel: AppConstants.languages[index],
                                localizationProvider: localizationProvider,
                                index: index,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            )),

            //LanguageSaveButton(localizationController: localizationController, fromMenu: widget.fromMenu),
          ]);
        }),
      ),
    );
  }

  Widget renderLeadingButton() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              colors: [
                Color(0xff898EF8),
                Color(0xff7269DB),
              ]
          )
      ),
      child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xff898EF8),
                    Color(0xff7269DB),
                  ]
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            height: 38,
            width: 38,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                  child: SvgPicture.asset('assets/icons/leading.svg')
              ),
            ),
          )),
    );
  }
}
