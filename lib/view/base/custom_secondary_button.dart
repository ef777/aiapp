import 'package:flutter/material.dart';

class CustomSecondaryButton extends StatelessWidget {
  CustomSecondaryButton(
      {Key key,
      this.onPress,
      this.color,
      this.text,
      this.splashColor,
      this.borderRadius,
      this.textColor,
      this.isLoading: false})
      : super(key: key);

  final Function onPress;
  final Color color;
  final String text;
  final Color splashColor;
  final BorderRadius borderRadius;
  final Color textColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: this.borderRadius ?? BorderRadius.circular(8)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  splashColor: this.splashColor,
                  child: Container(
                      height: 64,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          !isLoading
                              ? Text(
                                  this.text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: this.textColor ?? Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                )
                              : SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ))
                        ],
                      )),
                  onTap: this.onPress),
            ),
          ),
        )
      ],
    );
  }
}
