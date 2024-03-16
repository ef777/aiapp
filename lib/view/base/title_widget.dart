import 'package:ainsighter/utill/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Function onTap;
  TitleWidget({@required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title,
          style: GoogleFonts.poppins(fontSize: 20, color: Config.PrimaryColor)),
      // onTap != null ? InkWell(
      //   onTap: onTap,
      //   child: Padding(
      //     padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
      //     child: Text(
      //       getTranslated('view_all', context),
      //       style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getHintColor(context)),
      //     ),
      //   ),
      // ) : SizedBox(),
    ]);
  }
}
