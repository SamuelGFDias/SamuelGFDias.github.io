import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portifolio/core/utils/app_text_styles.dart';
import 'package:portifolio/shared/fab_action.dart';
import 'package:portifolio/shared/fab_route.dart';

class WebScaffold extends ConsumerWidget {
  final List<FabAction>? actions;
  final List<FabRoute>? navButtons;
  final String title;
  final VoidCallback? onTitlePressed;
  final Widget body;

  const WebScaffold({
    super.key,
    required this.title,
    this.onTitlePressed,
    this.navButtons,
    this.actions,
    required this.body,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionStyle = AppTextStyles.appBarAction(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: onTitlePressed != null
            ? TextButton(
                onPressed: onTitlePressed,
                child: Text(title, style: AppTextStyles.appBarTitle(context)),
              )
            : Text(title),
        actions: [
          for (FabRoute route in navButtons ?? [])
            TextButton(
              onPressed: () {
                final actualRoute = GoRouter.of(
                  context,
                ).routeInformationProvider.value.location;
                if (route.route != null && route.route != actualRoute) {
                  context.go(route.route!);
                } else if (route.onPressed != null) {
                  route.onPressed!();
                }
              },
              child: Text(route.label, style: actionStyle),
            ),

          for (FabAction action in actions ?? [])
            IconButton(
              onPressed: action.onPressed,
              icon: Icon(action.icon),
              tooltip: action.label,
            ),

          const SizedBox(width: 8),
        ],
      ),
      body: body,
    );
  }
}
