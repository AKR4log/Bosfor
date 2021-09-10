import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget cusSmootPageIndicator(PageController controller,
    {Colors color, Colors activeColor, int counts}) {
  return SmoothPageIndicator(
    controller: controller,
    count: counts??3,
    effect: ExpandingDotsEffect(
      dotHeight: 7,
      dotWidth: 7,
      expansionFactor: 3,
      dotColor: color ?? Color.fromRGBO(255, 221, 97, 0.45),
      activeDotColor: activeColor ?? Color.fromRGBO(255, 221, 97, 1),
      // paintStyle: PaintingStyle.stroke,
      // strokeWidth: 2,
    ),
  );
}
