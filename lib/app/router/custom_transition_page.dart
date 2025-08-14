import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSlideTransitionPage extends CustomTransitionPage<void> {
  CustomSlideTransitionPage({required super.child, super.key})
    : super(
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Define a posição inicial (embaixo) e final (centro) da tela.
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          // Define a curva de animação para uma aceleração e desaceleração suaves.
          const curve = Curves.ease;

          // Cria um "tween" que interpola entre a posição inicial e final.
          // O 'chain' combina o movimento com a curva de animação.
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          // Usa o SlideTransition para aplicar a animação à tela filha.
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
}
