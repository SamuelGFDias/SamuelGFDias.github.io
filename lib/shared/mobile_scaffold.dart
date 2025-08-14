import 'package:flutter/material.dart';
import 'package:portifolio/core/utils/app_text_styles.dart';
import 'package:portifolio/shared/app_floating_action_buttons.dart';
import 'package:portifolio/shared/app_liquid_refresh_indicator.dart';
import 'package:portifolio/shared/fab_action.dart';
import 'package:portifolio/shared/fab_route.dart';

class MobileScaffold extends StatelessWidget {
  final String title;
  final VoidCallback? onTitlePressed;
  final List<FabAction>? actions;
  final Future<void> Function()? onRefresh;
  final List<FabAction>? floatingActionButtons;
  final List<FabRoute>? navButtons;
  final Widget body;

  const MobileScaffold({
    super.key,
    required this.title,
    this.onTitlePressed,
    this.actions,
    this.onRefresh,
    this.floatingActionButtons,
    this.navButtons,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: onTitlePressed != null
            ? TextButton(
                onPressed: onTitlePressed,
                child: Text(title, style: AppTextStyles.appBarTitle(context)),
              )
            : Text(title),
        actions: [
          for (FabAction action in actions ?? [])
            IconButton(
              onPressed: action.onPressed,
              icon: Icon(action.icon),
              tooltip: action.label,
            ),
          const SizedBox(width: 8),
        ],
      ),
      // 2. O body do Scaffold agora contém o Stack.
      body: Stack(
        children: [
          // 3. O conteúdo principal (com o refresh) é o primeiro item do Stack,
          //    preenchendo todo o espaço do body automaticamente.
          onRefresh != null
              ? AppLiquidRefreshIndicator(onRefresh: onRefresh!, child: body)
              : body,

          // // 4. O painel de filtros é posicionado sobre o conteúdo.
          // //    Sua posição 'top' agora é relativa ao body, não à tela inteira.
          // AnimatedPositioned(
          //   duration: const Duration(milliseconds: 300),
          //   curve: Curves.easeInOut,
          //   top: isFilterPanelVisible ? 0 : -estimatedPanelHeight,
          //   left: 0,
          //   right: 0,
          //   child: const FilterPanel(),
          // ),
        ],
      ),
      floatingActionButton: AppFloatingActionButtons(
        contextualActions: floatingActionButtons,
        navButtons: navButtons,
      ),
    );
  }
}
