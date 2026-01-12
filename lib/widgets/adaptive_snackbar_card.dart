import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdaptiveSnackbarCard extends StatefulWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final String message;
  final String description;
  final VoidCallback onClose;

  const AdaptiveSnackbarCard({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.message,
    required this.description,
    required this.onClose,
  });

  @override
  State<AdaptiveSnackbarCard> createState() => _AdaptiveSnackbarCardState();
}

class _AdaptiveSnackbarCardState extends State<AdaptiveSnackbarCard>
    with SingleTickerProviderStateMixin {
  bool expanded = false;

  Widget buildCupertino(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final radius = isIOS ? 14.0 : 10.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: widget.backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.description.isEmpty
                  ? null
                  : () {
                      HapticFeedback.selectionClick(); // iOS-style subtle tap
                      setState(() => expanded = !expanded);
                    },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.message,
                      maxLines: expanded ? null : 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.foregroundColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (widget.description.isNotEmpty)
                    Icon(
                      expanded
                          ? CupertinoIcons.chevron_up
                          : CupertinoIcons.chevron_down,
                      size: 18,
                      color: widget.foregroundColor.withAlpha(175),
                    ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: widget.onClose,
                    child: Icon(
                      CupertinoIcons.clear_thick,
                      size: 18,
                      color: widget.foregroundColor,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: expanded ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: expanded && widget.description.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          color: widget.foregroundColor.withAlpha(225),
                          fontSize: 13,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMaterial(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final radius = isIOS ? 14.0 : 10.0;
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Container(
        color: widget.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.description.isEmpty
                  ? null
                  : () => setState(() => expanded = !expanded),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.message,
                      maxLines: expanded ? null : 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.foregroundColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (widget.description.isNotEmpty)
                    Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                      color: widget.foregroundColor,
                    ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    iconSize: 18,
                    color: widget.foregroundColor,
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: expanded ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: expanded && widget.description.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          color: widget.foregroundColor,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: isIOS ? buildCupertino(context) : buildMaterial(context),
    );
  }
}
