import 'package:flutter/material.dart';

class FabAction {
  final IconData? icon;
  final VoidCallback onPressed;
  final String label;

  FabAction({this.icon, required this.onPressed, required this.label});
}
