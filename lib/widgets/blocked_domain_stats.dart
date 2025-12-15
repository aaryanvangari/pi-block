import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/domains_stats/domains_blocked_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/domains_model.dart';
import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/row_with_progressbar.dart';
import 'package:pi_block/widgets/square_card_list_widget.dart';

class BlockedDomainStats extends StatefulWidget {
  const BlockedDomainStats({super.key});

  @override
  State<BlockedDomainStats> createState() => _BlockedDomainStatsState();
}

class _BlockedDomainStatsState extends State<BlockedDomainStats> {
  @override
  void initState() {
    super.initState();
    context.read<DomainsBlockedBloc>().add(
      LoadBlockedDomains(jsonDecode('{"blocked": "true"}')),
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
    return BlocConsumer<DomainsBlockedBloc, DomainsBlockedState>(
      buildWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        if (state is DomainsBlockedError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        Widget widget = SizedBox();
        if (state is DomainsBlockedError) {
          widget = ErrorCardWidget(
            header: "Top Blocked Domains",
            message: "Error loading data",
          );
        } else if (state is DomainsBlockedEmpty) {
          widget = EmptyCardWidget(
            header: "Top Blocked Domains",
            message: "No data",
          );
        } else if (state is DomainsBlockedLoading) {
          widget = Center(child: CircularProgressIndicator());
        } else if (state is DomainsBlockedLoaded) {
          DomainsModel domainsModel = state.domains;
          List<StatDomainModel> domains = domainsModel.domains;
          int totalQueries = domainsModel.blockedQueries;
          var topDomainsList = generateTopClientsData(
            domains,
            totalQueries,
            Color(0xFFb00000),
            true,
          );
          widget = SquareCardListWidget(
            title: "Top Blocked Domains",
            items: topDomainsList,
          );
        }
        return widget;
      },
    );
  }
}
