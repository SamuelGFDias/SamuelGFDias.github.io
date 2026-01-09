import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'content_repository.dart' show ContentRepository, useFunctionsProvider;

class FirestoreContentRepository implements ContentRepository {
  FirestoreContentRepository({
    required FirebaseFirestore firestore,
    required bool useFunctions,
    FirebaseFunctions? functions,
  }) : _functions = functions,
       _firestore = firestore,
       _useFunctions = useFunctions;

  final FirebaseFunctions? _functions;
  final FirebaseFirestore _firestore;
  final bool _useFunctions;

  @override
  Future<Map<String, dynamic>?> getHome() async {
    if (_useFunctions && _functions != null) {
      try {
        final fn = _functions.httpsCallable('getHomeContent');
        final res = await fn.call({});
        final data = res.data;
        if (data == null) return null;
        return Map<String, dynamic>.from(data as Map);
      } catch (e) {
        if (kDebugMode) {
          print('Erro ao chamar função getHomeContent: $e');
        }
        // Fallback para Firestore em caso de erro
      }
    }
    final snap = await _firestore.doc('cms/home').get();
    if (!snap.exists) return null;
    final data = snap.data();
    return data == null ? null : Map<String, dynamic>.from(data);
  }

  @override
  Future<void> setHome(Map<String, dynamic> data) async {
    if (_useFunctions && _functions != null) {
      try {
        final fn = _functions.httpsCallable('updateHomeContent');
        await fn.call(data);
        return;
      } catch (e) {
        if (kDebugMode) {
          print('Erro ao chamar função updateHomeContent: $e');
        }
        // Fallback para Firestore em caso de erro
      }
    }
    await _firestore.doc('cms/home').set(data, SetOptions(merge: false));
  }
}

final firebaseFunctionsProvider = Provider<FirebaseFunctions>((ref) {
  final functions = FirebaseFunctions.instanceFor(region: 'us-central1');
  // Descomente a linha abaixo se estiver usando o emulador local
  // if (kDebugMode) {
  //   functions.useFunctionsEmulator('localhost', 5001);
  // }
  return functions;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firestoreContentRepositoryProvider = Provider<FirestoreContentRepository>(
  (ref) {
    final useFunctions = ref.watch(useFunctionsProvider);
    final firestore = ref.watch(firebaseFirestoreProvider);
    FirebaseFunctions? functions;
    if (useFunctions) {
      functions = ref.watch(firebaseFunctionsProvider);
    }
    return FirestoreContentRepository(
      functions: functions,
      firestore: firestore,
      useFunctions: useFunctions,
    );
  },
);
