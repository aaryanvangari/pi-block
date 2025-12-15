import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/charts/query_history_barchart_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/models/history_model.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/legend_widget.dart';

class QueriesBarchartStats extends StatefulWidget {
  const QueriesBarchartStats({super.key});

  @override
  State<QueriesBarchartStats> createState() => _QueriesBarchartStatsState();
}

class _QueriesBarchartStatsState extends State<QueriesBarchartStats> {
  @override
  void initState() {
    super.initState();
    context.read<QueryHistoryBarchartBloc>().add(LoadQueryHistoryBarchart());
  }

  List<BarChartGroupData> generateBarChartData(
    List<HistoryEntry> history,
    double barsWidth,
    double barsSpace,
    int barItemsNeeded,
  ) {
    List<BarChartGroupData> barGroups = [];
    for (
      var i = (history.length - 1 - barItemsNeeded);
      i < (history.length);
      i++
    ) {
      HistoryEntry historyItem = history[i];
      List<BarChartRodStackItem> rodStackItems = [];

      double total = historyItem.total.toDouble();
      double blocked = historyItem.blocked.toDouble();
      double cached = historyItem.cached.toDouble();
      double forwarded = historyItem.forwarded.toDouble();
      double others = total - (blocked + cached + forwarded);
      double blockedStart = others;
      double cachedStart = others + blocked;
      double forwardedStart = others + blocked + cached;
      rodStackItems.add(BarChartRodStackItem(0, others, Colors.grey));
      rodStackItems.add(
        BarChartRodStackItem(
          blockedStart,
          blockedStart + blocked,
          const Color.fromARGB(255, 211, 81, 72).withAlpha(250),
        ),
      );
      rodStackItems.add(
        BarChartRodStackItem(
          cachedStart,
          cachedStart + cached,
          const Color.fromARGB(255, 35, 176, 241).withAlpha(200),
        ),
      );
      rodStackItems.add(
        BarChartRodStackItem(
          forwardedStart,
          forwardedStart + forwarded,
          const Color.fromARGB(255, 160, 205, 109).withAlpha(200),
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

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 8);
    DateTime xDateTime = DateTime.fromMillisecondsSinceEpoch(
      (value as num).toInt(),
    );
    String xHourMinText = '${xDateTime.hour}:${xDateTime.minute}';
    return SideTitleWidget(
      meta: meta,
      angle: 99,
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QueryHistoryBarchartBloc, QueryHistoryBarchartState>(
      buildWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        if (state is QueryHistoryBarchartError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        Widget widget = SizedBox();
        if (state is QueryHistoryBarchartError) {
          widget = ErrorCardWidget(
            header: "Total Queries",
            message: "Error loading data",
          );
        } else if (state is QueryHistoryBarchartLoading) {
          widget = Center(child: CircularProgressIndicator());
        } else if (state is QueryHistoryBarchartLoaded) {
          HistoryModel historyModel = state.historyModel;
          List<HistoryEntry> history = historyModel.history;
          widget = Card(
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
                    child: Text(
                      "Total Queries",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  LegendsListWidget(
                    legends: [
                      Legend('Others', Colors.grey),
                      Legend('BLocked', Colors.red),
                      Legend('Cached', Colors.blue),
                      Legend('Forwarded', Colors.green),
                    ],
                  ),
                  SizedBox(height: 15),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final barsSpace = 15.0 * constraints.maxWidth / 1000;
                        final barsWidth = 40.0 * constraints.maxWidth / 1000;
                        final itemWidth = (barsSpace + barsWidth).toInt();
                        final barItemsNeeded =
                            (constraints.maxWidth / itemWidth).toInt();
                        List<BarChartGroupData> barGroups =
                            generateBarChartData(
                              history,
                              barsWidth,
                              barsSpace,
                              barItemsNeeded,
                            );
                        return BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.start,
                            // barTouchData: BarTouchData(enabled: false),
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
        return widget;
      },
    );
  }
}
