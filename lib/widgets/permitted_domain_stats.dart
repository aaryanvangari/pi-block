import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/domains_stats/domains_permitted_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/domains_model.dart';
import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/row_with_progressbar.dart';
import 'package:pi_block/widgets/square_card_list_widget.dart';

class PermittedDomainStats extends StatefulWidget {
  const PermittedDomainStats({super.key});

  @override
  State<PermittedDomainStats> createState() => _PermittedDomainStatsState();
}

class _PermittedDomainStatsState extends State<PermittedDomainStats> {
  @override
  void initState() {
    super.initState();
    context.read<DomainsPermittedBloc>().add(
      LoadPermittedDomains(jsonDecode('{}')),
    );
  }

  Widget generateTopClientsData(
    List<StatDomainModel> domains,
    int totalQueries,
    Color progressBarColor,
    bool isBlocked,
  ) {
    ListView listView = ListView.builder(
      itemCount: domains.length,
      itemBuilder: (context, index) {
        String name = domains[index].domain;
        int count = domains[index].count;
        return RowWithProgressbar(
          title: name,
          count: count,
          total: totalQueries,
          isBlocked: isBlocked,
          progressBarColor: progressBarColor,
        );
      },
    );

    return listView;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DomainsPermittedBloc, DomainsPermittedState>(
      buildWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        if (state is DomainsPermittedError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        Widget widget = SizedBox();
        if (state is DomainsPermittedError) {
          widget = ErrorCardWidget(
            header: "Top Permitted Domains",
            message: "Error loading data",
          );
        } else if (state is DomainsPermittedEmpty) {
          widget = EmptyCardWidget(
            header: "Top Permitted Domains",
            message: "No data",
          );
        } else if (state is DomainsPermittedLoading) {
          widget = Center(child: CircularProgressIndicator());
        } else if (state is DomainsPermittedLoaded) {
          DomainsModel domainsModel = state.domains;
          List<StatDomainModel> domains = domainsModel.domains;
          int totalQueries = domainsModel.totalQueries;
          var topDomainsList = generateTopClientsData(
            domains,
            totalQueries,
            Color(0xFF00a65a),
            false,
          );
          widget = SquareCardListWidget(
            title: "Top Permitted Domains",
            items: topDomainsList,
          );
        }
        return widget;
      },
    );
  }
}
