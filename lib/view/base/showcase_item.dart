import 'dart:math';

import 'package:ainsighter/data/model/response/image_model.dart';
import 'package:ainsighter/data/model/response/style_model.dart';
import 'package:ainsighter/localization/language_constrants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_animations/simple_animations.dart';

import 'lazy_image.dart';

class ShowcaseItem extends StatelessWidget {
  ShowcaseItem({
    @required this.item,
    @required this.onPressed,
    this.isSelected,
  });

  final ImageModel item;
  final Function onPressed;
  final bool isSelected;

  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [
            Opacity(
              opacity: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LazyImage(
                      fit: BoxFit.cover,
                      url: item.url,
                      height: 94,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xff6C5DD3) : Color(0xff333333),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isSelected ? 'Selected' : 'Lionel Messi',
                            textAlign: TextAlign.center,
                          ),
                          if(isSelected)
                            SizedBox(width: 4,),
                          if(isSelected)
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 16,
                            )
                        ],
                      ),
                    )
                  ],
                )
              ),
            ),
          ],
        ));
  }
}
