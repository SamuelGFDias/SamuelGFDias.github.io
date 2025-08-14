import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:portifolio/shared/fab_route.dart';

import 'fab_action.dart';

class AppFloatingActionButtons extends StatefulWidget {
  final List<FabAction> contextualActions;
  final List<FabRoute>? navButtons;

  const AppFloatingActionButtons({
    super.key,
    List<FabAction>? contextualActions,
    this.navButtons,
  }) : contextualActions = contextualActions ?? const [];

  @override
  State<AppFloatingActionButtons> createState() =>
      _AppFloatingActionButtonsState();
}

class _AppFloatingActionButtonsState extends State<AppFloatingActionButtons> {
  // Variável para armazenar a rota de navegação pendente
  String? _pendingRoute;
  VoidCallback? _pendingCallback;

  @override
  Widget build(BuildContext context) {
    const double mainFabSize = 56.0;
    const double actionFabSize = 56.0; // Tamanho consistente

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.contextualActions.isNotEmpty)
          SpeedDial(
            key: UniqueKey(),
            icon: LucideIcons.zap,
            activeIcon: LucideIcons.x,
            buttonSize: const Size(actionFabSize, actionFabSize),
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[800],
            heroTag: 'contextual_actions_fab',
            overlayColor: Colors.transparent,
            overlayOpacity: 0,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 200),
            children: widget.contextualActions
                .map(
                  (action) => SpeedDialChild(
                    child: Center(child: Icon(action.icon)),
                    label: action.label,
                    onTap: action.onPressed,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey[800],
                  ),
                )
                .toList(),
          ),

        if (widget.contextualActions.isNotEmpty) const SizedBox(height: 16.0),

        SpeedDial(
          key: UniqueKey(),
          icon: LucideIcons.menu,
          activeIcon: LucideIcons.x,
          buttonSize: const Size(mainFabSize, mainFabSize),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          heroTag: 'main_menu_fab',
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 200),
          // CORREÇÃO: A lógica de navegação agora está no onClose.
          onClose: () {
            // Se houver uma rota pendente, navega para ela.
            final actualRoute = GoRouter.of(
              context,
              // ignore: deprecated_member_use
            ).routeInformationProvider.value.location;
            if (_pendingRoute != null &&
                mounted &&
                actualRoute != _pendingRoute) {
              context.go(_pendingRoute!);
            } else if (_pendingCallback != null) {
              _pendingCallback!();
            }
          },
          children: [
            for (FabRoute route in widget.navButtons ?? [])
              _buildNavChild(route.icon, route.label, route.route, route.onPressed),
          ],
        ),
      ],
    );
  }

  SpeedDialChild _buildNavChild(IconData icon, String label, String? route, VoidCallback? onTap) {
    return SpeedDialChild(
      child: Center(child: Icon(icon)),
      label: label,
      onTap: () {
        // CORREÇÃO: Apenas define a rota pendente. A navegação real
        // acontecerá no callback `onClose` do SpeedDial principal.
        setState(() {
          _pendingRoute = route;
          _pendingCallback = onTap;
        });
      },
      backgroundColor: Colors.white,
      foregroundColor: Colors.grey[800],
    );
  }
}
