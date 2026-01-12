import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pi_block/blocs/dashboard/summary_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/models/summary_model.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/waiting_card_widget.dart';

class SummaryInfoStats extends StatelessWidget {
  const SummaryInfoStats({super.key});

  @override
  Widget build(BuildContext context) {
    return const SummaryInfoStatsView();
  }
}

class SummaryInfoStatsView extends StatelessWidget {
  const SummaryInfoStatsView({super.key});

  static const _title = "Summary";

  static final summaryCards = [
    SummaryCardConfig(
      title: 'Total Queries',
      icon: FontAwesomeIcons.earthAmericas,
      color: KSummaryStatsColors.totalQueries,
      valueBuilder: (s) => s.queries.total.toString(),
    ),
    SummaryCardConfig(
      title: 'Queries Blocked',
      icon: FontAwesomeIcons.hand,
      color: KSummaryStatsColors.queriesBlocked,
      valueBuilder: (s) => s.queries.blocked.toString(),
    ),
    SummaryCardConfig(
      title: 'Percentage Blocked',
      icon: FontAwesomeIcons.chartPie,
      color: KSummaryStatsColors.percentBlocked,
      valueBuilder: (s) => '${s.queries.percentBlocked.toStringAsFixed(2)}%',
    ),
    SummaryCardConfig(
      title: 'Domains on Lists',
      icon: FontAwesomeIcons.list,
      color: KSummaryStatsColors.domainsOnList,
      valueBuilder: (s) => s.gravity.domainsBeingBlocked.toString(),
    ),
  ];

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withAlpha(90)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.3,
                child: Icon(
                  icon,
                  size: 80,
                  color: KSummaryStatsColors.summaryStatIcons,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 30,
                    color: KSummaryStatsColors.summaryStatIcons,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: KSummaryStatsColors.summaryStatIcons,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      color: KSummaryStatsColors.summaryStatIcons,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SummaryBloc, SummaryState>(
      listener: (context, state) {
        if (state.status == SummaryStateStatus.failure) {
          PiUtils.handleGeneralException(context, state.error);
        }
      },
      builder: (context, state) {
        if (state.status == SummaryStateStatus.failure) {
          return const ErrorCardWidget(
            header: _title,
            message: "Error loading data",
          );
        } else if (state.status == SummaryStateStatus.loading) {
          return const WaitingCardWidget(header: _title);
        } else if (state.status == SummaryStateStatus.success) {
          SummaryModel summaryModel = state.summaryModel;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              crossAxisSpacing: 3.0, // Space between columns
              mainAxisSpacing: 3.0, // Space between rows
              mainAxisExtent:
                  KGridCardSizes.dashboardSummary["height"]!, // height
              maxCrossAxisExtent:
                  KGridCardSizes.dashboardSummary["width"]!, // width
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              var card = summaryCards[index];
              return _buildStatCard(
                context,
                title: card.title,
                value: card.valueBuilder(summaryModel),
                icon: card.icon,
                color: card.color,
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class SummaryCardConfig {
  final String title;
  final IconData icon;
  final Color color;
  final String Function(SummaryModel summary) valueBuilder;

  const SummaryCardConfig({
    required this.title,
    required this.icon,
    required this.color,
    required this.valueBuilder,
  });
}
