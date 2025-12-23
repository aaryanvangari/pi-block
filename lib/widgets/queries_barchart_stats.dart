import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/charts/query_history_barchart_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/history_model.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/legend_widget.dart';

class QueriesBarchartStats extends StatelessWidget {
  const QueriesBarchartStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          QueryHistoryBarchartBloc(context.read<PiholeRepository>())
            ..add(LoadQueryHistoryBarchart()),
      child: QueriesBarchartView(),
    );
  }
}

class QueriesBarchartView extends StatelessWidget {
  const QueriesBarchartView({super.key});

  /// We get 145 items of data and we are not interested in all of them
  /// as it does not fit into mobile screen.
  /// So we limit it to maybe 20-25 (barItemsNeeded) depending on screen width.
  /// Sorting by timestamp.millisecondsSinceEpoch didnt work so
  /// Iterating from 145-125 and decreasing one at a time
  List<HistoryEntry> _visibleHistory(
    List<HistoryEntry> history,
    int barItemsNeeded,
  ) {
    final start = (history.length - 1 - barItemsNeeded).clamp(
      0,
      history.length,
    );
    return history.sublist(start);
  }

  List<BarChartGroupData> generateBarChartGroupData(
    List<HistoryEntry> history,
    double barsWidth,
    double barsSpace,
    int barItemsNeeded,
  ) {
    List<BarChartGroupData> barGroups = [];
    final visibleHistory = _visibleHistory(history, barItemsNeeded);

    for (var i = 0; i < visibleHistory.length; i++) {
      HistoryEntry historyItem = visibleHistory[i];
      List<BarChartRodStackItem> rodStackItems = [];

      double total = historyItem.total.toDouble();
      double blocked = historyItem.blocked.toDouble();
      double cached = historyItem.cached.toDouble();
      double forwarded = historyItem.forwarded.toDouble();
      double others = total - (blocked + cached + forwarded);
      double blockedStart = others;
      double cachedStart = others + blocked;
      double forwardedStart = others + blocked + cached;

      rodStackItems.add(
        BarChartRodStackItem(0, others, KBarChartQueryColors.others),
      );
      rodStackItems.add(
        BarChartRodStackItem(
          blockedStart,
          blockedStart + blocked,
          KBarChartQueryColors.blocked,
        ),
      );
      rodStackItems.add(
        BarChartRodStackItem(
          cachedStart,
          cachedStart + cached,
          KBarChartQueryColors.cached,
        ),
      );
      rodStackItems.add(
        BarChartRodStackItem(
          forwardedStart,
          forwardedStart + forwarded,
          KBarChartQueryColors.forwarded,
        ),
      );

      barGroups.add(
        BarChartGroupData(
          x: historyItem.timestamp.millisecondsSinceEpoch,
          groupVertically: true,
          barsSpace: barsSpace,
          // showingTooltipIndicators: [0, 1, 2, 3],
          barRods: [
            BarChartRodData(
              borderRadius: BorderRadius.circular(2),
              toY: historyItem.total.toDouble(),
              rodStackItems: rodStackItems,
              width: barsWidth,
            ),
          ],
        ),
      );
    }
    return barGroups;
  }

  List<List<TextSpan>> generateBarChartTooltipsData(
    List<HistoryEntry> history,
    double barsWidth,
    double barsSpace,
    int barItemsNeeded,
    Color tooltipTextColor,
  ) {
    List<List<TextSpan>> tooltips = [];
    final visibleHistory = _visibleHistory(history, barItemsNeeded);

    for (var i = 0; i < visibleHistory.length; i++) {
      HistoryEntry historyItem = visibleHistory[i];
      List<TextSpan> tooltipStackItems = [];

      double total = historyItem.total.toDouble();
      double blocked = historyItem.blocked.toDouble();
      double cached = historyItem.cached.toDouble();
      double forwarded = historyItem.forwarded.toDouble();
      double others = total - (blocked + cached + forwarded);

      tooltipStackItems.add(
        _tooltipLine(
          'Others',
          others.toInt(),
          total.toInt(),
          KBarChartQueryColors.others,
          tooltipTextColor,
        ),
      );
      tooltipStackItems.add(
        _tooltipLine(
          'Blocked',
          blocked.toInt(),
          total.toInt(),
          KBarChartQueryColors.blocked,
          tooltipTextColor,
        ),
      );
      tooltipStackItems.add(
        _tooltipLine(
          'Cached',
          cached.toInt(),
          total.toInt(),
          KBarChartQueryColors.cached,
          tooltipTextColor,
        ),
      );
      tooltipStackItems.add(
        _tooltipLine(
          'Forwarded',
          forwarded.toInt(),
          total.toInt(),
          KBarChartQueryColors.forwarded,
          tooltipTextColor,
        ),
      );

      tooltips.add(tooltipStackItems);
    }
    return tooltips;
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

  TextSpan _tooltipLine(
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QueryHistoryBarchartBloc, QueryHistoryBarchartState>(
      listener: (context, state) {
        if (state is QueryHistoryBarchartError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is QueryHistoryBarchartError) {
          return const ErrorCardWidget(
            header: "Total Queries",
            message: "Error loading data",
          );
        } else if (state is QueryHistoryBarchartLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is QueryHistoryBarchartLoaded) {
          HistoryModel historyModel = state.historyModel;
          List<HistoryEntry> history = historyModel.history;
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: KCardStyle.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2,
                    ),
                    child: const Text(
                      "Total Queries",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  LegendsListWidget(
                    legends: [
                      Legend('Others', KBarChartQueryColors.others),
                      Legend('BLocked', KBarChartQueryColors.blocked),
                      Legend('Cached', KBarChartQueryColors.cached),
                      Legend('Forwarded', KBarChartQueryColors.forwarded),
                    ],
                  ),
                  const SizedBox(height: 15),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final barsSpace = 15.0 * constraints.maxWidth / 1000;
                        final barsWidth = 40.0 * constraints.maxWidth / 1000;
                        final itemWidth = (barsSpace + barsWidth).toInt();
                        final chartTooltipWidth = constraints.maxWidth * 0.6;
                        final barItemsNeeded =
                            (constraints.maxWidth / itemWidth).toInt();
                        List<BarChartGroupData> barGroups =
                            generateBarChartGroupData(
                              history,
                              barsWidth,
                              barsSpace,
                              barItemsNeeded,
                            );
                        List<List<TextSpan>> toolTips =
                            generateBarChartTooltipsData(
                              history,
                              barsWidth,
                              barsSpace,
                              barItemsNeeded,
                              Theme.of(context).colorScheme.surface,
                            );
                        return BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.start,
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                maxContentWidth: chartTooltipWidth,
                                getTooltipColor: (group) =>
                                    Theme.of(context).colorScheme.onSurface,
                                tooltipBorderRadius: BorderRadius.circular(8),
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                      final tooltipItems = toolTips[groupIndex];
                                      final total = rod.toY.toInt();

                                      return BarTooltipItem(
                                        textAlign: TextAlign.start,
                                        '',
                                        const TextStyle(), // required but unused
                                        children: [
                                          ...tooltipItems,
                                          const TextSpan(text: '\n'),
                                          TextSpan(
                                            text: 'Total: $total',
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: bottomTitles,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: leftTitles,
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              checkToShowHorizontalLine: (value) =>
                                  value % 10 == 0,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(50),
                                strokeWidth: 1,
                              ),
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(show: false),
                            groupsSpace: barsSpace,
                            barGroups: barGroups,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
