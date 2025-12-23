import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portifolio/core/repositories/content_repository.dart';
import 'package:portifolio/core/repositories/firestore_content_repository.dart';

part 'home_content.g.dart';

@Riverpod(keepAlive: true)
Future<Map<String, dynamic>> homeContent(Ref ref) async {
  final repo = ref.watch(contentRepositoryProvider);
  final remote = await repo.getHome();
  if (remote != null) return remote;

  const homeContentPath = "assets/contents/home.json";
  final String homeContentString = await rootBundle.loadString(homeContentPath);
  final content = json.decode(homeContentString) as Map<String, dynamic>;
  return content;
}

final homeContentStreamProvider = StreamProvider<Map<String, dynamic>>((
  ref,
) async* {
  final useFs = ref.watch(useFirestoreProvider);
  if (useFs) {
    final firestore = ref.watch(firebaseFirestoreProvider);
    yield* firestore.doc('cms/home').snapshots().map((snap) {
      final data = snap.data();
      if (data == null) {
        // Retornar estrutura padrão vazia em vez de mapa vazio
        return <String, dynamic>{
          'hero': <String, dynamic>{'title': '', 'subtitle': ''},
          'about': <String, dynamic>{'title': '', 'description': ''},
          'skills': <String, dynamic>{'title': '', 'items': <dynamic>[]},
          'projects': <String, dynamic>{'title': '', 'items': <dynamic>[]},
          'links': <dynamic>[],
        };
      }
      return Map<String, dynamic>.from(data);
    });
    return;
  }
  
  // Modo local: carregar do assets
  try {
    const homeContentPath = 'assets/contents/home.json';
    final String s = await rootBundle.loadString(homeContentPath);
    final content = json.decode(s) as Map<String, dynamic>;
    yield content;
  } catch (e) {
    // Se falhar ao carregar assets, retornar estrutura padrão
    yield <String, dynamic>{
      'hero': <String, dynamic>{'title': 'Erro ao carregar', 'subtitle': 'Conteúdo indisponível'},
      'about': <String, dynamic>{'title': 'Sobre', 'description': 'Erro ao carregar conteúdo'},
      'skills': <String, dynamic>{'title': 'Habilidades', 'items': <dynamic>[]},
      'projects': <String, dynamic>{'title': 'Projetos', 'items': <dynamic>[]},
      'links': <dynamic>[],
    };
  }
});
