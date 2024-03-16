import 'dart:ui';

import 'package:ainsighter/provider/images_provider.dart';
import 'package:ainsighter/view/base/lazy_image.dart';
import 'package:ainsighter/view/screens/home/home_screen.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../localization/language_constrants.dart';

class ResultScreen extends StatefulWidget {
  final String imageUrl;
  final String prompt;
  final int style;

  ResultScreen({this.imageUrl, this.prompt, this.style});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          LazyImage(
            url: widget.imageUrl,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 40,
            left: 16,
            child: Neumorphic(
              style: NeumorphicStyle(
                disableDepth: false,
                color: Colors.transparent,
                shadowLightColor: Colors.black,
                shadowDarkColor: Colors.transparent,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 6,
                shape: NeumorphicShape.concave,
                lightSource: LightSource.bottom,
                intensity: 1,
              ),
              child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 52,
                    width: 52,
                    child: InkWell(
                      splashColor: Theme.of(context).primaryColor,
                      focusColor: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                          child: SimpleShadow(
                        offset: Offset(-2, 6),
                        child: FaIcon(
                          FontAwesomeIcons.chevronLeft,
                          size: 38,
                          color: Colors.white,
                        ),
                      )),
                    ),
                  )),
            ),
            // child: InkWell(
            //   onTap: () {
            //     Navigator.of(context).pop();
            //     // Navigator.of(context).pushAndRemoveUntil(
            //     //     MaterialPageRoute(
            //     //       builder: (_) => HomeScreen(),
            //     //     ),
            //     //     (route) => false);
            //   },
            //   focusColor: Theme.of(context).primaryColor,
            //   splashColor: Theme.of(context).primaryColor,
            //   child: Material(
            //     color: Colors.transparent,
            //     child: Container(
            //       height: 52,
            //       width: 52,
            //       decoration: BoxDecoration(
            //           color: Colors.white.withOpacity(.6),
            //           borderRadius: BorderRadius.circular(12),
            //           boxShadow: <BoxShadow>[
            //             BoxShadow(
            //               color: Colors.black,
            //               offset: Offset(0, 6),
            //               spreadRadius: 0,
            //               blurRadius: 3,
            //             ),
            //           ]),
            //       child: Center(
            //         child: FaIcon(
            //           FontAwesomeIcons.chevronLeft,
            //           size: 32,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Neumorphic(
                    style: NeumorphicStyle(
                      disableDepth: false,
                      color: Colors.transparent,
                      shadowLightColor: Colors.black,
                      shadowDarkColor: Colors.transparent,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                      depth: 6,
                      shape: NeumorphicShape.concave,
                      lightSource: LightSource.bottom,
                      intensity: 1,
                    ),
                    child: Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 52,
                          width: 52,
                          child: InkWell(
                            splashColor: Theme.of(context).primaryColor,
                            focusColor: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Provider.of<ImagesProvider>(context,
                                      listen: false)
                                  .createTask(
                                context,
                                prompt: widget.prompt,
                                style: widget.style,
                                fromResult: true,
                              );
                            },
                            child: Center(
                                child: SimpleShadow(
                              offset: Offset(0, 6),
                              child: SvgPicture.asset(
                                'assets/icons/generate.svg',
                                height: 28,
                              ),
                            )),
                          ),
                        )),
                  ),
                  Neumorphic(
                      style: NeumorphicStyle(
                        disableDepth: false,
                        color: Colors.transparent,
                        shadowLightColor: Colors.black,
                        shadowDarkColor: Colors.transparent,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                        depth: 6,
                        shape: NeumorphicShape.concave,
                        lightSource: LightSource.bottom,
                        intensity: 1,
                      ),
                      child: Material(
                          color: Colors.transparent,
                          child: Ink(
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 52,
                            width: 52,
                            child: InkWell(
                              splashColor: Theme.of(context).primaryColor,
                              focusColor: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Provider.of<ImagesProvider>(context,
                                        listen: false)
                                    .saveNetworkImage(context, widget.imageUrl);
                              },
                              child: Center(
                                  child: SimpleShadow(
                                offset: Offset(0, 6),
                                child: SvgPicture.asset(
                                  'assets/icons/download.svg',
                                  height: 28,
                                ),
                              )),
                            ),
                          ))),
                  Neumorphic(
                    style: NeumorphicStyle(
                      disableDepth: false,
                      color: Colors.transparent,
                      shadowLightColor: Colors.black,
                      shadowDarkColor: Colors.transparent,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                      depth: 6,
                      shape: NeumorphicShape.concave,
                      lightSource: LightSource.bottom,
                      intensity: 1,
                    ),
                    child: Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 52,
                          width: 52,
                          child: InkWell(
                            splashColor: Theme.of(context).primaryColor,
                            focusColor: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              FlutterShare.share(
                                  title: 'Here is my art: ',
                                  text: 'Here is my art: ',
                                  linkUrl: widget.imageUrl);
                            },
                            child: Center(
                                child: SimpleShadow(
                              offset: Offset(0, 6),
                              child: SvgPicture.asset(
                                'assets/icons/share.svg',
                                height: 28,
                              ),
                            )),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
