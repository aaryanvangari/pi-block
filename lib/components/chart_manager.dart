import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pi_block/models/clients_history_model.dart';
import 'package:pi_block/models/history_model.dart';

class ChartManager {

  /// We get 145 items of data and we are not interested in all of them
  /// as it does not fit into mobile screen.
  /// So we limit it to maybe 20-25 (barItemsNeeded) depending on screen width.
  /// Sorting by timestamp.millisecondsSinceEpoch didnt work so
  /// Iterating from 145-125 and decreasing one at a time
  List<ClientHistoryEntry> visibleClientHistory(
    List<ClientHistoryEntry> history,
    int barItemsNeeded,
  ) {
    final start = (history.length - 1 - barItemsNeeded).clamp(
      0,
      history.length,
    );
    return history.sublist(start);
  }

  List<HistoryEntry> visibleHistory(
    List<HistoryEntry> history,
    int barItemsNeeded,
  ) {
    final start = (history.length - 1 - barItemsNeeded).clamp(
      0,
      history.length,
    );
    return history.sublist(start);
  }
  
  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 8);
    DateTime xDateTime = DateTime.fromMillisecondsSinceEpoch(
      (value as num).toInt(),
    );
    String xHourMinText = '${xDateTime.hour}:${xDateTime.minute}';
    return SideTitleWidget(
      meta: meta,
      angle: -90 * 3.14 / 180,
      fitInside: SideTitleFitInsideData(
        enabled: true,
        axisPosition: 0,
        parentAxisSize: 0,
        distanceFromEdge: -15,
      ),
      child: Text(xHourMinText, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(fontSize: 12);
    return SideTitleWidget(
      meta: meta,
      child: Text(meta.formattedValue, style: style),
    );
  }

  String _percent(int value, int total) {
    if (total == 0) return '0%';
    return '${((value / total) * 100).toStringAsFixed(1)}%';
  }

  TextSpan tooltipLine(
    String label,
    int value,
    int total,
    Color color,
    Color textColor,
  ) {
    return TextSpan(
      children: [
        TextSpan(
          text: '$label: ',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        TextSpan(
          text: '$value (${_percent(value, total)})\n',
          style: TextStyle(color: textColor, fontSize: 12),
        ),
      ],
    );
  }
}