@echo off
echo ========================================
echo   MODO FIRESTORE + FUNCTIONS
echo ========================================
echo.
echo Este modo usa Cloud Functions para validacao
echo Requer plano Blaze (pago) do Firebase
echo Requer functions deployadas
echo.
echo Iniciando app com Functions...
echo.

flutter run -d chrome --dart-define=USE_FIRESTORE=true --dart-define=USE_FUNCTIONS=true

pause
