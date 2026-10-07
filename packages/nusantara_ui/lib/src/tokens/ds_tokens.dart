import 'package:flutter/material.dart';

// Primitive tokens: nilai mentah hanya didefinisikan di lapisan ini.
abstract final class DsSpace {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

abstract final class DsRadius {
  static const double control = 12;
  static const double card = 20;
}

abstract final class DsLayout {
  static const double minTouchTarget = 48;
  static const double expandedBreakpoint = 840;
  static const double maxContentWidth = 1120;
}

abstract final class DsMotion {
  static const Duration feedback = Duration(milliseconds: 200);
}

enum DsBrand {
  ocean(Color(0xFF006A6A)),
  violet(Color(0xFF6750A4));

  const DsBrand(this.seed);
  final Color seed;
}
