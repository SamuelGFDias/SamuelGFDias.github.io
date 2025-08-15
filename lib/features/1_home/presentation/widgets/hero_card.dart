import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:portifolio/core/utils/app_colors.dart';

class HeroCard extends StatelessWidget {
  final Map<String, dynamic> content;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  const HeroCard({
    super.key,
    required this.content,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;
    final brightness = theme.brightness;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: isMobile ? 0 : 8,
            sigmaY: isMobile ? 0 : 8,
          ),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.glassOverlay(brightness).withOpacity(0.12),
                  AppColors.glassOverlay(brightness).withOpacity(0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor.withOpacity(0.12)),
            ),
            child: Column(
              children: [
                Text(
                  content["title"] ?? ' - ',
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  content["subtitle"] ?? ' - ',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: onPrimaryPressed,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                      child: Text(content["primaryButton"] ?? 'Ver Projetos'),
                    ),
                    OutlinedButton(
                      onPressed: onSecondaryPressed,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: theme.primaryColor.withOpacity(0.6),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        content["secondaryButton"] ?? 'Entrar em Contato',
                        style: TextStyle(color: theme.primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
