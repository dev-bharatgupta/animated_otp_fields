import 'package:flutter/material.dart';

class DeviceSizeHelper {
  double getPreferredHeight(
      BuildContext context, double a, double b, double c, double d) {
    final height = MediaQuery.of(context).size.height;
    return height < 600
        ? a
        : height >= 600 && height < 800
            ? b
            : height >= 800 && height < 1000 ? c : d;
  }

  double getPreferredWidth(
      BuildContext context, double a, double b, double c, double d) {
    final width = MediaQuery.of(context).size.width;
    return width < 350
        ? a
        : width >= 350 && width < 450 ? b : width >= 450 && width < 650 ? c : d;
  }
}
