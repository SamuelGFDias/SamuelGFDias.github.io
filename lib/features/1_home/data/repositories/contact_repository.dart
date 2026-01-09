import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portifolio/core/providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contact_repository.g.dart';

class ContactRepository {
  final Dio _dio;
  static const url =
      'https://formsubmit.co/ajax/92c2b5f7546d4f0204c1570e7e2c7ff5';
  // A dependência é recebida pelo construtor.
  ContactRepository(this._dio);

  Future<void> sendContactMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'message': message,
      '_captcha': 'false',
      '_subject': 'Nova mensagem do portifólio',
      '_template': 'table',
    });

    final response = await _dio.post(
      url,
      data: formData,
      options: Options(headers: {'Accept': 'application/json'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao enviar o formulário');
    }
  }
}

@Riverpod(keepAlive: true)
ContactRepository contactRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ContactRepository(dio);
}
