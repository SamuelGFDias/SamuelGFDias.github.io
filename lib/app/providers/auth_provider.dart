import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

final firebaseAuthProvider = Provider<fb.FirebaseAuth>((ref) {
  return fb.FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<fb.User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});

class AuthController extends StateNotifier<AsyncValue<fb.User?>> {
  AuthController(this._read) : super(const AsyncValue.data(null));
  final Ref _read;

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final auth = _read.read(firebaseAuthProvider);
      final cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AsyncValue.data(cred.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    final auth = _read.read(firebaseAuthProvider);
    await auth.signOut();
    state = const AsyncValue.data(null);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<fb.User?>>((ref) {
      return AuthController(ref);
    });

// Emite eventos quando o ID token é atualizado (claims, etc.)
final idTokenChangesProvider = StreamProvider<fb.User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.idTokenChanges();
});

// Indica se o usuário atual possui a claim admin === true
final isAdminProvider = StreamProvider<bool>((ref) async* {
  yield false;
  await for (final user in ref.watch(firebaseAuthProvider).idTokenChanges()) {
    if (user == null) {
      yield false;
    } else {
      final token = await user.getIdTokenResult(true);
      final claims = token.claims ?? const {};
      yield claims['admin'] == true;
    }
  }
});
