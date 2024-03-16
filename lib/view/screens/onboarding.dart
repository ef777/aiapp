import 'dart:io';

import 'package:ainsighter/data/components.dart';
import 'package:ainsighter/localization/language_constrants.dart';
import 'package:ainsighter/provider/images_provider.dart';
import 'package:ainsighter/view/screens/home/home_screen.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({
    this.slide1,
    this.slide2,
    this.slide3,
    this.slide4,
    this.prompt1,
    this.prompt2,
    this.prompt3,
  });

  final String slide1;
  final String slide2;
  final String slide3;
  final String slide4;
  final String prompt1;
  final String prompt2;
  final String prompt3;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Color kDarkBlueColor = Color(0xFF053149);

  bool trialCreated = true;

  String pictureResultUrl;

  TextEditingController _promptController = TextEditingController();

  @override
  void initState() {
    _promptController.text = widget.prompt3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Real AI"),
      //   backgroundColor: Colors.transparent,
      //   toolbarHeight: 60,
      //   elevation: 0,
      // ),
      body: OnBoardingSlider(
        hasSkip: true,
        finishButtonText: trialCreated
            ? getTranslated('start_now', context)
            : getTranslated('generate', context),
        finishButtonTextStyle: TextStyle(
            fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16),
        onFinish: () async {
          if (trialCreated == true) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => HomeScreen()),
                (route) => false);
            // if (appData.isPro) {
            //   Navigator.of(context).pushAndRemoveUntil(
            //       MaterialPageRoute(builder: (_) => HomeScreen()),
            //       (route) => false);
            // } else {
            //   Navigator.of(context).pushAndRemoveUntil(
            //       MaterialPageRoute(
            //           builder: (_) => SubscriptionPage(
            //                 fromOnboarding: true,
            //               )),
            //       (route) => false);
            // }
          } else {
            await Provider.of<ImagesProvider>(context, listen: false)
                .createTrialTask(context, prompt: _promptController.text)
                .then((value) {
              setState(() {
                pictureResultUrl = value;
              });
            });

            setState(() {
              trialCreated = true;
            });
          }
        },
        finishButtonColor: Color(0xff898EF8),
        controllerColor: Color(0xff898EF8),
        totalPage: 3,
        headerBackgroundColor: Color(0xff12151B),
        pageBackgroundColor: Color(0xff12151B),
        background: [
          Container(),
          Container(),
          Container(),
          // Container(),
        ],
        speed: 1.8,
        pageBodies: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .5,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: NetworkImage(
                        widget.slide1,
                      ),
                    ),
                  ),
                ),
                Text(
                  getTranslated('onboarding_description_1', context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ColumnSuper(
                  alignment: Alignment.center,
                  innerDistance: -10,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * .5,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(
                            widget.slide2,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      constraints: BoxConstraints(
                        minHeight: 50,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff1B2029),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: SvgPicture.asset(
                              'assets/icons/magic.svg',
                              height: 26,
                              width: 26,
                              color: Color(0xffD0D1D3),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.prompt1 ?? "",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  height: 1.4,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffD0D1D3),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: Color(0xff7269DB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/image/magicpen.svg',
                                height: 24,
                                width: 24,
                                fit: BoxFit.cover,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Text(
                  getTranslated('onboarding_description_2', context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ColumnSuper(
                  alignment: Alignment.center,
                  innerDistance: -10,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * .5,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(
                            widget.slide3,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      constraints: BoxConstraints(
                        minHeight: 50,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff1B2029),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: SvgPicture.asset(
                              'assets/icons/magic.svg',
                              height: 26,
                              width: 26,
                              color: Color(0xffD0D1D3),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.prompt2 ?? "",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  height: 1.4,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffD0D1D3),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: Color(0xff7269DB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/image/magicpen.svg',
                                height: 24,
                                width: 24,
                                fit: BoxFit.cover,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Text(
                  getTranslated('onboarding_description_3', context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 40),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       ColumnSuper(
          //         alignment: Alignment.center,
          //         innerDistance: -10,
          //         children: [
          //           AnimatedContainer(
          //             duration: Duration(milliseconds: 200),
          //             constraints: BoxConstraints(
          //               maxHeight: MediaQuery.of(context).viewInsets.bottom != 0
          //                   ? MediaQuery.of(context).size.height * .35
          //                   : MediaQuery.of(context).size.height * .5,
          //             ),
          //             decoration: BoxDecoration(
          //               image: DecorationImage(
          //                 fit: BoxFit.contain,
          //                 image: pictureResultUrl != null
          //                     ? NetworkImage(pictureResultUrl)
          //                     : NetworkImage(widget.slide4),
          //               ),
          //             ),
          //           ),
          //           Container(
          //             margin: EdgeInsets.symmetric(horizontal: 2),
          //             constraints: BoxConstraints(
          //               minHeight: 50,
          //             ),
          //             width: double.infinity,
          //             decoration: BoxDecoration(
          //               color: Color(0xff1B2029),
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //             child: Row(
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Padding(
          //                   padding: EdgeInsets.only(left: 16),
          //                   child: SvgPicture.asset(
          //                     'assets/icons/magic.svg',
          //                     height: 26,
          //                     width: 26,
          //                     color: Color(0xffD0D1D3),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: TextFormField(
          //                       controller: _promptController,
          //                       textAlign: TextAlign.center,
          //                       cursorColor: Color(0xff6C5DD3),
          //                       decoration: InputDecoration(
          //                         isDense: true,
          //                         contentPadding: EdgeInsets.symmetric(
          //                           horizontal: 16,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Container(
          //                   height: 44,
          //                   width: 44,
          //                   decoration: BoxDecoration(
          //                     color: Color(0xff7269DB),
          //                     borderRadius: BorderRadius.circular(8),
          //                   ),
          //                   child: Center(
          //                     child: SvgPicture.asset(
          //                       'assets/image/magicpen.svg',
          //                       height: 24,
          //                       width: 24,
          //                       fit: BoxFit.cover,
          //                       color: Colors.white,
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             ),
          //           )
          //         ],
          //       ),
          //       Visibility(
          //         visible: MediaQuery.of(context).viewInsets.bottom == 0,
          //         child: Text(
          //           getTranslated('onboarding_description_4', context),
          //           textAlign: TextAlign.center,
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 16.0,
          //             fontWeight: FontWeight.w400,
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 30,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class SubscriptionPage extends StatefulWidget {
  SubscriptionPage({this.fromOnboarding});

  bool fromOnboarding = false;

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  List<Package> packages = [];

  @override
  void initState() {
    Future.microtask(() async {
      try {
        Offerings offerings = await Purchases.getOfferings();
        if (offerings.current != null) {
          setState(() {
            packages = offerings.current.availablePackages;
          });
        }
      } on PlatformException catch (e) {
        // optional error handling
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.times,
              color: Colors.white,
            ),
            onPressed: () {
              if (widget.fromOnboarding == true) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                    (route) => false);
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    try {
                      final purchaserInfo = await Purchases.restorePurchases();

                      appData.isPro =
                          purchaserInfo.entitlements.all["premium"].isActive;

                      if (purchaserInfo.entitlements.all["premium"].isActive) {
                        if (widget.fromOnboarding == true) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                              (route) => false);
                        } else {
                          Navigator.pop(context, true);
                        }
                      }
                    } on PlatformException catch (e) {
                      print("${e.message} ${e.code} ${e.details}");
                      var errorCode = PurchasesErrorHelper.getErrorCode(e);
                      if (errorCode !=
                          PurchasesErrorCode.purchaseCancelledError) {}
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    child: Text(
                      getTranslated('restore', context),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
          title: Text(
            'Real AI',
          ),
        ),
        body: Stack(
          children: [
            Opacity(
              opacity: 1,
              child: Image.asset(
                'assets/image/ironman.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getTranslated('purchase_title', context),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/tick-square.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    getTranslated(
                                        'purchase_feature_1', context),
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/icons/tick-square.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    getTranslated(
                                        'purchase_feature_2', context),
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/icons/tick-square.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    getTranslated(
                                        'purchase_feature_3', context),
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/icons/tick-square.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    getTranslated(
                                        'purchase_feature_4', context),
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 80),
                  Material(
                    color: Color(0xff1B2029),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: packages.length,
                            padding: EdgeInsets.symmetric(
                                vertical: 40, horizontal: 26),
                            itemBuilder: (BuildContext context, int index) {
                              final packageItem = packages[index];
                              return InkWell(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                onTap: () async {
                                  try {
                                    final purchaserInfo =
                                        await Purchases.purchasePackage(
                                            packageItem);

                                    appData.isPro = purchaserInfo
                                        .entitlements.all["premium"].isActive;

                                    if (purchaserInfo
                                        .entitlements.all["premium"].isActive) {
                                      if (widget.fromOnboarding == true) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        HomeScreen()),
                                                (route) => false);
                                      } else {
                                        Navigator.pop(context, true);
                                      }
                                    }
                                  } on PlatformException catch (e) {
                                    print(
                                        "${e.message} ${e.code} ${e.details}");
                                    var errorCode =
                                        PurchasesErrorHelper.getErrorCode(e);
                                    if (errorCode !=
                                        PurchasesErrorCode
                                            .purchaseCancelledError) {}
                                  }
                                },
                                splashColor: Color(0xff6C5DD3),
                                focusColor: Color(0xff6C5DD3),
                                hoverColor: Color(0xff6C5DD3),
                                highlightColor: Color(0xff6C5DD3),
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      width: 4,
                                      color: Color(0xff6C5DD3),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  packageItem.storeProduct.title
                                                      .toUpperCase()
                                                      .replaceAll(
                                                          "(REAL AI - AI PHOTO MAKER)",
                                                          ""),
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                if (packageItem.packageType ==
                                                    PackageType.annual)
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      border: Border.all(
                                                        width: 1,
                                                        color:
                                                            Color(0xff898EF8),
                                                      ),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 8,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "80% ${getTranslated('discount', context)}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        SvgPicture.asset(
                                                          'assets/icons/like-thumb.svg',
                                                          width: 16,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            packageItem
                                                .storeProduct.priceString,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          if (packageItem.packageType ==
                                              PackageType.annual)
                                            Padding(
                                              padding: EdgeInsets.only(top: 6),
                                              child: Text(
                                                "${getTranslated('weekly', context)} ${(packageItem.storeProduct.price / 52).toStringAsFixed(2)} ${packageItem.storeProduct.currencyCode}",
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 16,
                              );
                            }),
                        SizedBox(height: 20),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  _launchUrl(
                                    Uri.parse(
                                        'https://aiart.limited/policies/terms-and-conditions.html'),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  child: Text(
                                    getTranslated('terms_of_use', context),
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Color(0xff707281),
                                    ),
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                width: 2,
                                color: Color(0xff707281),
                                thickness: 2,
                                indent: 6,
                                endIndent: 6,
                              ),
                              InkWell(
                                onTap: () {
                                  _launchUrl(Uri.parse(
                                      'https://aiart.limited/policies/privacy-policy.html'));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  child: Text(
                                    getTranslated('privacy_policy', context),
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Color(0xff707281),
                                    ),
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                width: 2,
                                color: Color(0xff707281),
                                thickness: 2,
                                indent: 6,
                                endIndent: 6,
                              ),
                              InkWell(
                                onTap: () {
                                  _launchUrl(Uri.parse(
                                    'https://aiart.limited/policies/eula.html',
                                  ));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  child: Text(
                                    getTranslated('eula', context),
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Color(0xff707281),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
