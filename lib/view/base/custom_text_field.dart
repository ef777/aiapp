import 'package:ainsighter/utill/color_resources.dart';
import 'package:ainsighter/utill/config.dart';
import 'package:ainsighter/utill/dimensions.dart';
import 'package:ainsighter/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Color fillColor;
  final int maxLines;
  final bool isPassword;
  final bool isCountryPicker;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final Function onTap;
  final Function onSuffixTap;
  final IconData suffixIconUrl;
  final IconData prefixIconUrl;
  final bool isSearch;
  final Function onSubmit;
  final bool isEnabled;
  final TextCapitalization capitalization;
  final bool isElevation;
  final bool isPadding;
  final Function onChanged;
  final bool alignLabelWithHint;
  final List<TextInputFormatter> inputFormatters;
  //final LanguageProvider languageProvider;

  CustomTextField(
      {this.hintText = 'Write something...',
      this.labelText = 'Write something...',
      this.controller,
      this.focusNode,
      this.nextFocus,
      this.isEnabled = true,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.maxLines = 1,
      this.onSuffixTap,
      this.fillColor,
      this.onSubmit,
      this.capitalization = TextCapitalization.none,
      this.isCountryPicker = false,
      this.isShowBorder = false,
      this.isShowSuffixIcon = false,
      this.isShowPrefixIcon = false,
      this.onTap,
      this.isIcon = false,
      this.isPassword = false,
      this.suffixIconUrl,
      this.prefixIconUrl,
      this.isSearch = false,
      this.isElevation = true,
      this.onChanged,
      this.isPadding = true,
      this.alignLabelWithHint = false,
      this.inputFormatters});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TextField(
        maxLines: widget.maxLines,
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: Theme.of(context).textTheme.headline2.copyWith(
            color: Theme.of(context).textTheme.bodyText1.color,
            fontSize: Dimensions.FONT_SIZE_LARGE),
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        cursorColor: Theme.of(context).primaryColor,
        textCapitalization: widget.capitalization,
        enabled: widget.isEnabled,
        autofocus: false,
        //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
        obscureText: widget.isPassword ? _obscureText : false,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          border: InputBorder.none,
          // isDense: true,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: widget.hintText,
          labelText: widget.labelText,
          isDense: true,
          alignLabelWithHint: widget.alignLabelWithHint,
          fillColor: Config.PrimaryColor.withOpacity(.1),
          hintStyle: TextStyle(color: Color(0xff181818), fontSize: 14),
          labelStyle:
              poppinsLight.copyWith(color: Color(0xff181818), fontSize: 14),
          floatingLabelStyle: TextStyle(fontSize: 12, color: Color(0xffa3a3a3)),
          filled: true,
          prefixIcon: widget.isShowPrefixIcon
              ? IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    widget.prefixIconUrl,
                    color: Config.PrimaryColor,
                    size: 20,
                  ),
                  onPressed: () {},
                )
              : null,
          // prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
          suffixIcon: widget.isShowSuffixIcon
              ? widget.isPassword
                  ? IconButton(
                      icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Theme.of(context).hintColor.withOpacity(0.3)),
                      onPressed: _toggle)
                  : widget.isIcon
                      ? IconButton(
                          onPressed: widget.onSuffixTap,
                          icon: Icon(widget.suffixIconUrl,
                              color: ColorResources.getHintColor(context)),
                        )
                      : null
              : null,
        ),
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        onSubmitted: (text) => widget.nextFocus != null
            ? FocusScope.of(context).requestFocus(widget.nextFocus)
            : widget.onSubmit != null
                ? widget.onSubmit(text)
                : null,
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
