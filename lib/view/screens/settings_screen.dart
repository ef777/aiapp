import 'dart:ui';

import 'package:ainsighter/data/model/response/style_model.dart';
import 'package:ainsighter/localization/language_constrants.dart';
import 'package:ainsighter/provider/images_provider.dart';
import 'package:ainsighter/provider/style_provider.dart';
import 'package:ainsighter/utill/dimensions.dart';
import 'package:ainsighter/view/base/custom_button.dart';
import 'package:ainsighter/view/base/style_item.dart';
import 'package:ainsighter/view/screens/language/language_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/response/image_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _promptController = TextEditingController();
  int selectedStyle;
  int selectedShowcase;

  String encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Color(0xff12151B),
          // toolbarHeight: 80,
          elevation: 0,
          title: Text('Real AI'),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [renderLeadingButton()],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Column(
            children: [
              SettingsItem(
                  text: getTranslated('privacy_policy', context),
                  icon: 'assets/image/security-safe.png',
                  onPressed: () {
                    _launchUrl(Uri.parse(
                        'https://aiart.limited/policies/privacy-policy.html'));
                  }),
              SizedBox(height: 20),
              SettingsItem(
                  text: getTranslated('terms_and_conditions', context),
                  icon: 'assets/image/note.png',
                  onPressed: () {
                    _launchUrl(Uri.parse(
                        'https://aiart.limited/policies/terms-and-conditions.html'));
                  }),
              SizedBox(height: 20),
              SettingsItem(
                  text: getTranslated('end_user_license_agreement', context),
                  icon: 'assets/image/note.png',
                  onPressed: () {
                    _launchUrl(
                        Uri.parse('https://aiart.limited/policies/eula.html'));
                  }),
              SizedBox(height: 20),
              SettingsItem(
                text: getTranslated('contact_us', context),
                icon: 'assets/image/star.png',
                onPressed: () {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'info@aiart.limited',
                    query: encodeQueryParameters(<String, String>{
                      'subject': 'Hello!',
                    }),
                  );

                  _launchUrl(emailLaunchUri);
                },
              ),
              SizedBox(height: 20),
              SettingsItem(
                text: getTranslated('rate_us', context),
                icon: 'assets/image/star.png',
                onPressed: () {
                  StoreRedirect.redirect(
                    androidAppId: 'realai.photo.generator',
                    iOSAppId: '1668920563',
                  );
                },
              ),
              SizedBox(height: 20),
              SettingsItem(
                text: getTranslated('change_language', context),
                icon: 'assets/image/recovery-convert.png',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ChooseLanguageScreen()));
                },
              ),
              // SettingsItem(
              //   text: getTranslated('restore_purchases', context),
              //   icon: FontAwesomeIcons.redo,
              //   onPressed: () {},
              // )
            ],
          ),
        ));
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Widget renderLeadingButton() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: [
            Color(0xff898EF8),
            Color(0xff7269DB),
          ])),
      child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff898EF8),
                Color(0xff7269DB),
              ]),
              borderRadius: BorderRadius.circular(8),
            ),
            height: 38,
            width: 38,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.of(context).pop();
              },
              child:
                  Center(child: SvgPicture.asset('assets/icons/leading.svg')),
            ),
          )),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String text;
  final Function onPressed;
  final String icon;

  SettingsItem(
      {@required this.text, @required this.onPressed, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xff1B2029),
        child: ListTile(
            onTap: onPressed,
            contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            leading: Image.asset(icon),
            horizontalTitleGap: 0,
            title: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            )));
  }
}
