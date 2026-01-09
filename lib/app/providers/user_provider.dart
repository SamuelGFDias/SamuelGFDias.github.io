import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

class User {
  final String name;
  final String email;
  final String phoneNumber;

  User({required this.name, required this.email, required this.phoneNumber});
}

@Riverpod(keepAlive: true)
class UserProfile extends _$UserProfile {
  @override
  User? build() {
    return User(
      name: 'Samuel Dias',
      email: 'samudias48@gmail.com',
      phoneNumber: '21969415421',
    );
  }
}
