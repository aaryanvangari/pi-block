import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pi_block/blocs/dashboard/summary_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/summary_model.dart';
import 'package:pi_block/widgets/error_card_widget.dart';

class SummaryInfoStats extends StatelessWidget {
  const SummaryInfoStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SummaryBloc(context.read<PiholeRepository>())..add(LoadSummary()),
      child: const SummaryInfoStatsView(),
    );
  }
}

class SummaryInfoStatsView extends StatelessWidget {
  const SummaryInfoStatsView({super.key});

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
                child: Icon(icon, size: 80, color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 30, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
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
            header: "Summary",
            message: "Error loading data",
          );
        } else if (state.status == SummaryStateStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == SummaryStateStatus.success) {
          SummaryModel summaryModel = state.summaryModel;

          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 1.1,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                context,
                title: "Total Queries",
                value: summaryModel.queries.total.toString(),
                icon: FontAwesomeIcons.earthAmericas,
                color: KSummaryStatsColors.totalQueries,
              ),
              _buildStatCard(
                context,
                title: "Queries Blocked",
                value: summaryModel.queries.blocked.toString(),
                icon: FontAwesomeIcons.hand,
                color: KSummaryStatsColors.queriesBlocked,
              ),
              _buildStatCard(
                context,
                title: "Percentage Blocked",
                value:
                    '${summaryModel.queries.percentBlocked.toStringAsFixed(2)}%',
                icon: FontAwesomeIcons.chartPie,
                color: KSummaryStatsColors.percentBlocked,
              ),
              _buildStatCard(
                context,
                title: "Domains on Lists",
                value: summaryModel.gravity.domainsBeingBlocked.toString(),
                icon: FontAwesomeIcons.list,
                color: KSummaryStatsColors.domainsOnList,
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
