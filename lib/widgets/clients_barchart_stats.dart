import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/charts/client_history_barchart_bloc.dart';
import 'package:pi_block/components/chart_manager.dart';
import 'package:pi_block/components/color_manager.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/clients_history_model.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/legend_widget.dart';
import 'package:pi_block/widgets/waiting_card_widget.dart';

class ClientsBarchartStats extends StatelessWidget {
  const ClientsBarchartStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ClientHistoryBarchartBloc(context.read<PiholeRepository>())
            ..add(LoadClientHistoryBarchart()),
      child: ClientsBarchartView(),
    );
  }
}

class ClientsBarchartView extends StatefulWidget {
  const ClientsBarchartView({super.key});

  @override
  State<ClientsBarchartView> createState() => _ClientsBarchartViewState();
}

class _ClientsBarchartViewState extends State<ClientsBarchartView> {
  Map<String, Color> clientColors = {};
  Map<String, String> clientNames = {};
  ChartManager chartManager = ChartManager();
  static const _title = "Client Avtivity";

  List<Legend> generateClientsLegend(Map<String, ClientInfo> clients) {
    List<Legend> legends = [];
    bool isDark = PiUtils.getDarkMode(context);
    ColorManager clientColorManager = ColorManager(isDarkMode: isDark);

    clients.forEach((key, value) {
      String clientName = (value.name.isEmpty) ? key : value.name;
      Color clientColor = clientColorManager.getColorForEntity(key);
      clientColors[key] = clientColor;
      clientNames[key] = clientName;
      legends.add(Legend(clientName, clientColor));
    });

    /// Ading 'others' manually because it does not exists in clients list
    /// but its needed in legends and in bar chart colors
    const othersKey = 'others';

    final othersColor = clientColorManager.getColorForEntity(othersKey);
    clientColors[othersKey] = othersColor;
    clientNames[othersKey] = 'Others';
    legends.add(Legend('Others', othersColor));
    return legends;
  }

  List<BarChartGroupData> generateBarChartGroupData(
    List<ClientHistoryEntry> history,
    double barsWidth,
    double barsSpace,
    int barItemsNeeded,
  ) {
    List<BarChartGroupData> barGroups = [];
    final visibleHistory = chartManager.visibleClientHistory(
      history,
      barItemsNeeded,
    );

    for (var i = 0; i < visibleHistory.length; i++) {
      ClientHistoryEntry clientHistoryEntry = visibleHistory[i];
      List<BarChartRodStackItem> rodStackItems = [];
      Map<String, int> clientsHistory = clientHistoryEntry.data;
      int start = 0;
      final total = clientsHistory.values.fold<int>(
        0,
        (sum, value) => sum + value,
      );

      for (final entry in clientsHistory.entries) {
        final key = entry.key;
        final count = entry.value;
        rodStackItems.add(
          BarChartRodStackItem(
            start.toDouble(),
            (start + count).toDouble(),
            clientColors[key]!,
          ),
        );
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

  List<List<TextSpan>> generateBarChartTooltipsData(
    List<ClientHistoryEntry> history,
    double barsWidth,
    double barsSpace,
    int barItemsNeeded,
    Color tooltipTextColor,
  ) {
    List<List<TextSpan>> tooltips = [];
    final visibleHistory = chartManager.visibleClientHistory(
      history,
      barItemsNeeded,
    );

    for (var i = 0; i < visibleHistory.length; i++) {
      ClientHistoryEntry clientHistoryEntry = visibleHistory[i];
      List<TextSpan> tooltipStackItems = [];
      Map<String, int> clientsHistory = clientHistoryEntry.data;
      int total = clientsHistory.values.fold<int>(
        0,
        (sum, value) => sum + value,
      );

      for (final entry in clientsHistory.entries) {
        final key = entry.key;
        final count = entry.value;
        if (count > 0) {
          tooltipStackItems.add(
            chartManager.tooltipLine(
              clientNames[key]!,
              count,
              total,
              clientColors[key]!,
              tooltipTextColor,
            ),
          );
        }
      }

      tooltips.add(tooltipStackItems);
    }
    return tooltips;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientHistoryBarchartBloc, ClientHistoryBarchartState>(
      listener: (context, state) {
        if (state is ClientHistoryBarchartError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is ClientHistoryBarchartError) {
          return const ErrorCardWidget(
            header: _title,
            message: "Error loading data",
          );
        } else if (state is ClientHistoryBarchartLoading) {
          return const WaitingCardWidget(header: _title);
        } else if (state is ClientHistoryBarchartLoaded) {
          ClientHistoryModel clientHistoryModel = state.clientHistoryModel;
          List<ClientHistoryEntry> history = clientHistoryModel.history;
          Map<String, ClientInfo> clients = clientHistoryModel.clients;
          List<Legend> legends = generateClientsLegend(clients);
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
                  LegendsListWidget(legends: legends),
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
