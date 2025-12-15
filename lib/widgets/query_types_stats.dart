import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/charts/query_types_piechart_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/summary_model.dart';
import 'package:pi_block/widgets/custom_pie_chart.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/square_card_piechart_widget.dart';

class QueryTypesStats extends StatefulWidget {
  const QueryTypesStats({super.key});

  @override
  State<QueryTypesStats> createState() => _QueryTypesStatsState();
}

class _QueryTypesStatsState extends State<QueryTypesStats> {
  @override
  void initState() {
    super.initState();
    context.read<QueryTypesPiechartBloc>().add(LoadQueryTypesPiechart());
  }

  List<PieData> generateTypesPieData(QueryTypes types) {
    List<PieData> pieDataList = [];
    double total = 0;
    types.toJson().forEach((key, value) {
      total = total + value.toDouble();
    });
    types.toJson().forEach((key, value) {
      if (value > 0) {
        double pieValue = PiUtils.roundDouble(
          (value.toDouble() / total) * 100,
          1,
        );
        PieData pieData = PieData(
          key,
          pieValue,
          PiUtils.getRandomColor(context),
        );
        pieDataList.add(pieData);
      }
    });
    return pieDataList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QueryTypesPiechartBloc, QueryTypesPiechartState>(
      buildWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        if (state is QueryTypesPiechartError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        Widget widget = SizedBox();
        if (state is QueryTypesPiechartError) {
          widget = ErrorCardWidget(
            header: "Query Types",
            message: "Error loading data",
          );
        } else if (state is QueryTypesPiechartLoading) {
          widget = Center(child: CircularProgressIndicator());
        } else if (state is QueryTypesPiechartLoaded) {
          StatsQueryTypes statsQueryTypes = state.statsQueryTypes;
          QueryTypes types = statsQueryTypes.types;
          var pieDataList = generateTypesPieData(types);
          widget = SquareCardPiechartWidget(
            title: "Query Types",
            items: pieDataList,
          );
        }
        return widget;
      },
    );
  }
}
