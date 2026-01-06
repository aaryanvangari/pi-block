import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/charts/query_history_barchart_bloc.dart';
import 'package:pi_block/blocs/stats/stats_bloc.dart';
import 'package:pi_block/components/chart_manager.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/history_model.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/legend_widget.dart';
import 'package:pi_block/widgets/waiting_card_widget.dart';

class QueriesBarchartStats extends StatelessWidget {
  const QueriesBarchartStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          QueryHistoryBarchartBloc(context.read<PiholeRepository>())
            ..add(LoadQueryHistoryBarchart()),
      child: BlocListener<StatsBloc, StatsState>(
        listenWhen: (prev, curr) => prev.version != curr.version,
        listener: (context, state) {
          context.read<QueryHistoryBarchartBloc>().add(
            LoadQueryHistoryBarchart(),
          );
        },
        child: QueriesBarchartView(),
      ),
    );
  }
}

class QueriesBarchartView extends StatelessWidget {
  QueriesBarchartView({super.key});

  ChartManager chartManager = ChartManager();

  static const _title = "Total Queries";

  List<BarChartGroupData> generateBarChartGroupData(
    List<HistoryEntry> history,
    double barsWidth,
    double barsSpace,
    int barItemsNeeded,
  ) {
    List<BarChartGroupData> barGroups = [];
    final visibleHistory = chartManager.visibleHistory(history, barItemsNeeded);

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
    final visibleHistory = chartManager.visibleHistory(history, barItemsNeeded);

    for (var i = 0; i < visibleHistory.length; i++) {
      HistoryEntry historyItem = visibleHistory[i];
      List<TextSpan> tooltipStackItems = [];

      double total = historyItem.total.toDouble();
      double blocked = historyItem.blocked.toDouble();
      double cached = historyItem.cached.toDouble();
      double forwarded = historyItem.forwarded.toDouble();
      double others = total - (blocked + cached + forwarded);

      tooltipStackItems.add(
        chartManager.tooltipLine(
          'Others',
          others.toInt(),
          total.toInt(),
          KBarChartQueryColors.others,
          tooltipTextColor,
        ),
      );
      tooltipStackItems.add(
        chartManager.tooltipLine(
          'Blocked',
          blocked.toInt(),
          total.toInt(),
          KBarChartQueryColors.blocked,
          tooltipTextColor,
        ),
      );
      tooltipStackItems.add(
        chartManager.tooltipLine(
          'Cached',
          cached.toInt(),
          total.toInt(),
          KBarChartQueryColors.cached,
          tooltipTextColor,
        ),
      );
      tooltipStackItems.add(
        chartManager.tooltipLine(
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
            header: _title,
            message: "Error loading data",
          );
        } else if (state is QueryHistoryBarchartLoading) {
          return const WaitingCardWidget(header: _title);
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
                      _title,
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
                                fitInsideHorizontally: true,
                                fitInsideVertically: true,
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
                                  getTitlesWidget: chartManager.bottomTitles,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: chartManager.leftTitles,
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
