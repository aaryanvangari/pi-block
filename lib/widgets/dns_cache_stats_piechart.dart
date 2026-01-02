import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/dashboard/metrics_bloc.dart';
import 'package:pi_block/components/color_manager.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/metrics_model.dart';
import 'package:pi_block/widgets/custom_pie_chart.dart';
import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/square_card_piechart_widget.dart';
import 'package:pi_block/widgets/waiting_card_widget.dart';

class DnsCacheStatsPiechart extends StatelessWidget {
  const DnsCacheStatsPiechart({super.key});

  @override
  Widget build(BuildContext context) {
    return DnsCacheStatsPiechartView();
  }
}

class DnsCacheStatsPiechartView extends StatelessWidget {
  const DnsCacheStatsPiechartView({super.key});

  static const _title = "DNS Cache";

  List<PieData> generateDnsCachePieData(
    DnsCache dnsCache,
    BuildContext context,
  ) {
    bool isDark = PiUtils.getDarkMode(context);
    ColorManager colorManager = ColorManager(isDarkMode: isDark);
    List<PieData> pieDataList = [];
    // int cacheEntries = dnsCache.content.fold<int>(
    //   0,
    //   (sum, cacheEntry) =>
    //       sum + cacheEntry.count.stale + cacheEntry.count.valid,
    // );
    for (var dnsCacheEntry in dnsCache.content) {
      CacheCount cacheCount = dnsCacheEntry.count;
      if (cacheCount.stale > 0) {
        double pieValue = PiUtils.roundDouble(
          ((cacheCount.stale * 100) / dnsCache.size),
          1,
        );
        PieData pieData = PieData(
          '${dnsCacheEntry.name} (stale)',
          pieValue,
          colorManager.getColorForEntity('${dnsCacheEntry.name} (stale)'),
        );
        pieDataList.add(pieData);
      }
      if (cacheCount.valid > 0) {
        double pieValue = PiUtils.roundDouble(
          ((cacheCount.valid * 100) / dnsCache.size),
          1,
        );
        PieData pieData = PieData(
          dnsCacheEntry.name,
          pieValue,
          colorManager.getColorForEntity(dnsCacheEntry.name),
        );
        pieDataList.add(pieData);
      }
    }
    // Empty values should be added but realistically it was 200 odd against 10000
    // So the piechart does not makes sense when all other segments are less than 2%
    // I'm expecting user to understand what they want to see from the piechart without empty values
    
    // Add empty values
    // PieData pieData = PieData(
    //   "Empty",
    //   (dnsCache.size - cacheEntries).toDouble(),
    //   colorManager.getColorForEntity("Empty"),
    // );
    // pieDataList.add(pieData);
    return pieDataList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MetricsBloc, MetricsState, SectionState<DnsCache>>(
      selector: (state) => state.cache,
      builder: (context, state) {
        switch (state.status) {
          case SectionStatus.loading:
            return const WaitingCardWidget(header: _title);
          case SectionStatus.empty:
            return const EmptyCardWidget(header: _title, message: "No Data");
          case SectionStatus.failure:
            return const ErrorCardWidget(
              header: _title,
              message: "Error loading data",
            );
          case SectionStatus.success:
            DnsCache dnsCache = state.data!;
            var pieDataList = generateDnsCachePieData(dnsCache, context);
            return SquareCardPiechartWidget(
              title: _title,
              items: pieDataList,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
