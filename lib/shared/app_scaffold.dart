import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portifolio/app/providers/platform_provider.dart';
import 'package:portifolio/core/constants/platform_type.dart';
import 'package:portifolio/shared/fab_route.dart';
import 'package:portifolio/shared/mobile_scaffold.dart';
import 'package:portifolio/shared/web_scaffold.dart';

import 'fab_action.dart';

class AppScaffold extends ConsumerWidget {
  final Widget body;
  final String title;
  final VoidCallback? onTitlePressed;
  final Future<void> Function()? onRefresh;
  final List<FabAction>? actions;
  final List<FabRoute>? navButtons;

  const AppScaffold({
    super.key,
    required this.body,
    this.onRefresh,
    this.title = '',
    this.actions,
    this.navButtons,
    this.onTitlePressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final platform = ref.watch(
          platformProvider(constraints.maxWidth, constraints.maxHeight),
        );

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(0, 0.02),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offsetAnim, child: child),
            );
          },
          child: switch (platform) {
            PlatformType.mobile || PlatformType.tablet => MobileScaffold(
              key: ValueKey('mobile_${platform.name}'),
              title: title,
              onTitlePressed: onTitlePressed,
              onRefresh: onRefresh,
              actions: actions,
              floatingActionButtons: null,
              navButtons: navButtons,
              body: body,
            ),
            PlatformType.web => WebScaffold(
              key: ValueKey('web_${platform.name}'),
              title: title,
              onTitlePressed: onTitlePressed,
              navButtons: navButtons,
              actions: actions,
              body: body,
            ),
          },
        );
      },
    );
  }
}
