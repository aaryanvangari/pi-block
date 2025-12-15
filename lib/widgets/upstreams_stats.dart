import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/charts/upstreams_piechart_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/upstreams_model.dart';
import 'package:pi_block/widgets/custom_pie_chart.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/square_card_piechart_widget.dart';

class UpstreamsStats extends StatefulWidget {
  const UpstreamsStats({super.key});

  @override
  State<UpstreamsStats> createState() => _UpstreamsStatsState();
}

class _UpstreamsStatsState extends State<UpstreamsStats> {
  @override
  void initState() {
    super.initState();
    context.read<UpstreamsPiechartBloc>().add(LoadUpstreamsPiechart());
  }

  List<PieData> generateUpstreamsPieData(
    List<Upstream> upstreams,
    int totalQueries,
  ) {
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
          PiUtils.getRandomColor(context),
        );
        pieDataList.add(pieData);
      }
    }
    return pieDataList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpstreamsPiechartBloc, UpstreamsPiechartState>(
      buildWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        if (state is UpstreamsPiechartError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        Widget widget = SizedBox();
        if (state is UpstreamsPiechartError) {
          widget = ErrorCardWidget(
            header: "Upstreams",
            message: "Error loading data",
          );
        } else if (state is UpstreamsPiechartLoading) {
          widget = Center(child: CircularProgressIndicator());
        } else if (state is UpstreamsPiechartLoaded) {
          UpstreamsModel upstreamsModel = state.upstreamsModel;
          List<Upstream> types = upstreamsModel.upstreams;
          var pieDataList = generateUpstreamsPieData(
            types,
            upstreamsModel.totalQueries,
          );
          widget = SquareCardPiechartWidget(
            title: "Upstreams",
            items: pieDataList,
          );
        }
        return widget;
      },
    );
  }
}
