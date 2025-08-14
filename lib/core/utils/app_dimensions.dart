// --------------------------------------------------
// Define espaçamentos, raios de borda e outros valores dimensionais.
// Usar constantes para dimensões cria uma UI mais harmônica e previsível.
// --------------------------------------------------

class AppDimensions {
  AppDimensions._();

  // Espaçamentos (paddings, margins)
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // Raios de Borda (border radius)
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 12.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusFull = 999.0; // Para elementos circulares

  // Elevação (shadows)
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;

  // Tamanho de Ícones
  static const double iconSizeSm = 18.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
}
