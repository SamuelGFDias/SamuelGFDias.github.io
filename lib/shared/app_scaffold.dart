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

        return switch (platform) {
          PlatformType.mobile || PlatformType.tablet => MobileScaffold(
            title: title,
            onTitlePressed: onTitlePressed,
            onRefresh: onRefresh,
            actions: actions,
            floatingActionButtons: null,
            navButtons: navButtons,
            body: body,
          ),
          PlatformType.web => WebScaffold(
            title: title,
            onTitlePressed: onTitlePressed,
            navButtons: navButtons,
            actions: actions,
            body: body,
          ),
        };
      },
    );
  }
}
