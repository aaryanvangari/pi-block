import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/charts/query_types_piechart_bloc.dart';
import 'package:pi_block/blocs/stats/stats_bloc.dart';
import 'package:pi_block/components/color_manager.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/summary_model.dart';
import 'package:pi_block/widgets/custom_pie_chart.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/square_card_piechart_widget.dart';
import 'package:pi_block/widgets/waiting_card_widget.dart';

class QueryTypesStats extends StatelessWidget {
  const QueryTypesStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          QueryTypesPiechartBloc(context.read<PiholeRepository>())
            ..add(LoadQueryTypesPiechart()),
      child: BlocListener<StatsBloc, StatsState>(
        listenWhen: (prev, curr) => prev.version != curr.version,
        listener: (context, state) {
          context.read<QueryTypesPiechartBloc>().add(LoadQueryTypesPiechart());
        },
        child: QueryTypesPiechartView(),
      ),
    );
  }
}

class QueryTypesPiechartView extends StatefulWidget {
  const QueryTypesPiechartView({super.key});

  @override
  State<QueryTypesPiechartView> createState() => _QueryTypesPiechartViewState();
}

class _QueryTypesPiechartViewState extends State<QueryTypesPiechartView> {
  static const _title = "Query Types";

  List<PieData> generateTypesPieData(QueryTypes types) {
    bool isDark = PiUtils.getDarkMode(context);
    ColorManager colorManager = ColorManager(isDarkMode: isDark);
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
          colorManager.getColorForEntity(key),
        );
        pieDataList.add(pieData);
      }
    });
    return pieDataList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QueryTypesPiechartBloc, QueryTypesPiechartState>(
      listener: (context, state) {
        if (state is QueryTypesPiechartError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is QueryTypesPiechartError) {
          return const ErrorCardWidget(
            header: _title,
            message: "Error loading data",
          );
        } else if (state is QueryTypesPiechartLoading) {
          return const WaitingCardWidget(header: _title);
        } else if (state is QueryTypesPiechartLoaded) {
          StatsQueryTypes statsQueryTypes = state.statsQueryTypes;
          QueryTypes types = statsQueryTypes.types;
          var pieDataList = generateTypesPieData(types);
          return SquareCardPiechartWidget(title: _title, items: pieDataList);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
