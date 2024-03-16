import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:ainsighter/data/components.dart';
import 'package:ainsighter/data/model/response/image_model.dart';
import 'package:ainsighter/provider/images_provider.dart';
import 'package:ainsighter/utill/app_constants.dart';
import 'package:ainsighter/view/base/custom_button.dart';
import 'package:ainsighter/view/base/lazy_image.dart';
import 'package:ainsighter/view/screens/home/home_screen.dart';
import 'package:ainsighter/view/screens/onboarding.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../localization/language_constrants.dart';

class ResultSquareLikedScreen extends StatefulWidget {
  final String imageUrl;
  final String prompt;
  final int style;
  final double strengthValue;
  final File imageInput;
  final File maskedInput;
  final bool isUpscaled;
  final resolution;
  final bool fromGallery;
  final StreamController stream;
  final String oldImageUrl;
  final List galleryItems;
  final int initialGalleryIndex;
  final int faceDepth;
  final int creative;

  ResultSquareLikedScreen({
    this.imageUrl,
    this.prompt,
    this.style,
    this.strengthValue,
    this.imageInput,
    this.maskedInput,
    this.isUpscaled = false,
    this.resolution,
    this.fromGallery = false,
    this.stream,
    this.oldImageUrl,
    this.galleryItems = const [],
    this.initialGalleryIndex,
    this.faceDepth,
    this.creative,
  });

  @override
  _ResultSquareLikedScreenState createState() =>
      _ResultSquareLikedScreenState();
}

class _ResultSquareLikedScreenState extends State<ResultSquareLikedScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController _promptController = TextEditingController();
  double _currentStrengthValue = 0;
  double upscaleNo = 1;
  double faceEnhance = 50;
  double faceDepth = 50;
  double creative = 100;
  bool liked = false;
  int galleryIndex = 0;
  bool _isUserPremium = false;

  bool upscaleActive = false;
  bool faceEnhanceActive = false;

  List<String> favouriteList = [];

  final GlobalKey<LikeButtonState> tmpKey =
      GlobalKey<LikeButtonState>(debugLabel: 'likeButton');

  @override
  void initState() {
    if (widget.initialGalleryIndex != null) {
      galleryIndex = widget.initialGalleryIndex;
    }

    if (widget.prompt != null) {
      _promptController.text = widget.prompt;
    }
    if (widget.strengthValue != null) {
      _currentStrengthValue = widget.strengthValue;
    }

    if (widget.faceDepth != null) {
      faceDepth = widget.faceDepth.toDouble();
    }

    if (widget.faceDepth != null) {
      creative = widget.creative.toDouble();
    }

    _promptController.addListener(() {
      if (widget.stream != null) {
        widget.stream.add(_promptController.text);
      }
    });

    Future.microtask(() async {
      final SharedPreferences prefs = await _prefs;
      List<String> favList = prefs.getStringList('favList') ?? [];

      _isUserPremium = appData.isPro;
      setState(() {
        favouriteList = favList;
        liked = favouriteList.contains(widget.imageUrl);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                if (widget.galleryItems.isNotEmpty)
                  Column(
                    children: [
                      CarouselSlider(
                        items: widget.galleryItems.map((e) {
                          return GestureDetector(
                            onDoubleTap: tmpKey?.currentState?.onTap ?? null,
                            child: LazyImage(
                              url: e,
                              fit: BoxFit.contain,
                              height: MediaQuery.of(context).size.width,
                              width: MediaQuery.of(context).size.width,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                            height: MediaQuery.of(context).size.width,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: widget.initialGalleryIndex,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: false,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index, reason) {
                              setState(() {
                                liked = favouriteList.contains(
                                  widget.galleryItems[index],
                                );
                                galleryIndex = index;
                              });
                              print(galleryIndex);
                            }),
                      ),
                      // SizedBox(
                      //   height: 12,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children:
                      //         widget.galleryItems.asMap().entries.map((entry) {
                      //       return GestureDetector(
                      //         child: Container(
                      //           width: 10.0,
                      //           height: 10.0,
                      //           margin: EdgeInsets.symmetric(
                      //               vertical: 8.0, horizontal: 3.0),
                      //           decoration: BoxDecoration(
                      //               shape: BoxShape.circle,
                      //               color: (Theme.of(context).brightness ==
                      //                           Brightness.dark
                      //                       ? Colors.white
                      //                       : Colors.black)
                      //                   .withOpacity(galleryIndex == entry.key
                      //                       ? 0.9
                      //                       : 0.4)),
                      //         ),
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),
                    ],
                  )
                else
                  GestureDetector(
                    onDoubleTap: tmpKey?.currentState?.onTap ?? null,
                    child: LazyImage(
                      url: widget.imageUrl,
                      fit: BoxFit.contain,
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                Positioned(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 10),
                        child: renderLeadingButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 10),
                        child: renderFavouriteButton(),
                      ),
                    ],
                  ),
                ),
                // if (!widget.fromGallery)
                // Positioned(
                //   child: Column(
                //     children: [
                //       Row(
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.symmetric(
                //                 vertical: 20, horizontal: 10),
                //             child: renderSizeWidget(),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                //   bottom: 0,
                //   right: 0,
                // ),
              ],
            ),
            if (!widget.fromGallery)
              ColumnSuper(
                alignment: Alignment.center,
                innerDistance: -24,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    decoration: BoxDecoration(
                      color: Color(0xff6C5DD3),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Expanded(
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           InkWell(
                        //             onTap: () {
                        //               setState(() {
                        //                 upscaleActive = !upscaleActive;
                        //               });
                        //             },
                        //             child: Row(
                        //               children: [
                        //                 Checkbox(
                        //                     value: upscaleActive,
                        //                     checkColor: Colors.white,
                        //                     activeColor: Color(0xff898EF8),
                        //                     onChanged: (val) {
                        //                       setState(() {
                        //                         upscaleActive = val;
                        //                       });
                        //                     }),
                        //                 Text(
                        //                   'Upscale',
                        //                   style: TextStyle(fontSize: 13),
                        //                 )
                        //               ],
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           InkWell(
                        //             onTap: () {
                        //               setState(() {
                        //                 faceEnhanceActive = !faceEnhanceActive;
                        //               });
                        //             },
                        //             child: Row(
                        //               children: [
                        //                 Checkbox(
                        //                   value: faceEnhanceActive,
                        //                   checkColor: Colors.white,
                        //                   activeColor: Color(0xff898EF8),
                        //                   onChanged: (val) {
                        //                     setState(() {
                        //                       faceEnhanceActive = val;
                        //                     });
                        //                   },
                        //                   materialTapTargetSize:
                        //                       MaterialTapTargetSize.shrinkWrap,
                        //                 ),
                        //                 Text(
                        //                   'Face Enhance',
                        //                   style: TextStyle(fontSize: 13),
                        //                 )
                        //               ],
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 22),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text('Face Depth'),
                                      ),
                                      Text('${faceDepth.toInt()}%'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      activeTickMarkColor: Colors.transparent,
                                      disabledInactiveTickMarkColor:
                                          Colors.transparent,
                                      disabledActiveTickMarkColor:
                                          Colors.transparent,
                                      inactiveTickMarkColor: Colors.transparent,
                                      thumbColor: Color(0xff898EF8),
                                      trackHeight: 17,
                                      activeTrackColor: Color(0xffD9D9D9),
                                      inactiveTrackColor: Color(0xffD9D9D9),
                                      trackShape: RoundedRectSliderTrackShape(),
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 12),
                                    ),
                                    child: Slider(
                                      min: 1,
                                      max: 100,
                                      divisions: 99,
                                      value: faceDepth,
                                      onChanged: (val) {
                                        setState(() {
                                          faceDepth = val;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            )),
                            Expanded(
                                child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 22),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text('Creativity'),
                                      ),
                                      Text('${creative.toInt()}%'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      activeTickMarkColor: Colors.transparent,
                                      disabledInactiveTickMarkColor:
                                          Colors.transparent,
                                      disabledActiveTickMarkColor:
                                          Colors.transparent,
                                      inactiveTickMarkColor: Colors.transparent,
                                      thumbColor: Color(0xff898EF8),
                                      trackHeight: 17,
                                      activeTrackColor: Color(0xffD9D9D9),
                                      inactiveTrackColor: Color(0xffD9D9D9),
                                      trackShape: RoundedRectSliderTrackShape(),
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 12),
                                    ),
                                    child: Slider(
                                      min: 1,
                                      max: 100,
                                      divisions: 99,
                                      value: creative,
                                      onChanged: (val) {
                                        setState(() {
                                          creative = val;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .6,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Provider.of<ImagesProvider>(context, listen: false)
                              .createSquareTask(
                            context,
                            prompt: _promptController.text,
                            imageInput: widget.imageInput,
                            maskImage: widget.maskedInput,
                            resolution: widget.resolution,
                            fromResult: true,
                            faceDepth: faceDepth.toInt(),
                            creative: creative.toInt(),
                            stream: widget.stream,
                          );
                        },
                        child: Center(
                          child: Text(
                            'Generate',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Color(0xff6C5DD3),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 16),
            if (!widget.fromGallery) renderSearchWidget(),
            SizedBox(
              height: 30,
            ),
            renderBottomWidget(context),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }

  Widget renderSearchWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 24, 40, 0),
      child: TextField(
          maxLines: 8,
          minLines: 1,
          enableSuggestions: false,
          autocorrect: false,
          onChanged: (val) {
            setState(() {});
          },
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.done,
          controller: _promptController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xff1B2029),
            counterText: "",
            hintText: getTranslated('type_anything', context),
          )),
    );
  }

  Widget renderBottomWidget(BuildContext ct) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Material(
                    color: Colors.transparent,
                    child: Ink(
                      width: 86,
                      decoration: BoxDecoration(
                        color: Color(0xff1B2029),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: InkWell(
                        splashColor: Color(0xff1B2029),
                        focusColor: Color(0xff1B2029),
                        borderRadius: BorderRadius.circular(6),
                        onTap: () {
                          showModalBottomSheet(
                              useRootNavigator: false,
                              context: context,
                              backgroundColor: Color(0xff12151B),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10))),
                              builder: (contextt) {
                                return StatefulBuilder(builder:
                                    (BuildContext _, StateSetter setState) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .075,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .075,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Container(),
                                                    flex: 2,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      'AI Tools',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    flex: 4,
                                                  ),
                                                  Flexible(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  gradient:
                                                                      LinearGradient(
                                                                          colors: [
                                                                        Color(
                                                                            0xff898EF8),
                                                                        Color(
                                                                            0xff7269DB),
                                                                      ])),
                                                          child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: Ink(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                                          colors: [
                                                                        Color(
                                                                            0xff898EF8),
                                                                        Color(
                                                                            0xff7269DB),
                                                                      ]),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                height: 38,
                                                                width: 38,
                                                                child: InkWell(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Center(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              'assets/icons/leading.svg')),
                                                                ),
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                                    flex: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .15,
                                              ),
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 22),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                getTranslated(
                                                                    'upscale',
                                                                    context),
                                                              ),
                                                            ),
                                                            Text(
                                                                '${upscaleNo.toInt()}x'),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 20),
                                                        child: SliderTheme(
                                                          data: SliderThemeData(
                                                            activeTickMarkColor:
                                                                Colors
                                                                    .transparent,
                                                            disabledInactiveTickMarkColor:
                                                                Colors
                                                                    .transparent,
                                                            disabledActiveTickMarkColor:
                                                                Colors
                                                                    .transparent,
                                                            inactiveTickMarkColor:
                                                                Colors
                                                                    .transparent,
                                                            thumbColor: Color(
                                                                0xff898EF8),
                                                            trackHeight: 20,
                                                            activeTrackColor:
                                                                Color(
                                                                    0xffD9D9D9),
                                                            inactiveTrackColor:
                                                                Color(
                                                                    0xffD9D9D9),
                                                            trackShape:
                                                                RoundedRectSliderTrackShape(),
                                                            thumbShape:
                                                                RoundSliderThumbShape(
                                                              enabledThumbRadius:
                                                                  18,
                                                            ),
                                                          ),
                                                          child: Slider(
                                                            min: 1,
                                                            max: 4,
                                                            divisions: 3,
                                                            value: upscaleNo,
                                                            onChanged: (val) {
                                                              setState(() {
                                                                upscaleNo = val;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Stack(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 22),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                getTranslated(
                                                                    'face_enhance',
                                                                    context),
                                                              ),
                                                            ),
                                                            Text(
                                                                '${faceEnhance.toInt()}%'),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 20),
                                                        child: SliderTheme(
                                                          data: SliderThemeData(
                                                            activeTickMarkColor:
                                                                Colors
                                                                    .transparent,
                                                            disabledInactiveTickMarkColor:
                                                                Colors
                                                                    .transparent,
                                                            disabledActiveTickMarkColor:
                                                                Colors
                                                                    .transparent,
                                                            inactiveTickMarkColor:
                                                                Colors
                                                                    .transparent,
                                                            thumbColor: Color(
                                                                0xff898EF8),
                                                            trackHeight: 20,
                                                            activeTrackColor:
                                                                Color(
                                                                    0xffD9D9D9),
                                                            inactiveTrackColor:
                                                                Color(
                                                                    0xffD9D9D9),
                                                            trackShape:
                                                                RoundedRectSliderTrackShape(),
                                                            thumbShape:
                                                                RoundSliderThumbShape(
                                                                    enabledThumbRadius:
                                                                        18),
                                                          ),
                                                          child: Slider(
                                                            min: 1,
                                                            max: 100,
                                                            divisions: 99,
                                                            value: faceEnhance,
                                                            onChanged: (val) {
                                                              setState(() {
                                                                faceEnhance =
                                                                    val;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .05,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .125,
                                              ),
                                              child: Consumer<ImagesProvider>(
                                                builder: (context,
                                                        imagesProvider,
                                                        child) =>
                                                    CustomButton(
                                                  isActive: true,
                                                  buttonText: getTranslated(
                                                          'generate', context) +
                                                      "${_isUserPremium == false ? ' - (${imagesProvider.remain < 0 ? "0" : imagesProvider.remain})' : ''}",
                                                  onPressed: () async {
                                                    CustomerInfo customerInfo =
                                                        await Purchases
                                                            .getCustomerInfo();
                                                    int remainUsage =
                                                        GetIt.instance<
                                                                SharedPreferences>()
                                                            .getInt(AppConstants
                                                                .REMAIN_USAGE);
                                                    if (customerInfo
                                                            .entitlements
                                                            .active
                                                            .isNotEmpty ||
                                                        remainUsage > 0) {
                                                      Provider.of<ImagesProvider>(
                                                              context,
                                                              listen: false)
                                                          .upscaleImage(
                                                        contextt,
                                                        image: widget.isUpscaled
                                                            ? widget.oldImageUrl
                                                            : widget.fromGallery
                                                                ? widget.galleryItems[
                                                                    galleryIndex]
                                                                : widget
                                                                    .imageUrl,
                                                        prompt:
                                                            _promptController
                                                                .text,
                                                        upscale:
                                                            upscaleNo.toInt(),
                                                        faceEnhance:
                                                            faceEnhance.toInt(),
                                                        stream: widget.stream,
                                                        imageInput:
                                                            widget.imageInput,
                                                        maskImage:
                                                            widget.maskedInput,
                                                        fromGallery:
                                                            widget.fromGallery,
                                                      );
                                                    } else {
                                                      setState(() {
                                                        _isUserPremium = false;
                                                      });
                                                      final result =
                                                          await Navigator.of(
                                                                  context)
                                                              .push(
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                SubscriptionPage()),
                                                      );

                                                      if (result != null) {
                                                        setState(() {
                                                          _isUserPremium =
                                                              result;
                                                        });
                                                      }
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                });
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/icons/generate.png',
                                height: 28,
                              ),
                              SizedBox(height: 8),
                              Text('AI Tools',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: GoogleFonts.roboto(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
          SizedBox(
            width: 18,
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Material(
                    color: Colors.transparent,
                    child: Ink(
                      width: 86,
                      decoration: BoxDecoration(
                        color: Color(0xff1B2029),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: InkWell(
                        splashColor: Color(0xff1B2029),
                        focusColor: Color(0xff1B2029),
                        borderRadius: BorderRadius.circular(6),
                        onTap: () {
                          FlutterShare.share(
                              title:
                                  getTranslated('share_content_title', context),
                              text:
                                  getTranslated('share_content_text', context),
                              linkUrl: widget.imageUrl);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/icons/share.png',
                                height: 28,
                              ),
                              SizedBox(height: 8),
                              Text(getTranslated('share', context),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: GoogleFonts.roboto(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
          // Opacity(
          //   opacity: !widget.isUpscaled ? 1 : 0.5,
          //   child: Column(
          //     children: [
          //       Neumorphic(
          //         style: NeumorphicStyle(
          //           disableDepth: false,
          //           color: Theme.of(context).primaryColor,
          //           shadowLightColorEmboss: Color(0xff1035BB),
          //           shadowDarkColorEmboss: Color(0xff8199F2),
          //           boxShape:
          //               NeumorphicBoxShape.roundRect(BorderRadius.circular(6)),
          //           depth: -1,
          //           shape: NeumorphicShape.concave,
          //           lightSource: LightSource.topRight,
          //           intensity: 1,
          //         ),
          //         child: Container(
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(6),
          //             boxShadow: <BoxShadow>[
          //               BoxShadow(
          //                 color: Color(0xff8199F2).withOpacity(.15),
          //                 offset: Offset(-1, 2),
          //                 blurRadius: 10,
          //                 blurStyle: BlurStyle.inner,
          //               ),
          //               BoxShadow(
          //                 color: Color(0xff1035BB).withOpacity(.15),
          //                 offset: Offset(-1, 2),
          //                 blurRadius: 10,
          //                 blurStyle: BlurStyle.inner,
          //               ),
          //             ],
          //           ),
          //           child: Material(
          //               color: Colors.transparent,
          //               child: Ink(
          //                 decoration: BoxDecoration(
          //                   color: Theme.of(context).primaryColor,
          //                   borderRadius: BorderRadius.circular(6),
          //                 ),
          //                 height: 52,
          //                 width: 52,
          //                 child: InkWell(
          //                   splashColor: Theme.of(context).primaryColor,
          //                   focusColor: Theme.of(context).primaryColor,
          //                   borderRadius: BorderRadius.circular(6),
          //                   onTap: () {
          //                     if (!widget.isUpscaled)
          //                       Provider.of<ImagesProvider>(context,
          //                               listen: false)
          //                           .upscaleImage(
          //                         context,
          //                         image: widget.imageUrl,
          //                         prompt: _promptController.text,
          //                         style: widget.style,
          //                       );
          //                   },
          //                   child: Center(
          //                       child: SvgPicture.asset(
          //                     'assets/icons/expand.svg',
          //                     height: 28,
          //                   )),
          //                 ),
          //               )),
          //         ),
          //       ),
          //       SizedBox(height: 6),
          //       Text(getTranslated('upscale', context),
          //           textAlign: TextAlign.center,
          //           maxLines: 1,
          //           style: GoogleFonts.roboto(
          //             fontSize: 13,
          //             color: Theme.of(context).primaryColor,
          //             fontWeight: FontWeight.w500,
          //           ))
          //     ],
          //   ),
          // ),
          // Column(
          //   children: [
          //     Neumorphic(
          //       style: NeumorphicStyle(
          //         disableDepth: false,
          //         color: Theme.of(context).primaryColor,
          //         shadowLightColorEmboss: Color(0xff1035BB),
          //         shadowDarkColorEmboss: Color(0xff8199F2),
          //         boxShape:
          //             NeumorphicBoxShape.roundRect(BorderRadius.circular(6)),
          //         depth: -1,
          //         shape: NeumorphicShape.concave,
          //         lightSource: LightSource.topRight,
          //         intensity: 1,
          //       ),
          //       child: Container(
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(6),
          //           boxShadow: <BoxShadow>[
          //             BoxShadow(
          //               color: Color(0xff8199F2).withOpacity(.15),
          //               offset: Offset(-1, 2),
          //               blurRadius: 10,
          //               blurStyle: BlurStyle.inner,
          //             ),
          //             BoxShadow(
          //               color: Color(0xff1035BB).withOpacity(.15),
          //               offset: Offset(-1, 2),
          //               blurRadius: 10,
          //               blurStyle: BlurStyle.inner,
          //             ),
          //           ],
          //         ),
          //         child: Material(
          //             color: Colors.transparent,
          //             child: Ink(
          //               decoration: BoxDecoration(
          //                 color: Theme.of(context).primaryColor,
          //                 borderRadius: BorderRadius.circular(6),
          //               ),
          //               height: 52,
          //               width: 52,
          //               child: InkWell(
          //                   splashColor: Theme.of(context).primaryColor,
          //                   focusColor: Theme.of(context).primaryColor,
          //                   borderRadius: BorderRadius.circular(6),
          //                   onTap: () {
          //                     Provider.of<ImagesProvider>(context,
          //                             listen: false)
          //                         .saveNetworkImage(context, widget.imageUrl);
          //                   },
          //                   child: Center(
          //                       child: SvgPicture.asset(
          //                     'assets/icons/download.svg',
          //                     height: 28,
          //                   ))),
          //             )),
          //       ),
          //     ),
          //     SizedBox(height: 6),
          //     Text(getTranslated('save', context),
          //         textAlign: TextAlign.center,
          //         maxLines: 1,
          //         style: GoogleFonts.roboto(
          //           fontSize: 13,
          //           color: Theme.of(context).primaryColor,
          //           fontWeight: FontWeight.w500,
          //         ))
          //   ],
          // ),
          // Column(
          //   children: [
          //     Neumorphic(
          //       style: NeumorphicStyle(
          //         disableDepth: false,
          //         color: Theme.of(context).primaryColor,
          //         shadowLightColorEmboss: Color(0xff1035BB),
          //         shadowDarkColorEmboss: Color(0xff8199F2),
          //         boxShape:
          //             NeumorphicBoxShape.roundRect(BorderRadius.circular(6)),
          //         depth: -1,
          //         shape: NeumorphicShape.concave,
          //         lightSource: LightSource.topRight,
          //         intensity: 1,
          //       ),
          //       child: Container(
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(6),
          //           boxShadow: <BoxShadow>[
          //             BoxShadow(
          //               color: Color(0xff8199F2).withOpacity(.15),
          //               offset: Offset(-1, 2),
          //               blurRadius: 10,
          //               blurStyle: BlurStyle.inner,
          //             ),
          //             BoxShadow(
          //               color: Color(0xff1035BB).withOpacity(.15),
          //               offset: Offset(-1, 2),
          //               blurRadius: 10,
          //               blurStyle: BlurStyle.inner,
          //             ),
          //           ],
          //         ),
          //         child: Material(
          //             color: Colors.transparent,
          //             child: Ink(
          //               decoration: BoxDecoration(
          //                 color: Theme.of(context).primaryColor,
          //                 borderRadius: BorderRadius.circular(6),
          //               ),
          //               height: 52,
          //               width: 52,
          //               child: InkWell(
          //                   splashColor: Theme.of(context).primaryColor,
          //                   focusColor: Theme.of(context).primaryColor,
          //                   borderRadius: BorderRadius.circular(6),
          //                   onTap: () {
          //                     FlutterShare.share(
          //                         title: getTranslated(
          //                             'share_content_title', context),
          //                         text: getTranslated(
          //                             'share_content_text', context),
          //                         linkUrl: widget.imageUrl);
          //                   },
          //                   child: Center(
          //                       child: SvgPicture.asset(
          //                     'assets/icons/share.svg',
          //                     height: 28,
          //                   ))),
          //             )),
          //       ),
          //     ),
          //     SizedBox(height: 6),
          //     Text(getTranslated('share', context),
          //         textAlign: TextAlign.center,
          //         maxLines: 1,
          //         style: GoogleFonts.roboto(
          //           fontSize: 13,
          //           color: Theme.of(context).primaryColor,
          //           fontWeight: FontWeight.w500,
          //         ))
          //   ],
          // ),
          SizedBox(
            width: 18,
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Material(
                    color: Colors.transparent,
                    child: Ink(
                      width: 86,
                      decoration: BoxDecoration(
                        color: Color(0xff1B2029),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: InkWell(
                        splashColor: Color(0xff1B2029),
                        focusColor: Color(0xff1B2029),
                        borderRadius: BorderRadius.circular(6),
                        onTap: () {
                          Provider.of<ImagesProvider>(context, listen: false)
                              .saveNetworkImage(context, widget.imageUrl);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/icons/save.png',
                                height: 28,
                              ),
                              SizedBox(height: 8),
                              Text(getTranslated('save', context),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: GoogleFonts.roboto(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
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

  Widget renderFavouriteButton() {
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
            child: Center(
              child: LikeButton(
                key: tmpKey,
                circleColor: CircleColor(start: Colors.red, end: Colors.red),
                bubblesColor: BubblesColor(
                  dotPrimaryColor: Colors.red,
                  dotSecondaryColor: Colors.red,
                ),
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                countPostion: CountPostion.bottom,
                isLiked: liked,
                likeBuilder: (bool isLiked) {
                  return Icon(
                    Icons.favorite,
                    color: isLiked ? Colors.red : Colors.white,
                  );
                },
                onTap: onLikeButtonTapped,
              ),
            ),
          )),
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    final SharedPreferences prefs = await _prefs;
    List<String> favList = prefs.getStringList('favList') ?? [];

    final img = widget.galleryItems[galleryIndex];

    if (favList.contains(img)) {
      favList.remove(img);
      prefs.setStringList('favList', favList);
      setState(() {
        liked = false;
      });
    } else {
      favList.insert(0, img);
      prefs.setStringList('favList', favList);
      setState(() {
        liked = true;
      });
    }

    return liked;
  }

  Widget renderSizeWidget() {
    Image image = new Image.network(widget.imageUrl);
    Completer<ui.Image> completer = new Completer<ui.Image>();

    image.image.resolve(new ImageConfiguration()).addListener(
        ImageStreamListener(
            (ImageInfo info, bool _) => completer.complete(info.image)));

    return FutureBuilder<ui.Image>(
      future: completer.future,
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        if (snapshot.hasData)
          return Neumorphic(
            style: NeumorphicStyle(
              disableDepth: false,
              color: Colors.white70,
              shadowLightColor: Color(0xff8199F2).withOpacity(.15),
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(7)),
              depth: 1,
              shape: NeumorphicShape.convex,
              intensity: 1,
            ),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    gradient: LinearGradient(colors: [
                      Color(0xff898EF8),
                      Color(0xff7269DB),
                    ])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${snapshot.data.width}x${snapshot.data.height}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          .copyWith(fontSize: 16),
                    ),
                  ],
                )),
          );
        return Container();
      },
    );
  }
}
