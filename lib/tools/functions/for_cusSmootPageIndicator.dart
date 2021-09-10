import 'package:flutter/material.dart';

void nextSmootPageIndicator(PageController controller) {
  controller.animateToPage(controller.page.toInt() + 1,
      duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
}

void previousSmootPageIndicator(PageController controller) {
  controller.animateToPage(controller.page.toInt() - 1,
      duration: Duration(milliseconds: 400), curve: Curves.easeIn);
}
