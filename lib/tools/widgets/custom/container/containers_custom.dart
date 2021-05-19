import 'package:flutter/cupertino.dart';

Widget twoLinesContainer(Widget oneLine, Widget twoLine,
    {EdgeInsets margin, EdgeInsets padding}) {
  return Container(
    margin: margin ?? EdgeInsets.zero,
    padding: padding ?? EdgeInsets.zero,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        oneLine,
        twoLine,
      ],
    ),
  );
}

Widget twoColumnsContainer(Widget oneColumn, Widget twoColumn,
    {EdgeInsets margin, EdgeInsets padding}) {
  return Container(
    margin: margin ?? EdgeInsets.zero,
    padding: padding ?? EdgeInsets.zero,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        oneColumn,
        twoColumn,
      ],
    ),
  );
}
