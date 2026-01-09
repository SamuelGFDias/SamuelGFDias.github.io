import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portifolio/core/constants/platform_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'platform_provider.g.dart';

@Riverpod(keepAlive: true)
PlatformType platform(Ref ref, double width, double height) {
  return PlatformType.getByDelimiter(width, height);
}
