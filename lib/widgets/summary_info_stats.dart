import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pi_block/blocs/dashboard/dashboard_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/summary_model.dart';
import 'package:pi_block/widgets/error_card_widget.dart';

class SummaryInfoStats extends StatefulWidget {
  const SummaryInfoStats({super.key});

  @override
  State<SummaryInfoStats> createState() => _SummaryInfoStatsState();
}

class _SummaryInfoStatsState extends State<SummaryInfoStats> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadSummaryInfo());
  }

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
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
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
    return BlocConsumer<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) {
        if ((current is SummaryInfoInitial ||
                current is SummaryInfoLoaded ||
                current is SummaryInfoLoading ||
                current is SummaryInfoError) &&
            previous != current) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is SummaryInfoError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        Widget widget = SizedBox();
        if (state is SummaryInfoError) {
          widget = ErrorCardWidget(
            header: "Summary",
            message: "Error loading data",
          );
        } else if (state is SummaryInfoLoading) {
          widget = Center(child: CircularProgressIndicator());
        } else if (state is SummaryInfoLoaded) {
          SummaryModel summaryModel = state.summaryModel;

          widget = GridView.count(
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
                color: Color(0xFF00c0ef),
              ),
              _buildStatCard(
                context,
                title: "Queries Blocked",
                value: summaryModel.queries.blocked.toString(),
                icon: FontAwesomeIcons.hand,
                color: Color(0xFFdd4b39),
              ),
              _buildStatCard(
                context,
                title: "Percentage Blocked",
                value:
                    '${summaryModel.queries.percentBlocked.toStringAsFixed(2)}%',
                icon: FontAwesomeIcons.chartPie,
                color: Color(0xFFf39c12),
              ),
              _buildStatCard(
                context,
                title: "Domains on Lists",
                value: summaryModel.gravity.domainsBeingBlocked.toString(),
                icon: FontAwesomeIcons.list,
                color: Color(0xFF00a65a),
              ),
            ],
          );
        }
        return widget;
      },
    );
  }
}
