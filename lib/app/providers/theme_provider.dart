import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeColor extends _$ThemeColor {
  @override
  Brightness build() {
    return Brightness.light;
  }

  void toggleTheme() {
    state = state == Brightness.light ? Brightness.dark : Brightness.light;
  }
}
