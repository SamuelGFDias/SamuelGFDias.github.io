import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  PermissionHandler._();

  /// Verifica e solicita permissão de acesso ao armazenamento.
  /// Retorna `true` se a permissão for concedida, `false` caso contrário.
  static Future<bool> requestStoragePermission(BuildContext context) async {
    // No Android mais recente, a permissão varia se você quer acessar fotos/vídeos ou todos os arquivos.
    // Para simplificar, vamos solicitar a de fotos, que cobre a maioria dos casos de uso.
    final permission = Permission.photos;

    PermissionStatus status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      status = await permission.request();
      return status.isGranted;
    }

    // Se a permissão foi permanentemente negada, precisamos guiar o usuário
    // para as configurações do aplicativo.
    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Permissão Necessária'),
                content: const Text(
                  'O acesso aos arquivos foi negado permanentemente. Por favor, habilite a permissão nas configurações do aplicativo.',
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: const Text('Abrir Configurações'),
                    onPressed: () {
                      openAppSettings();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
        );
      }
      return false;
    }

    return false;
  }
}
