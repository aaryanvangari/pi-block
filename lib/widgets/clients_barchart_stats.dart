import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/charts/client_history_barchart_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/models/clients_history_model.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/legend_widget.dart';

class ClientsBarchartStats extends StatefulWidget {
  const ClientsBarchartStats({super.key});

  @override
  State<ClientsBarchartStats> createState() => _ClientsBarchartStatsState();
}

class _ClientsBarchartStatsState extends State<ClientsBarchartStats> {
  @override
  void initState() {
    super.initState();
    context.read<ClientHistoryBarchartBloc>().add(LoadClientHistoryBarchart());
  }

  Map<String, Color> clientColors = {};

  List<Legend> generateClientsLegend(Map<String, ClientInfo> clients) {
    List<Legend> legends = [];
    clients.forEach((key, value) {
      String clientName = (value.name.isEmpty) ? key : value.name;
      Color clientColor = PiUtils.getRandomColor(context);
      clientColors[key] = clientColor;
      legends.add(Legend(clientName, clientColor));
    });

    /// Ading 'others' manually because it does not exists in clients list
    /// but its needed in legends and in bar chart colors
    Color clientColor = PiUtils.getRandomColor(context);
    clientColors["others"] = clientColor;
    legends.add(Legend("Others", clientColor));
    return legends;
  }

  List<BarChartGroupData> generateBarChartData(
    List<ClientHistoryEntry> history,
    double barsWidth,
    double barsSpace,
    int barItemsNeeded,
  ) {
    List<BarChartGroupData> barGroups = [];

    /// We get 145 items of data and we are not interested in all of them
    /// as it does not fit into mobile screen.
    /// So we limit it to maybe 20-25 (barItemsNeeded) depending on screen width.
    /// Sorting by timestamp.millisecondsSinceEpoch didnt work so
    /// Iterating from 145-125 and decreasing one at a time
    for (
      var i = (history.length - 1 - barItemsNeeded);
      i < (history.length);
      i++
    ) {
      ClientHistoryEntry clientHistoryEntry = history[i];
      List<BarChartRodStackItem> rodStackItems = [];
      Map<String, int> clientsHistory = clientHistoryEntry.data;
      int start = 0;
      int total = 0;
      for (var i = 0; i < clientsHistory.keys.length; i++) {
        String key = clientsHistory.keys.elementAt(i);
        int count = clientsHistory[key] ?? 0;
        rodStackItems.add(
          BarChartRodStackItem(
            start.toDouble(),
            (start + count).toDouble(),
            clientColors[key],
          ),
        );
        total = total + count;
        start = start + count;
      }

      barGroups.add(
        BarChartGroupData(
          x: clientHistoryEntry.timestamp.millisecondsSinceEpoch,
          groupVertically: true,
          barsSpace: barsSpace,
          // showingTooltipIndicators: [0, 1, 2, 3],
          barRods: [
            BarChartRodData(
              borderRadius: BorderRadius.circular(2),
              toY: total.toDouble(),
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
    return BlocConsumer<ClientHistoryBarchartBloc, ClientHistoryBarchartState>(
      buildWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        if (state is ClientHistoryBarchartError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        Widget widget = SizedBox();
        if (state is ClientHistoryBarchartError) {
          widget = ErrorCardWidget(
            header: "Client Activity",
            message: "Error loading data",
          );
        } else if (state is ClientHistoryBarchartLoading) {
          widget = Center(child: CircularProgressIndicator());
        } else if (state is ClientHistoryBarchartLoaded) {
          ClientHistoryModel clientHistoryModel = state.clientHistoryModel;
          List<ClientHistoryEntry> history = clientHistoryModel.history;
          Map<String, ClientInfo> clients = clientHistoryModel.clients;
          List<Legend> legends = generateClientsLegend(clients);
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
                      "Client Activity",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  LegendsListWidget(legends: legends),
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
