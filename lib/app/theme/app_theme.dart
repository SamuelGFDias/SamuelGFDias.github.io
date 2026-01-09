// --------------------------------------------------
// Define o tema global do aplicativo, usando nossas classes utilitárias.
// --------------------------------------------------
import 'package:flutter/material.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_text_styles.dart';
import '../../core/utils/app_dimensions.dart';

class AppTheme {
  AppTheme._();

  static ThemeData theme(BuildContext context, Brightness brightness) {
    return ThemeData(
      primaryColor: AppColors.primary(brightness),
      primaryColorDark: AppColors.primary(brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light),
      brightness: brightness,
      scaffoldBackgroundColor: AppColors.background(brightness),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary(brightness),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textLight),
        titleTextStyle: AppTextStyles.appBarTitle(context),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.hovered)) {
              return AppTextStyles.appBarAction(
                context,
              ).color?.withOpacity(0.8);
            }
            return AppTextStyles.appBarAction(context).color;
          }),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.hovered)) {
              return AppTextStyles.appBarAction(
                context,
              ).color?.withOpacity(0.8);
            }
            return AppTextStyles.appBarAction(context).color;
          }),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
      ),

      tooltipTheme: TooltipThemeData(
        textStyle: AppTextStyles.bodyMedium(
          brightness,
        ).copyWith(color: AppColors.textLight),
        decoration: BoxDecoration(
          color: AppColors.primary(brightness),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        ),
      ),

      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headingLarge(brightness),
        headlineMedium: AppTextStyles.headingMedium(brightness),
        headlineSmall: AppTextStyles.headingSmall(brightness),
        bodyLarge: AppTextStyles.bodyLarge(brightness),
        bodyMedium: AppTextStyles.bodyMedium(brightness),
        bodySmall: AppTextStyles.bodySmall(brightness),
      ),
      // Tema para Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary(brightness),
          foregroundColor: AppColors.textLight,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.md,
            horizontal: AppDimensions.lg,
          ),
        ),
      ),

      // Tema para Cards
      cardTheme: CardThemeData(
        color: AppColors.surface(brightness),
        elevation: AppDimensions.elevationSm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),

      // Tema para Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary(brightness),
        foregroundColor: AppColors.textLight,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primary(brightness),
        contentTextStyle: AppTextStyles.bodyMedium(
          brightness,
        ).copyWith(color: AppColors.textLight),
        behavior: SnackBarBehavior.floating,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        hintStyle: AppTextStyles.bodyMedium(brightness),
        fillColor: AppColors.surface(brightness),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          borderSide: BorderSide(
            color: AppColors.primary(brightness),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      // Outras configurações de tema podem ser adicionadas aqui
    );
  }
}
