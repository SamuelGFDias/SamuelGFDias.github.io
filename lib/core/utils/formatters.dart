// --------------------------------------------------
// Funções utilitárias para formatar dados para exibição na UI.
// Isso evita que a lógica de formatação se espalhe pelas telas.
// --------------------------------------------------

import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  /// Formata um objeto DateTime para uma string legível.
  /// Exemplo: "14 de ago, 2025"
  static String date(DateTime date) {
    // Para usar 'pt_BR', certifique-se de inicializar o locale no seu main.dart:
    // import 'package:intl/date_symbol_data_local.dart';
    // initializeDateFormatting('pt_BR', null);
    final formatter = DateFormat('d MMM, y', 'pt_BR');
    return formatter.format(date);
  }

  /// Formata um objeto DateTime para exibir apenas a hora.
  /// Exemplo: "15:30"
  static String time(DateTime date) {
    final formatter = DateFormat.Hm('pt_BR');
    return formatter.format(date);
  }

  /// Formata um número para o padrão de moeda brasileiro.
  /// Exemplo: "R$ 1.250,75"
  static String currency(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatter.format(value);
  }

  /// Retorna a primeira letra de um nome ou string. Útil para avatares.
  /// Exemplo: "João Silva" -> "J"
  static String firstLetter(String text) {
    if (text.isEmpty) return '';
    return text.trim()[0].toUpperCase();
  }
}
