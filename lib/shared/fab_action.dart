import 'package:flutter/material.dart';

class FabAction extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onPressed;
  final String label;

  const FabAction({super.key, this.icon, this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: Text(label),
      icon: icon != null ? Icon(icon) : null,
    );
  }
}
