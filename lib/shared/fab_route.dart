import 'package:flutter/material.dart';

class FabRoute {
  final IconData icon;
  final String label;
  final String? route;
  final VoidCallback? onPressed;

  FabRoute({
    required this.icon,
    required this.label,
    this.route,
    this.onPressed,
  }) : assert(route != null || onPressed != null,
            'Você deve fornecer uma rota ou uma função onPressed'),
        assert(!(route != null && onPressed != null),
            'Você não pode fornecer ambos: rota e onPressed');
}
