import 'package:flutter/material.dart';
import 'package:ainsighter/utill/color_resources.dart';
import 'package:ainsighter/utill/dimensions.dart';
import 'package:ainsighter/utill/styles.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final double margin;
  final bool isActive;
  final double padding;
  CustomButton(
      {@required this.buttonText,
      @required this.onPressed,
      this.margin = 0,
      this.isActive = true,
      this.padding = 8});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(margin),
        child: Opacity(
          opacity: isActive ? 1 : 0.5,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff898EF8),
                  Color(0xff7269DB),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: onPressed,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: padding),
                  child: Center(
                    child: Text(buttonText,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ),
              ),
            ),
          ),
          // child: NeumorphicButton(
          //     pressed: false,
          //     onPressed: onPressed,
          //     style: NeumorphicStyle(
          //       disableDepth: false,
          //       color: Theme.of(context).primaryColor,
          //       shadowLightColorEmboss: Color(0xff1035BB),
          //       shadowDarkColorEmboss: Color(0xff8199F2),
          //       boxShape:
          //           NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
          //       depth: -3,
          //       shape: NeumorphicShape.concave,
          //       lightSource: LightSource.topRight,
          //       intensity: 1,
          //     ),
          //     child: Container(
          //       padding: EdgeInsets.symmetric(vertical: padding),
          //       child: Center(
          //         child: Text(
          //           buttonText,
          //           style: Theme.of(context).textTheme.bodyLarge,
          //         ),
          //       ),
          //     )),
        ));
  }
}
