import 'package:flutter/material.dart';

class AppColors {
  // Evita que a classe seja instanciada.
  AppColors._();

  // Cores Primárias (baseadas no protótipo)
  static Color primary(Brightness brightness) => brightness == Brightness.dark
      ? Color.fromARGB(255, 6, 43, 146)
      : Color(0xFF2563EB); // Azul principal

  // Cores de Destaque e Ação
  static const Color accent = Color(0xFFF97316); // Laranja para alertas (SLA)
  static const Color success = Color(0xFF22C55E); // Verde para sucesso
  static const Color error = Color(
    0xFFEF4444,
  ); // Vermelho para erros e SLA crítico
  static const Color warning = Color(0xFFF59E0B); // Amarelo para avisos

  // Cores de Fundo
  static Color background(Brightness brightness) =>
      brightness == Brightness.dark
      ? Color(0xFF18181B) // cor para dark
      : Color(0xFFF3F4F6); // cor para light

  static Color surface(Brightness brightness) =>
      brightness == Brightness.dark ? Color(0xFF232326) : Color(0xFFFFFFFF);

  static Color textPrimary(Brightness brightness) => brightness == Brightness.dark
        ? Color(0xFFF3F4F6)
        : Color(0xFF1F2937);

  static const Color textSecondary = Color(
    0xFF6B7280,
  ); // Texto secundário (cinza)
  static const Color textLight = Color(
    0xFFFFFFFF,
  ); // Texto sobre fundos escuros

  // Outras Cores
  static const Color border = Color(
    0xFFE5E7EB,
  ); // Cor da borda de inputs e cards
  static const Color disabled = Color(
    0xFF9CA3AF,
  ); // Cor para elementos desabilitados

  // Cor base para overlays de glassmorphism (usa um tom neutro adaptado ao brilho)
  static Color glassOverlay(Brightness brightness) =>
      brightness == Brightness.dark ? Color(0xFF111217) : Color(0xFFFFFFFF);
}
