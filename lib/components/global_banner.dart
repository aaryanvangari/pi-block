import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/widgets/adaptive_snackbar_card.dart';

class GlobalBanner {
  GlobalBanner._();

  static const Duration infoDuration = Duration(seconds: KTimers.snackbarInfo);
  static const Duration errorDuration = Duration(seconds: KTimers.snackbarError);

  static void info(
    BuildContext context,
    String message,
    String description,
  ) {
    _show(
      context,
      background: Theme.of(context).colorScheme.primary,
      foreground: Theme.of(context).colorScheme.onPrimary,
      message: message,
      description: description,
      duration: infoDuration
    );
  }

  static void error(
    BuildContext context,
    String message,
    String description,
  ) {
    _show(
      context,
      background: Theme.of(context).colorScheme.error,
      foreground: Theme.of(context).colorScheme.onError,
      message: message,
      description: description,
      duration: errorDuration
    );
  }

  static void _show(
    BuildContext context, {
    required Color background,
    required Color foreground,
    required String message,
    required String description,
    required Duration duration,
  }) async {
    final overlay = Overlay.of(context);

     // wait for frame to fully finish
    await SchedulerBinding.instance.endOfFrame;

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + kToolbarHeight + 8,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 350, // this decides the width of notification
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: AdaptiveSnackbarCard(
                      backgroundColor: background,
                      foregroundColor: foreground,
                      message: message,
                      description: description,
                      onClose: () => entry.remove(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);

    Future.delayed(duration, () {
      if (entry.mounted) entry.remove();
    });
  }
}
