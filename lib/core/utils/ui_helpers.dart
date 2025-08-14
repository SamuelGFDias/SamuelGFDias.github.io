import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'dart:collection';

class UiHelpers {
  UiHelpers._();

   static final GlobalKey<ScaffoldMessengerState> messageGlobalKey =
      GlobalKey<ScaffoldMessengerState>();

  static final Queue<String> _snackBarQueue = Queue<String>();
  static bool _isShowing = false;
  static String? _lastMessage;

  static void showSnackBar(
    String message, {
    bool isError = false,
  }) {
    if (message.isEmpty) return;
    if (message == _lastMessage) return;
    if (_snackBarQueue.contains(message)) return;

    _snackBarQueue.add(message);
    _lastMessage = message;
    _showNextSnackBar(isError);
  }

  static void _showNextSnackBar(bool isError) {
    if (_isShowing || _snackBarQueue.isEmpty) return;
    _isShowing = true;
    final messenger = UiHelpers.messageGlobalKey.currentState;
    final message = _snackBarQueue.removeFirst();
    messenger?.removeCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
            content: Text(message),
            backgroundColor: isError ? AppColors.error : null,
            behavior: SnackBarBehavior.floating,
          ),
        )
        .closed
        .then((_) {
          _isShowing = false;
          _lastMessage = null;
          if (_snackBarQueue.isNotEmpty) {
            _showNextSnackBar(isError);
          }
        });
  }

  /// Exibe um diálogo de confirmação genérico.
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Confirmar',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
          content: Text(content, style: Theme.of(context).textTheme.bodyMedium),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: Text(confirmText),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    return result ?? false; // Retorna false se o diálogo for dispensado
  }
}
