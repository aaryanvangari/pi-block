import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

/// Gneric multi select dropdown which can deal with dynamic blocs
class CustomMultiSelectDropdown<T> extends StatefulWidget {
  final String hintText;
  final List<T> items;
  final List<T> selectedItems;
  final String Function(T) labelBuilder;
  final ValueChanged<List<T>> onChanged;
  final String? Function(List<T>)? validator;

  const CustomMultiSelectDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.selectedItems,
    required this.labelBuilder,
    required this.onChanged,
    this.validator,
  });

  @override
  State<CustomMultiSelectDropdown<T>> createState() =>
      _CustomMultiSelectDropdownState<T>();
}

class _CustomMultiSelectDropdownState<T>
    extends State<CustomMultiSelectDropdown<T>> {
  late final MultiSelectController<T> _controller;

  @override
  void initState() {
    super.initState();
    _controller = MultiSelectController<T>(widget.selectedItems);
  }

  @override
  void didUpdateWidget(covariant CustomMultiSelectDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller when parent state changes
    if (_controller.value.toSet() != widget.selectedItems.toSet()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Double-check mounted to be safe
        if (!mounted) return;

        _controller.value = List<T>.from(widget.selectedItems);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = MediaQuery.of(context).size.height;
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            final navbarHeight = kBottomNavigationBarHeight;

            /// Use ~50% of visible screen height
            final overlayHeight =
                (screenHeight - bottomInset - navbarHeight) * 0.5;

            return CustomDropdown<T>.multiSelectSearch(
              multiSelectController: _controller,
              items: widget.items,
              hintText: widget.hintText,
              listValidator: widget.validator,
              overlayHeight: overlayHeight,
              decoration: CustomDropdownDecoration(
                searchFieldDecoration: SearchFieldDecoration(
                  fillColor: colorScheme.surface,
                ),
                expandedFillColor: colorScheme.surface,
                closedFillColor: Colors.transparent,
                closedBorder: BoxBorder.all(color: Colors.transparent),
                closedErrorBorder: BoxBorder.all(color: Colors.transparent),
                errorStyle: TextStyle(color: colorScheme.error),
                listItemDecoration: ListItemDecoration(
                  selectedColor: colorScheme.secondaryContainer,
                  highlightColor: colorScheme.onSecondaryContainer,
                ),
                hintStyle: theme.textTheme.bodyLarge,
              ),
              onListChanged: widget.onChanged,
            );
          },
        ),

        const SizedBox(height: 10),

        /// Selected items as chips
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: widget.selectedItems.map((item) {
            return Chip(
              label: Text(widget.labelBuilder(item)),
              onDeleted: () {
                final updated = List<T>.from(widget.selectedItems)
                  ..remove(item);
                widget.onChanged(updated);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
