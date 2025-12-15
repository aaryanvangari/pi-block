import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CustomToggleSwitch extends StatelessWidget {
  final void Function(int) onToggle;
  int initialLabelIndex;
  List<String> labels;
  CustomToggleSwitch({
    super.key,
    required this.onToggle,
    required this.initialLabelIndex,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minWidth: 70.0,
      minHeight: 30.0,
      fontSize: 12.0,
      cornerRadius: 20,
      initialLabelIndex: initialLabelIndex,
      activeBgColor: [Theme.of(context).colorScheme.primary],
      activeFgColor: Theme.of(context).colorScheme.onPrimary,
      inactiveBgColor: Theme.of(context).colorScheme.secondary.withAlpha(100),
      inactiveFgColor: Theme.of(context).colorScheme.onSecondary,
      totalSwitches: labels.length,
      labels: labels,
      onToggle: (index) => onToggle(index!),
    );
  }
}
