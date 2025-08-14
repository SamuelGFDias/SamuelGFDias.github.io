import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_content.g.dart';

@Riverpod(keepAlive: true)
Future<Map<String, dynamic>> homeContent(Ref ref) async {
  const homeContentPath = "contents/home.json";

  final String homeContentString = await rootBundle.loadString(homeContentPath);

  final content = json.decode(homeContentString) as Map<String, dynamic>;
  return content;
}
