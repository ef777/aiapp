import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:ainsighter/data/components.dart';
import 'package:ainsighter/data/model/response/style_model.dart';
import 'package:ainsighter/data/repository/images_repo.dart';
import 'package:ainsighter/provider/images_provider.dart';
import 'package:ainsighter/provider/splash_provider.dart';
import 'package:ainsighter/provider/style_provider.dart';
import 'package:ainsighter/utill/app_constants.dart';
import 'package:ainsighter/utill/dimensions.dart';
import 'package:ainsighter/view/base/custom_button.dart';
import 'package:ainsighter/view/base/slider_component_shape.dart';
import 'package:ainsighter/view/base/style_item.dart';
import 'package:ainsighter/view/base/update_dialog.dart';
import 'package:ainsighter/view/screens/gallery.dart';
import 'package:ainsighter/view/screens/onboarding.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart'; 
import 'package:ainsighter/view/screens/settings_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/response/image_model.dart';
import '../../../localization/language_constrants.dart';
import '../../base/showcase_item.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as imgg;
import 'package:image_cropper/image_cropper.dart';
import 'package:fast_image_resizer/fast_image_resizer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  File _imageFile;
  ui.Image img;
  String imgId;
  List<Face> _faces;
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint _customPaint;
  String _text;
  TextEditingController _promptController = TextEditingController();
  TextEditingController _textToImagePromptController = TextEditingController();
  int _faceDepth;
  int selectedStyle;
  int selectedShowcase;
  double _currentSliderValue = 55;
  File inputImage;
  File maskImage;
  String resolution;
  bool isMale = false;
  int _selectedShowcase;
  double _selectedAspectRatio = 1 / 1;
  int _selectedWith = 512;
  int _selectedHeight = 512;

  int _currentPage = 0;

  bool _suggestLoading = false;

  final ratios = [
    {"title": "1:1", "width": 512, "height": 512},
    {"title": "2:3", "width": 512, "height": 768},
    {"title": "3:2", "width": 768, "height": 512},
  ];

  Future _showcaseFuture;

  AutoScrollController controller;

  ScrollController _mainScrollController = ScrollController();

  ImagePicker picker = ImagePicker();

  bool _isUserPremium = false;

  final streamController = StreamController<String>();

  final faceDepthStreamController = StreamController<int>();

  @override
  void initState() {
    super.initState();

    print('AM I PREMIUM: ${appData.isPro}');

    _promptController.addListener(() {
      setState(() {});
    });

    Provider.of<ImagesProvider>(context, listen: false).getShowcase(context);

    streamController.stream.listen((event) {
      _promptController.text = event;
    });

    faceDepthStreamController.stream.listen((event) {
      _faceDepth = event;
    });

    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);

    Future.microtask(() async {
      setState(() {
        _isUserPremium = appData.isPro;
      });

      OneSignal.shared.setAppId("3ef0272a-bd12-4d72-a756-3f2a2397165e");

      OneSignal.shared
          .promptUserForPushNotificationPermission()
          .then((accepted) {
        print("Accepted permission: $accepted");
      });

      FirebaseMessaging.instance.getInitialMessage();
    });
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Real AI',
            ),
            centerTitle: true,
            leadingWidth: 140,
            leading: Row(
              children: [
                if (_currentPage == 1)
                  Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: renderLeadingButton(),
                  ),
                SizedBox(
                  width: 6,
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _launchUrl(Uri.parse('https://discord.gg/aiartltd'));
                  },
                  iconSize: 20,
                  icon: SvgPicture.asset(
                    'assets/icons/discord.svg',
                    height: 20,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SettingsScreen()));
                  },
                  iconSize: 24,
                  icon: SvgPicture.asset(
                    'assets/icons/settings.svg',
                    height: 24,
                  ),
                ),
              ],
            ),
            actions: [
              // IconButton(
              //     onPressed: () {
              //       Navigator.of(context).push(
              //           MaterialPageRoute(builder: (_) => SubscriptionPage()));
              //     },
              //     iconSize: 24,
              //     icon: FaIcon(
              //       FontAwesomeIcons.productHunt,
              //       color: Color(0xffEC97B3),
              //     )),
              if (_isUserPremium == false)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(colors: [
                            Color(0xff898EF8),
                            Color(0xff7269DB),
                          ])),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => SubscriptionPage()),
                            );

                            if (result != null) {
                              setState(() {
                                _isUserPremium = result;
                              });
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/crown.svg',
                                  height: 20,
                                ),
                                SizedBox(width: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pro+',
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                    // Text(
                                    //   'Version',
                                    //   style: GoogleFonts.roboto(
                                    //       fontWeight: FontWeight.w500,
                                    //       fontSize: 9,
                                    //       color: Colors.white),
                                    // ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => GalleryScreen()));
                },
                iconSize: 24,
                icon: SvgPicture.asset(
                  'assets/icons/gallery.svg',
                  height: 24,
                ),
              ),
              SizedBox(
                width: 6,
              ),
            ],
          ),
          body: IndexedStack(
            index: _currentPage,
            children: [
              _buildAiImage(),
              _buildATextToImage(),
            ],
          )),
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
            height: 30,
            width: 30,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                setState(() {
                  _currentPage = 0;
                });
              },
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/leading.svg',
                  height: 16,
                  width: 16,
                ),
              ),
            ),
          )),
    );
  }

  _buildAiImage() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _mainScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //renderImageFieldWidget(),
                // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: getImage,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Upload ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'New Photo',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ]),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff27AE60),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: getImage,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 10),
                                      child: Text(
                                        inputImage != null
                                            ? getTranslated(
                                                'photo_added', context)
                                            : getTranslated(
                                                'add_photo', context),
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/add_photo.svg',
                                  width: 72,
                                  height: 72,
                                  color: Color(0xff7269DB),
                                ),
                                SvgPicture.asset(
                                  'assets/icons/add_gallery.svg',
                                  width: 30,
                                  height: 30,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            onTap: getImage,
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _currentPage = 1;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/add_photo.svg',
                                  width: 60,
                                  height: 60,
                                  color: Color(0xff7269DB),
                                ),
                                SvgPicture.asset(
                                  'assets/icons/translate.svg',
                                  width: 24,
                                  height: 24,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                _currentPage = 1;
                              });
                            },
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Text \n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'To Image',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                renderSearchWidget(getTranslated('type_anything', context)),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getTranslated('female', context),
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 6),
                    Transform.scale(
                      child: Switch(
                        value: isMale,
                        onChanged: (val) {
                          setState(() {
                            isMale = val;
                          });

                          Provider.of<StyleProvider>(context, listen: false)
                              .getStyleList(context, type: val == true ? 2 : 1);
                        },
                        inactiveThumbColor: Color(0xffEC97B3),
                        inactiveTrackColor: Color(0xffF2F2F2),
                        activeColor: Color(0xff898EF8),
                        activeTrackColor: Color(0xffF2F2F2),
                      ),
                      scale: 1.4,
                    ),
                    SizedBox(width: 6),
                    Text(
                      getTranslated('male', context),
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Consumer<StyleProvider>(
                  builder: (context, styleProvider, child) =>
                      ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: styleProvider.styleList
                              .map((e) => e.title)
                              .toSet()
                              .toList()
                              .length,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 24,
                            );
                          },
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    styleProvider.styleList
                                        .map((e) => e.title)
                                        .toSet()
                                        .toList()[index],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width * .42,
                                    child: ListView.separated(
                                        controller: controller,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, int aindex) {
                                          StyleModel item = styleProvider
                                              .styleList
                                              .where((k) =>
                                                  k.title ==
                                                  styleProvider.styleList
                                                      .map((e) => e.title)
                                                      .toSet()
                                                      .toList()[index])
                                              .toList()[aindex];
                                          return AutoScrollTag(
                                            key: ValueKey(aindex),
                                            index: aindex,
                                            controller: controller,
                                            child: StyleItem(
                                              item: item,
                                              onPressed: () {
                                                setState(() {
                                                  selectedStyle = item.id;
                                                  _promptController.text =
                                                      item.prompt;
                                                });
                                                _mainScrollController.animateTo(
                                                  0,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  curve: Curves.fastOutSlowIn,
                                                );
                                              },
                                              isSelected:
                                                  _promptController.text ==
                                                      item.prompt,
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(width: 14);
                                        },
                                        itemCount: styleProvider.styleList
                                            .where((k) =>
                                                k.title ==
                                                styleProvider.styleList
                                                    .map((e) => e.title)
                                                    .toSet()
                                                    .toList()[index])
                                            .length))
                              ],
                            );
                          }),
                ),
              ],
            ),
          ),
        ),
        renderCreateButtonWidget()
      ],
    );
  }

  _buildATextToImage() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _mainScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //renderImageFieldWidget(),
                // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                renderSearchWidget(getTranslated('write_anything', context)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getTranslated('select_ratio', context),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        children: [
                          _ShapeSelection(
                            '1 : 1',
                            1 / 1,
                            Icons.crop_square,
                            512,
                            512,
                          ),
                          _ShapeSelection(
                            '2 : 3',
                            2 / 3,
                            Icons.crop_portrait_rounded,
                            512,
                            768,
                          ),
                          _ShapeSelection(
                            '3 : 2',
                            3 / 2,
                            Icons.crop_3_2,
                            768,
                            512,
                          ),
                        ].map((shapeData) {
                          return Container(
                            decoration: BoxDecoration(
                              color:
                                  _selectedAspectRatio == shapeData.aspectRatio
                                      ? Color(0xff898EF8)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4),
                                onTap: () {
                                  setState(() {
                                    _selectedAspectRatio =
                                        shapeData.aspectRatio;
                                    _selectedWith = shapeData.width;
                                    _selectedHeight = shapeData.height;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 10),
                                  child: Column(
                                    children: [
                                      Icon(shapeData.icon),
                                      const SizedBox(height: 6),
                                      Text(
                                        shapeData.label,
                                        style: TextStyle(fontSize: 11),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList())
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 24, 16, 6),
                      child: Text(
                        getTranslated('community_showcase', context),
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    Consumer<ImagesProvider>(
                      builder: (context, imagesProvider, child) {
                        if (imagesProvider.isFetchLoading)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        else if (imagesProvider.showcaseList.isNotEmpty) {
                          return GridView.builder(
                            padding: EdgeInsets.all(16),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: imagesProvider.showcaseList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.9,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 6,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              final item = imagesProvider.showcaseList[index];
                              bool selected = item.id == _selectedShowcase &&
                                  _promptController.text == item.prompt;
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedShowcase = item.id;
                                      _promptController.text = item.prompt;
                                      _promptController.selection =
                                          TextSelection.fromPosition(
                                        TextPosition(
                                          offset: _promptController.text.length,
                                        ),
                                      );
                                    });
                                    _mainScrollController.animateTo(
                                      0,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.fastOutSlowIn,
                                    );
                                  },
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: item.url,
                                          fit: BoxFit.cover,
                                          color: selected
                                              ? Color(0xff898EF8)
                                                  .withOpacity(0.8)
                                              : Colors.transparent,
                                          colorBlendMode: BlendMode.srcATop,
                                        ),
                                      ),
                                      if (selected)
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/image/selected.svg",
                                                height: 64,
                                                width: 64,
                                                fit: BoxFit.cover,
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                getTranslated(
                                                    'selected', context),
                                                style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        return Container();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        renderTextToImageButton()
      ],
    );
  }

  Widget renderImageFieldWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.topRight,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8, right: 8),
                child: InkWell(
                  onTap: getImage,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 1,
                        color: Color(0xffDFDFDF),
                      ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/${inputImage != null ? 'checked' : 'add'}.svg',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          getTranslated('add_image', context),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.baloo2(
                              fontSize: 20,
                              color: Color(0xffCBCBCB),
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              if (inputImage != null)
                Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          inputImage = null;
                        });
                      },
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Color(0xff316064),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ))
            ],
          ),
          SizedBox(
            width: 20,
          ),
          if (inputImage != null)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    getTranslated('image_strength', context),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.baloo2(
                        fontSize: 20,
                        color: Color(0xffCBCBCB),
                        fontWeight: FontWeight.w400),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SliderTheme(
                            data: SliderThemeData(
                              trackShape: CustomTrackShape(),
                              overlayShape: SliderComponentShape.noThumb,
                              trackHeight: 8,
                              activeTrackColor: Theme.of(context).primaryColor,
                              inactiveTrackColor: Color(0xffCBCBCB),
                              thumbColor: Color(0xffD0D0D0),
                              activeTickMarkColor: Colors.transparent,
                              inactiveTickMarkColor: Colors.transparent,
                              thumbShape: CircleThumbShape(thumbRadius: 14),
                            ),
                            child: Slider(
                              value: _currentSliderValue,
                              max: 100,
                              divisions: 10,
                              label: _currentSliderValue.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  _currentSliderValue = value;
                                });
                              },
                            )),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '%${_currentSliderValue.round().toString()}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget renderSearchWidget(String hintText) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
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
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              controller: _promptController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xff1B2029),
                counterText: "",
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/magic.svg',
                      height: 26,
                      width: 26,
                      color: Color(0xffD0D1D3),
                    ),
                  ],
                ),
                hintText: hintText,
                suffixIcon: _suggestLoading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        ],
                      )
                    : null,
              )),
        ),
        // if (_promptController.text.isNotEmpty)
        //   Padding(
        //     padding: EdgeInsets.only(right: 8),
        //     child: InkWell(
        //       onTap: () {
        //         setState(() {
        //           _promptController.text = '';
        //           //inputImage = null;
        //         });
        //       },
        //       child: FaIcon(FontAwesomeIcons.times,
        //           color: Theme.of(context).primaryColor),
        //     ),
        //   )
      ],
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(faces, inputImage.inputImageData.size,
          inputImage.inputImageData.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Widget renderCreateButtonWidget() {
    String promptText = _promptController.text.trim();
    return Consumer<ImagesProvider>(
        builder: (context, imagesProvider, child) => Padding(
              padding: EdgeInsets.fromLTRB(32, 0, 32, 10),
              child: CustomButton(
                isActive: promptText.isNotEmpty &&
                    inputImage != null &&
                    maskImage != null,
                buttonText: getTranslated('generate', context) +
                    "${_isUserPremium == false ? ' - (${imagesProvider.remain < 0 ? "0" : imagesProvider.remain})' : ''}",
                onPressed: () async {
                  if (promptText.isNotEmpty &&
                      inputImage != null &&
                      maskImage != null) {
                    try {
                      CustomerInfo customerInfo =
                          await Purchases.getCustomerInfo();
                      int remainUsage = GetIt.instance<SharedPreferences>()
                          .getInt(AppConstants.REMAIN_USAGE);

                      if (customerInfo.entitlements.active.isNotEmpty ||
                          remainUsage > 0) {
                        Provider.of<ImagesProvider>(context, listen: false)
                            .createSquareTask(
                          context,
                          prompt: _promptController.text,
                          imageInput: inputImage,
                          maskImage: maskImage,
                          resolution: resolution,
                          faceDepth: _faceDepth,
                          stream: streamController,
                          faceDepthStream: faceDepthStreamController,
                        );
                      } else {
                        setState(() {
                          _isUserPremium = false;
                        });

                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SubscriptionPage()),
                        );

                        if (result != null) {
                          setState(() {
                            _isUserPremium = result;
                          });
                        }
                      }
                    } on PlatformException catch (e) {}
                  }
                },
              ),
            ));
  }

  Widget renderTextToImageButton() {
    String promptText = _promptController.text.trim();
    return Consumer<ImagesProvider>(
        builder: (context, imagesProvider, child) => Padding(
              padding: EdgeInsets.fromLTRB(32, 0, 32, 10),
              child: CustomButton(
                isActive: promptText.isNotEmpty &&
                    _selectedHeight != null &&
                    _selectedWith != null,
                buttonText: getTranslated('generate', context) +
                    "${_isUserPremium == false ? ' - (${imagesProvider.remain < 0 ? "0" : imagesProvider.remain})' : ''}",
                onPressed: () async {
                  if (promptText.isNotEmpty &&
                      _selectedWith != null &&
                      _selectedHeight != null) {
                    try {
                      CustomerInfo customerInfo =
                          await Purchases.getCustomerInfo();
                      int remainUsage = GetIt.instance<SharedPreferences>()
                          .getInt(AppConstants.REMAIN_USAGE);
                      if (customerInfo.entitlements.active.isNotEmpty ||
                          remainUsage > 0) {
                        Provider.of<ImagesProvider>(context, listen: false)
                            .createTextToImageTask(
                          context,
                          prompt: _promptController.text,
                          resolution: resolution,
                          stream: streamController,
                          width: _selectedWith,
                          height: _selectedHeight,
                        );
                      } else {
                        setState(() {
                          _isUserPremium = false;
                        });
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SubscriptionPage()),
                        );

                        if (result != null) {
                          setState(() {
                            _isUserPremium = result;
                          });
                        }
                      }
                    } on PlatformException catch (e) {}
                  }
                },
              ),
            ));
  }

  getImage() async {
    XFile image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio2x3,
        ],
        compressQuality: 100,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: getTranslated('crop', context),
          toolbarColor: Color(0xff898EF8),
          toolbarWidgetColor: Colors.white,
          // lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
            doneButtonTitle: getTranslated('okay', context),
            cancelButtonTitle: getTranslated('cancel', context),
            aspectRatioLockEnabled: false,
            aspectRatioLockDimensionSwapEnabled: true),
      );

      setState(() {
        maskImage = null;
        inputImage = null;
        _faceDepth = null;
      });

      var decodedImage =
          await decodeImageFromList(croppedFile.readAsBytesSync());

      double width;
      double height;

      if (decodedImage.width > decodedImage.height) {
        width = 768;
        height = 512;
      } else if (decodedImage.height > decodedImage.width) {
        width = 512;
        height = 768;
      } else {
        height = 512;
        width = 512;
      }

      // setState(() {
      //   resolution = "${height.toInt()} x ${width.toInt()}";
      // });

      final bytes = await resizeImage(
        croppedFile.readAsBytesSync(),
        width: width.toInt(),
        height: height.toInt(),
      );

      File newFile = await croppedFile.writeAsBytes(bytes.buffer.asInt8List());

      final newInputImage = InputImage.fromFile(newFile);
      final imgToMask = await _loadImage(newFile);

      final faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableContours: true,
          enableClassification: true,
        ),
      );

      List<Face> faces = await faceDetector.processImage(newInputImage);

      if (faces != null && faces.isNotEmpty) {
        if (mounted) {
          final FacePainter p = FacePainter(imgToMask, faces);
          ui.PictureRecorder recorder = ui.PictureRecorder();
          Canvas canvas = Canvas(recorder);
          p.paint(canvas, Size(width, height));
          recorder
              .endRecording()
              .toImage(width.floor(), height.floor())
              .then((image) {
            image
                .toByteData(format: ui.ImageByteFormat.png)
                .then((ByteData data) async {
              if (data != null) {
                Directory tempDir = await getTemporaryDirectory();

                File newFile =
                    await File(tempDir.path + '/image6.png').writeAsBytes(
                  data.buffer.asUint8List(),
                );

                setState(() {
                  maskImage = newFile;
                });
              }
            });
          });

          setState(() {
            inputImage = newFile;
            _imageFile = newFile;
            _faces = faces;
          });
        }
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black87,
            builder: (BuildContext context) {
              return DefaultErrorDialog(
                asset: 'close-circle',
                message: getTranslated('face_not_found', context),
              );
            });
      }
    }

    // if (image != null) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (_) => Scaffold(
    //         body: ConfigurableCrop(
    //             imagePath: image.path,
    //             onCropped: (val) async {
    //               Navigator.of(context).pop();
    //
    //               if (val != null) {
    //                 final tempDir = await getTemporaryDirectory();
    //                 File croppedFile =
    //                     await File('${tempDir.path}/image.png').create();
    //                 croppedFile.writeAsBytesSync(val);
    //
    //                 var decodedImage = await decodeImageFromList(val);
    //
    //                 double width;
    //                 double height;
    //
    //                 if (decodedImage.width > decodedImage.height) {
    //                   width = 768;
    //                   height = 512;
    //                 } else if (decodedImage.height > decodedImage.width) {
    //                   width = 512;
    //                   height = 768;
    //                 } else {
    //                   height = 512;
    //                   width = 512;
    //                 }
    //
    //                 final bytes = await resizeImage(
    //                   val,
    //                   width: width.toInt(),
    //                   height: height.toInt(),
    //                 );
    //
    //                 File newFile = await croppedFile
    //                     .writeAsBytes(bytes.buffer.asInt8List());
    //
    //                 final newInputImage = InputImage.fromFile(newFile);
    //                 final imgToMask = await _loadImage(newFile);
    //
    //                 final faceDetector = FaceDetector(
    //                   options: FaceDetectorOptions(
    //                     enableContours: true,
    //                     enableClassification: true,
    //                   ),
    //                 );
    //
    //                 List<Face> faces =
    //                     await faceDetector.processImage(newInputImage);
    //
    //                 print('FOUNDFACES ${faces.length}');
    //                 if (faces != null && faces.isNotEmpty) {
    //                   if (mounted) {
    //                     final FacePainter p = FacePainter(imgToMask, faces);
    //                     ui.PictureRecorder recorder = ui.PictureRecorder();
    //                     Canvas canvas = Canvas(recorder);
    //                     p.paint(canvas, Size(width, height));
    //                     recorder
    //                         .endRecording()
    //                         .toImage(width.floor(), height.floor())
    //                         .then((image) {
    //                       image
    //                           .toByteData(format: ui.ImageByteFormat.png)
    //                           .then((ByteData data) async {
    //                         if (data != null) {
    //                           Directory tempDir = await getTemporaryDirectory();
    //
    //                           File newFile =
    //                               await File(tempDir.path + '/image6.png')
    //                                   .writeAsBytes(
    //                             data.buffer.asUint8List(),
    //                           );
    //
    //                           setState(() {
    //                             maskImage = newFile;
    //                           });
    //                         }
    //                       });
    //                     });
    //
    //                     setState(() {
    //                       inputImage = newFile;
    //                       _imageFile = newFile;
    //                       _faces = faces;
    //                     });
    //                   }
    //                 } else {
    //                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //                     content: Text(
    //                       'Face not found',
    //                       style: TextStyle(color: Colors.white),
    //                     ),
    //                     backgroundColor: Colors.red,
    //                   ));
    //
    //                   setState(() {
    //                     maskImage = null;
    //                     inputImage = null;
    //                   });
    //                 }
    //               }
    //             }),
    //       ),
    //       fullscreenDialog: true,
    //     ),
    //   );
    // }

    return;
  }

  Future _loadImage(File file) async {
    final data = await file.readAsBytes();
    final img = await decodeImageFromList(data);
    return img;
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.faces, this.absoluteImageSize, this.rotation);

  final List<Face> faces;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.red;

    for (final Face face in faces) {
      canvas.drawRect(
        Rect.fromLTRB(
          translateX(face.boundingBox.left, rotation, size, absoluteImageSize),
          translateY(face.boundingBox.top, rotation, size, absoluteImageSize),
          translateX(face.boundingBox.right, rotation, size, absoluteImageSize),
          translateY(
              face.boundingBox.bottom, rotation, size, absoluteImageSize),
        ),
        paint,
      );

      void paintContour(FaceContourType type) {
        final faceContour = face.contours[type];
        if (faceContour?.points != null) {
          for (final Point point in faceContour.points) {
            canvas.drawCircle(
              Offset(
                translateX(
                    point.x.toDouble(), rotation, size, absoluteImageSize),
                translateY(
                    point.y.toDouble(), rotation, size, absoluteImageSize),
              ),
              1,
              paint,
            );
          }
        }
      }

      paintContour(FaceContourType.face);
      paintContour(FaceContourType.leftEyebrowTop);
      paintContour(FaceContourType.leftEyebrowBottom);
      paintContour(FaceContourType.rightEyebrowTop);
      paintContour(FaceContourType.rightEyebrowBottom);
      paintContour(FaceContourType.leftEye);
      paintContour(FaceContourType.rightEye);
      paintContour(FaceContourType.upperLipTop);
      paintContour(FaceContourType.upperLipBottom);
      paintContour(FaceContourType.lowerLipTop);
      paintContour(FaceContourType.lowerLipBottom);
      paintContour(FaceContourType.noseBridge);
      paintContour(FaceContourType.noseBottom);
      paintContour(FaceContourType.leftCheek);
      paintContour(FaceContourType.rightCheek);
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}

double translateX(
    double x, InputImageRotation rotation, Size size, Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return x *
          size.width /
          (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    case InputImageRotation.rotation270deg:
      return size.width -
          x *
              size.width /
              (Platform.isIOS
                  ? absoluteImageSize.width
                  : absoluteImageSize.height);
    default:
      return x * size.width / absoluteImageSize.width;
  }
}

double translateY(
    double y, InputImageRotation rotation, Size size, Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return y *
          size.height /
          (Platform.isIOS ? absoluteImageSize.height : absoluteImageSize.width);
    default:
      return y * size.height / absoluteImageSize.height;
  }
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];
  Size lastSize;

  FacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) async {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    final Paint paintOval = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    canvas.drawImage(image, Offset(0.0, 0.0), paint);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      paint,
    );

    for (var i = 0; i < faces.length; i++) {
      void paintContour(FaceContourType type) {
        final faceContour = faces[i].contours[type];

        if (faceContour != null) {
          final path = Path();
          path.addPolygon(
              faceContour.points
                  .map((e) => Offset(e.x.toDouble(), e.y.toDouble()))
                  .toList(),
              true);
          canvas.drawPath(path, paintOval);
        }
      }

      paintContour(FaceContourType.face);
    }
  }

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}

class _ShapeSelection {
  const _ShapeSelection(
      this.label, this.aspectRatio, this.icon, this.width, this.height);

  final String label;
  final double aspectRatio;
  final IconData icon;
  final int width;
  final int height;
}
