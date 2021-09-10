import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:kz/app_localizations.dart';

Widget textFieldPhone(
    TextEditingController controller,
    String hintText,
    bool textAlignCenter,
    bool autoFocus,
    bool enabled,
    bool error,
    bool successSendCode,
    FocusNode focusNode,
    Function onChanged(),
    Function onSubmitted()) {
  return TextField(
    controller: controller,
    focusNode: focusNode,
    decoration: InputDecoration(
      prefixIconConstraints: BoxConstraints(maxHeight: 35, maxWidth: 45),
      prefixIcon: successSendCode
          ? Center(
              child: Container(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            )
          : error
              ? Center(
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: Color.fromRGBO(255, 89, 100, 1),
                  ),
                )
              : SizedBox(),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10.0),
      ),
      isCollapsed: true,
      hintText: hintText,
      contentPadding: EdgeInsets.symmetric(vertical: 13),
      filled: true,
      fillColor: error
          ? Color.fromRGBO(255, 89, 100, 0.1)
          : Color.fromRGBO(245, 245, 245, 1),
    ),
    textInputAction: TextInputAction.next,
    enabled: enabled,
    inputFormatters: [
      LengthLimitingTextInputFormatter(15),
    ],
    style: TextStyle(
      color: error
          ? Color.fromRGBO(255, 89, 100, 1)
          : Color.fromRGBO(13, 2, 33, 1),
      // fontWeight: FontWeight.w700,
      fontSize: 15,
    ),
    autofocus: autoFocus,
    textAlign: textAlignCenter ? TextAlign.center : TextAlign.start,
    keyboardType: TextInputType.phone,
    onChanged: (value) {
      onChanged();
    },
    onSubmitted: onSubmitted(),
  );
}

/// TextField
Widget textField(
  TextEditingController controller,
  bool error, {
  bool enable = true,
  String hint,
  Function onChanged,
  bool textCenter = false,
  Color colorsText,
  bool colorTransparent = false,
  FontWeight fontWeight,
  Color colorsHintText,
  bool isNumber = false,
  bool isSide = false,
  double fontSize,
  int linesMax,
}) {
  return TextField(
    controller: controller,
    maxLines: linesMax ?? 1,
    enabled: enable,
    decoration: InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: isSide
            ? BorderSide.none
            : BorderSide(
                width: 2,
                color: colorTransparent
                    ? Colors.transparent
                    : error
                        ? Color.fromRGBO(255, 89, 100, 0.7)
                        : Color.fromRGBO(190, 190, 190, 0.7),
              ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: isSide
            ? BorderSide.none
            : BorderSide(
                width: 2,
                color: colorTransparent
                    ? Colors.transparent
                    : error
                        ? Color.fromRGBO(255, 89, 100, 1)
                        : Color.fromRGBO(190, 190, 190, 1),
              ),
      ),
      border: UnderlineInputBorder(
        borderSide: isSide
            ? BorderSide.none
            : BorderSide(
                width: 2,
                color: colorTransparent
                    ? Colors.transparent
                    : error
                        ? Color.fromRGBO(255, 89, 100, 0.7)
                        : Color.fromRGBO(190, 190, 190, 0.7),
              ),
      ),
      isCollapsed: true,
      hintText: hint,
      hintStyle: TextStyle(
        color: colorsHintText ?? Color.fromRGBO(13, 2, 33, 1),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 8,
      ),
    ),
    textInputAction: TextInputAction.next,
    style: TextStyle(
        color: error
            ? Color.fromRGBO(255, 89, 100, 1)
            : colorsText ?? Color.fromRGBO(13, 2, 33, 1),
        fontSize: fontSize ?? 17,
        fontWeight: fontWeight ?? FontWeight.w500),
    onChanged: (value) {
      onChanged();
    },
    textAlign: textCenter ? TextAlign.center : TextAlign.start,
    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
  );
}

Widget textFieldSearchPopular(
    TextEditingController controller,
    String hintText,
    bool textAlignCenter,
    bool autoFocus,
    Function onChanged(),
    Function onSubmitted()) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10.0),
      ),
      isCollapsed: true,
      hintText: hintText,
      contentPadding: EdgeInsets.symmetric(vertical: 13),
      filled: true,
      fillColor: Color.fromRGBO(245, 245, 245, 1),
    ),
    textInputAction: TextInputAction.next,
    inputFormatters: [
      LengthLimitingTextInputFormatter(25),
    ],
    style: TextStyle(
      color: Color.fromRGBO(13, 2, 33, 1),
      fontWeight: FontWeight.w500,
      fontSize: 15,
    ),
    autofocus: autoFocus,
    textAlign: textAlignCenter ? TextAlign.center : TextAlign.start,
    keyboardType: TextInputType.text,
    onChanged: (value) {
      onChanged();
    },
    onSubmitted: onSubmitted(),
  );
}

Widget textFieldPhoneCode(TextEditingController controller, String hintText,
    bool textAlignCenter, bool autoFocus, bool enabled, Function onChanged()) {
  return TextField(
    controller: controller,
    scrollPadding: EdgeInsets.symmetric(horizontal: 10),
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10.0),
      ),
      hintText: hintText,
      filled: false,
      fillColor: Color.fromRGBO(245, 245, 250, 1),
    ),
    textInputAction: TextInputAction.go,
    enabled: enabled,
    inputFormatters: [
      LengthLimitingTextInputFormatter(6),
    ],
    autofocus: autoFocus,
    textAlign: textAlignCenter ? TextAlign.center : TextAlign.start,
    textAlignVertical: TextAlignVertical.center,
    keyboardType: TextInputType.phone,
    onChanged: (String value) {
      // try {
      //   if (value.length == 6) {
      onChanged();
      //   }
      // } catch (e) {}
    },
  );
}

Widget textFieldRegister(
    TextEditingController controller,
    String hintText,
    bool textAlignCenter,
    bool autoFocus,
    bool error,
    Widget suffixIcon,
    Function onChanged(),
    Function onSubmitted()) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      suffixIcon: suffixIcon,
      isCollapsed: true,
      hintText: hintText,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      filled: true,
      fillColor: error
          ? Color.fromRGBO(255, 89, 100, 0.1)
          : Color.fromRGBO(245, 245, 245, 1),
    ),
    textInputAction: TextInputAction.next,
    inputFormatters: [LengthLimitingTextInputFormatter(15)],
    style: TextStyle(
        color: error
            ? Color.fromRGBO(255, 89, 100, 1)
            : Color.fromRGBO(13, 2, 33, 1)),
    autofocus: autoFocus,
    textAlign: textAlignCenter ? TextAlign.center : TextAlign.start,
    keyboardType: TextInputType.text,
    onChanged: (value) {
      onChanged();
    },
    onSubmitted: onSubmitted(),
  );
}

Widget textFieldCommentedPost(
    TextEditingController controller,
    String hintText,
    bool textAlignCenter,
    bool autoFocus,
    bool enabled,
    bool error,
    Function onChanged(),
    Function onSubmitted()) {
  return TextField(
    controller: controller,
    maxLines: 2,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10.0),
      ),
      isCollapsed: true,
      hintText: hintText,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      filled: true,
      fillColor: error
          ? Color.fromRGBO(255, 89, 100, 0.1)
          : Color.fromRGBO(245, 245, 245, 1),
    ),
    textInputAction: TextInputAction.next,
    enabled: enabled,
    style: TextStyle(
        color: error
            ? Color.fromRGBO(255, 89, 100, 1)
            : Color.fromRGBO(13, 2, 33, 1)),
    autofocus: autoFocus,
    textAlign: textAlignCenter ? TextAlign.center : TextAlign.start,
    keyboardType: TextInputType.text,
    onChanged: (value) {
      onChanged();
    },
    onSubmitted: onSubmitted(),
  );
}

Widget textFieldtwo(TextEditingController controller, bool error, String hint,
    {int lines,
    bool isText = false,
    Color color,
    bool enable = true,
    Function onChanged,
    bool isEmail = false}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10.0),
      ),
      isCollapsed: true,
      enabled: enable,
      filled: true,
      fillColor: error
          ? Color.fromRGBO(255, 89, 100, 0.1)
          : color != null
              ? color
              : Color.fromRGBO(247, 247, 249, 1),
      hintText: hint,
      contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
    ),
    maxLines: lines ?? 1,
    textInputAction: TextInputAction.next,
    style: TextStyle(
      color: error
          ? Color.fromRGBO(255, 89, 100, 1)
          : Color.fromRGBO(13, 2, 33, 1),
      fontSize: 16,
    ),
    textAlign: TextAlign.start,
    keyboardType: isEmail
        ? TextInputType.emailAddress
        : isText
            ? TextInputType.text
            : TextInputType.number,
    onChanged: (value) {
      onChanged();
    },
  );
}

Widget textFieldPhones(
    BuildContext context, TextEditingController controller, bool error,
    {Function onChanged()}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      prefixIconConstraints: BoxConstraints(maxHeight: 25, maxWidth: 50),
      prefixIcon: Center(
        child: Icon(
          Icons.smartphone_rounded,
          color: error
              ? Color.fromRGBO(255, 89, 100, 1)
              : Color.fromRGBO(143, 161, 180, 1),
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10.0),
      ),
      isCollapsed: true,
      filled: true,
      fillColor: Color.fromRGBO(247, 247, 249, 1),
      hintText: AppLocalizations.of(context).translate('enter_phone'),
      contentPadding: EdgeInsets.symmetric(vertical: 10),
    ),
    textInputAction: TextInputAction.next,
    inputFormatters: [
      PhoneInputFormatter(
        onCountrySelected: (PhoneCountryData countryData) {},
        allowEndlessPhone: false,
      )
    ],
    style: TextStyle(
      color: error
          ? Color.fromRGBO(255, 89, 100, 1)
          : Color.fromRGBO(143, 161, 180, 1),
      fontSize: 16,
    ),
    onChanged: (String value) {
      try {
        if (value.length == 17) {
          onChanged();
        }
      } catch (e) {}
    },
    textAlign: TextAlign.start,
    keyboardType: TextInputType.phone,
  );
}
