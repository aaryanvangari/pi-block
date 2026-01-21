import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:pi_block/constants/constants.dart';

class LayoutService {
  static const double _reservedHeight = 80;
  static const double _reservedWidth = 30;
  // Since they are not changing in different screen resolutions
  // Hardcoded using flutter devtools
  // height of individual row in mobile view
  // depends on widgets we have on row for each entity
  static const Map<String, double> _rowHeights = {
    "querylog": 71.0,
    "devices": 85.0,
  };

  int calculatePagesPerView({
    required double availableWidth,
    required double reservedWidth,
  }) {
    double pagerButtonWidth = 40;
    switch (Platform.operatingSystem) {
      case "ios":
        // depends on minimum tap area or something, it differs from android to iOS
        // we can bypass and make it 40 or less but its better to follow iOS design language
        pagerButtonWidth = 48;
        break;
      case "android":
        pagerButtonWidth = 40;
        break;
      default:
    }
    double pagerNumberButtonWidth = 56;
    switch (Platform.operatingSystem) {
      case "ios":
        pagerNumberButtonWidth = 64;
        break;
      case "android":
        pagerNumberButtonWidth = 56;
        break;
      default:
    }
    const int mandatoryButtonsCount = 4;
    const int maxPagesView = 5;

    final double mandatoryWidth = mandatoryButtonsCount * pagerButtonWidth;

    final double remainingWidth =
        availableWidth - mandatoryWidth - reservedWidth;

    if (remainingWidth <= pagerNumberButtonWidth) {
      return 1;
    }

    final int maxButtons = (remainingWidth / pagerNumberButtonWidth).floor();

    return maxButtons.clamp(1, maxPagesView);
  }

  int calculateGridColumns({
    required double availableWidth,
    required double minItemWidth,
    required double spacing,
    int minColumns = 1,
    int maxColumns = 6,
  }) {
    final usableWidth = availableWidth + spacing;
    final columns = (usableWidth / (minItemWidth + spacing)).floor();
    return columns.clamp(minColumns, maxColumns);
  }

  int calculateRowsPerPage({
    required double availableHeight,
    required double itemHeight,
    required double spacing,
    int minRows = 1,
  }) {
    final usableHeight = availableHeight + spacing;
    return (usableHeight / (itemHeight + spacing)).floor().clamp(minRows, 100);
  }

  int calculateItemsPerPageGrid({
    required double availableWidth,
    required double availableHeight,
    required double itemWidth,
    required double itemHeight,
    double spacing = 8,
  }) {
    final columns = calculateGridColumns(
      availableWidth: availableWidth,
      minItemWidth: itemWidth,
      spacing: spacing,
    );

    final rows = calculateRowsPerPage(
      availableHeight: availableHeight,
      itemHeight: itemHeight,
      spacing: spacing,
    );

    return columns * rows;
  }

  int calculateItemsPerPage({
    required double availableHeight,
    required double reservedHeight,
    required double rowHeight,
    int minItems = 1,
    int maxItems = 100,
  }) {
    final double usableHeight = availableHeight - reservedHeight;

    if (usableHeight <= 0 || rowHeight <= 0) {
      return minItems;
    }

    return (usableHeight / rowHeight).floor().clamp(minItems, maxItems);
  }

  double getItemSizes(String entityType, String dimension) {
    if (entityType == "querylog") {
      if (dimension == "width") {
        return KGridCardSizes.querylog["height"]!.toDouble() * 1.25;
      } else {
        return KGridCardSizes.querylog["height"]!.toDouble();
      }
    } else if (entityType == "devices") {
      if (dimension == "width") {
        return KGridCardSizes.devices["height"]!.toDouble() * 1.25;
      } else {
        return KGridCardSizes.devices["height"]!.toDouble();
      }
    }
    return 0;
  }

  PaginationInfo getPaginationInfo(
    BoxConstraints constraints,
    String entityType,
  ) {
    final isGrid = constraints.maxWidth >= 500;
    final itemsPerPage = isGrid
        ? calculateItemsPerPageGrid(
            availableWidth: constraints.maxWidth - _reservedWidth,
            availableHeight: constraints.maxHeight - _reservedHeight,
            itemWidth: getItemSizes(entityType, "width"),
            itemHeight: getItemSizes(entityType, "height"),
          )
        : calculateItemsPerPage(
            availableHeight: constraints.maxHeight,
            reservedHeight: _reservedHeight,
            rowHeight: _rowHeights[entityType]!,
          );
    final pagesPerView = calculatePagesPerView(
      availableWidth: constraints.maxWidth,
      reservedWidth: _reservedWidth,
    );
    PaginationInfo paginationInfo = PaginationInfo(itemsPerPage, pagesPerView);
    return paginationInfo;
  }
}

class PaginationInfo {
  int itemsPerPage;
  int pagesPerView;
  PaginationInfo(this.itemsPerPage, this.pagesPerView);
}
