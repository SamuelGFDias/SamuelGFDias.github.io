import 'package:flutter/material.dart';

class ResponsiveUI {
  ResponsiveUI._();

  static const double tabletBreakpoint = 600.0;

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }
}
