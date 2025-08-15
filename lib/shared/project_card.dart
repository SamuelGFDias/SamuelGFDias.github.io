import 'dart:ui';
import 'package:flutter/material.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final bool enableBlurFallback;
  final String? id;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    this.enableBlurFallback = true,
    this.id,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  static final ValueNotifier<String?> _hoveredId = ValueNotifier<String?>(null);

  void _onEnter(PointerEvent _) {
    _hoveredId.value = widget.id ?? widget.title;
  }

  void _onExit(PointerEvent _) {
    // remove hover after leaving
    _hoveredId.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;
    final useBlur = widget.enableBlurFallback && !isMobile;
    final blurSigma = useBlur ? 8.0 : 0.0;

    return ValueListenableBuilder<String?>(
      valueListenable: _hoveredId,
      builder: (context, hoveredId, child) {
        final isActive =
            hoveredId == null || hoveredId == (widget.id ?? widget.title);
        final isHighlighted =
            hoveredId != null && hoveredId == (widget.id ?? widget.title);

        return MouseRegion(
          onEnter: _onEnter,
          onExit: _onExit,
          cursor: isMobile
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isActive ? 1.0 : 0.6,
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              transform: isHighlighted /*&& !isMobile */
                  ? (Matrix4.identity()
                      ..translate(0, -6)
                      ..scale(1.01))
                  : Matrix4.identity(),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: isHighlighted
                      ? theme.primaryColor
                      : theme.dividerColor.withOpacity(0.2),
                  width: isHighlighted ? 2.0 : 1.0,
                ),
                color: Colors.transparent,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurSigma,
                    sigmaY: blurSigma,
                  ),
                  child: Container(
                    color: theme.cardColor.withOpacity(0.09),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.description,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
