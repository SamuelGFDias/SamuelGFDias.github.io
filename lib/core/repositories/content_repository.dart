import 'package:portifolio/core/repositories/firestore_content_repository.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ContentRepository {
  Future<Map<String, dynamic>?> getHome();
  Future<void> setHome(Map<String, dynamic> data);
}

class AssetsContentRepository implements ContentRepository {
  static const _path = 'assets/contents/home.json';
  @override
  Future<Map<String, dynamic>?> getHome() async {
    final s = await rootBundle.loadString(_path);
    return json.decode(s) as Map<String, dynamic>;
  }

  @override
  Future<void> setHome(Map<String, dynamic> data) async {
    if (kDebugMode) {
      // no-op: apenas para desenvolvimento local
    }
  }
}

final useFirestoreProvider = Provider<bool>(
  (_) => const bool.fromEnvironment('USE_FIRESTORE', defaultValue: false),
);

final useFunctionsProvider = Provider<bool>(
  (_) => const bool.fromEnvironment('USE_FUNCTIONS', defaultValue: false),
);

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  final useFs = ref.watch(useFirestoreProvider);
  if (useFs) {
    return ref.watch(firestoreContentRepositoryProvider);
  }
  return AssetsContentRepository();
});
