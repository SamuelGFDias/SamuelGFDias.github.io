import 'package:flutter/material.dart';
import 'package:portifolio/core/utils/responsive_ui.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle appBarTitle(BuildContext context) {
    final isTablet = ResponsiveUI.isTablet(context);
    return TextStyle(
      fontSize: isTablet ? 24 : 18,
      fontWeight: FontWeight.bold,
      color: AppColors.textLight,
    );
  }

  static TextStyle appBarAction(BuildContext context) {
    final isTablet = ResponsiveUI.isTablet(context);
    return TextStyle(
      fontSize: isTablet ? 16 : 14, // Tamanho maior para tablets
      fontWeight: FontWeight.w600, // SemiBold
      color: AppColors.textLight,
    );
  }

  // Estilos para Títulos
  static TextStyle headingLarge(Brightness brightness) {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary(brightness),
    );
  }

  static TextStyle headingMedium(Brightness brightness) {
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary(brightness),
    );
  }

  static TextStyle headingSmall(Brightness brightness) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary(brightness),
    );
  }

  // Estilos para Corpo de Texto
  static TextStyle bodyLarge(Brightness brightness) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary(brightness),
    );
  }

  static TextStyle bodyMedium(Brightness brightness) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary(brightness),
    );
  }

  static TextStyle bodySmall(Brightness brightness) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary(brightness),
    );
  }

  // Estilos para Botões
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
    letterSpacing: 0.5,
  );

  // Estilo para Legendas e Informações menores
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}
