import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/charts/upstreams_piechart_bloc.dart';
import 'package:pi_block/components/color_manager.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/upstreams_model.dart';
import 'package:pi_block/widgets/custom_pie_chart.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/square_card_piechart_widget.dart';

class UpstreamsStats extends StatelessWidget {
  const UpstreamsStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          UpstreamsPiechartBloc(context.read<PiholeRepository>())
            ..add(LoadUpstreamsPiechart()),
      child: const UpstreamsPiechartView(),
    );
  }
}

class UpstreamsPiechartView extends StatefulWidget {
  const UpstreamsPiechartView({super.key});

  @override
  State<UpstreamsPiechartView> createState() => _UpstreamsPiechartViewState();
}

class _UpstreamsPiechartViewState extends State<UpstreamsPiechartView> {
  static const _title = "Upstreams";

  List<PieData> generateUpstreamsPieData(
    List<Upstream> upstreams,
    int totalQueries,
  ) {
    bool isDark = PiUtils.getDarkMode(context);
    ColorManager colorManager = ColorManager(isDarkMode: isDark);
    List<PieData> pieDataList = [];
    for (var upstreamItem in upstreams) {
      String name = upstreamItem.name;
      int count = upstreamItem.count;
      if (count > 0) {
        double pieValue = PiUtils.roundDouble(
          (count.toDouble() / totalQueries) * 100,
          1,
        );
        PieData pieData = PieData(
          name,
          pieValue,
          colorManager.getColorForEntity(name),
        );
        pieDataList.add(pieData);
      }
    }
    return pieDataList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpstreamsPiechartBloc, UpstreamsPiechartState>(
      listener: (context, state) {
        if (state is UpstreamsPiechartError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is UpstreamsPiechartError) {
          return const ErrorCardWidget(
            header: _title,
            message: "Error loading data",
          );
        } else if (state is UpstreamsPiechartLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UpstreamsPiechartLoaded) {
          UpstreamsModel upstreamsModel = state.upstreamsModel;
          List<Upstream> types = upstreamsModel.upstreams;
          var pieDataList = generateUpstreamsPieData(
            types,
            upstreamsModel.totalQueries,
          );
          return SquareCardPiechartWidget(title: _title, items: pieDataList);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
