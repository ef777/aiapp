import 'dart:math';

import 'package:ainsighter/localization/language_constrants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../data/model/response/style_model.dart';
import '../../utill/dimensions.dart';
import 'lazy_image.dart';

class StyleItem extends StatelessWidget {
  StyleItem({
    @required this.item,
    @required this.onPressed,
    this.isSelected,
  });

  final StyleModel item;
  final Function onPressed;
  final bool isSelected;

  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onPressed,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              child: Container(
                height: MediaQuery.of(context).size.width * .42,
                width: MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? Color(0xff6C5DD3) : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: item.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * .3,
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                decoration: BoxDecoration(
                    color: !isSelected ? Color(0xff333333) : Color(0xff6C5DD3),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(14))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isSelected
                          ? getTranslated('selected', context)
                          : item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                    if (isSelected)
                      SizedBox(
                        width: 4,
                      ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 12,
                      )
                  ],
                ))
          ],
        ),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Container(
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(25),
        //         color: isSelected ? Color(0xff6C5DD3) : Color(0xff333333),
        //       ),
        //       padding: EdgeInsets.all(2),
        //       child: ClipRRect(
        //         borderRadius: BorderRadius.circular(25),
        //         child: Stack(
        //           alignment: Alignment.bottomCenter,
        //           children: [
        //             Image.network(
        //               item.image,
        //               height: MediaQuery.of(context).size.width * .3,
        //               width: MediaQuery.of(context).size.width * .3,
        //               fit: BoxFit.cover,
        //             ),
        //             Container(
        //                 decoration: BoxDecoration(
        //                   color:
        //                   isSelected ? Color(0xff6C5DD3) : Color(0xff333333),
        //                 ),
        //                 padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        //                 width: MediaQuery.of(context).size.width * .3,
        //                 child: Center(
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       Text(
        //                         isSelected ? 'Selected' : item.name,
        //                         maxLines: 1,
        //                         overflow: TextOverflow.ellipsis,
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontSize: 11,
        //                         ),
        //                       ),
        //                       if (isSelected)
        //                         SizedBox(
        //                           width: 4,
        //                         ),
        //                       if (isSelected)
        //                         Icon(
        //                           Icons.check_circle,
        //                           color: Colors.white,
        //                           size: 12,
        //                         )
        //                     ],
        //                   ),
        //                 )),
        //             // if (isSelected)
        //             //   Positioned(
        //             //     bottom: 10,
        //             //     right: 12,
        //             //     child: CircleAvatar(
        //             //       radius: 10,
        //             //       backgroundColor: Color(0xff316064),
        //             //       child: Center(
        //             //         child: Icon(
        //             //           Icons.check,
        //             //           size: 16,
        //             //           color: Colors.white,
        //             //         ),
        //             //       ),
        //             //     ),
        //             //   )
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
