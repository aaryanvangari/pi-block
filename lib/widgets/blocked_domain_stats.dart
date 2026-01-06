import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/domains_stats/domains_blocked_bloc.dart';
import 'package:pi_block/blocs/stats/stats_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/domains_model.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/row_with_progressbar.dart';
import 'package:pi_block/widgets/square_card_list_widget.dart';
import 'package:pi_block/widgets/waiting_card_widget.dart';

class BlockedDomainStats extends StatelessWidget {
  const BlockedDomainStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DomainsBlockedBloc(context.read<PiholeRepository>())
            ..add(LoadBlockedDomains({"blocked": "true"})),
      child: BlocListener<StatsBloc, StatsState>(
        listenWhen: (prev, curr) => prev.version != curr.version,
        listener: (context, state) {
          context.read<DomainsBlockedBloc>().add(
            LoadBlockedDomains({"blocked": "true"}),
          );
        },
        child: BlockedDomainsListView(),
      ),
    );
  }
}

class BlockedDomainsListView extends StatelessWidget {
  const BlockedDomainsListView({super.key});

  static const _title = "Top Blocked Domains";

  Widget generateTopClientsData(
    List<StatDomainModel> domains,
    int totalQueries,
    Color progressBarColor,
    bool isBlocked,
  ) {
    return ListView.builder(
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DomainsBlockedBloc, DomainsBlockedState>(
      listener: (context, state) {
        if (state is DomainsBlockedError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is DomainsBlockedError) {
          return const ErrorCardWidget(
            header: _title,
            message: "Error loading data",
          );
        } else if (state is DomainsBlockedEmpty) {
          return const EmptyCardWidget(header: _title, message: "No data");
        } else if (state is DomainsBlockedLoading) {
          return const WaitingCardWidget(header: _title);
        } else if (state is DomainsBlockedLoaded) {
          DomainsModel domainsModel = state.domains;
          List<StatDomainModel> domains = domainsModel.domains;
          int totalQueries = domainsModel.blockedQueries;
          var topDomainsList = generateTopClientsData(
            domains,
            totalQueries,
            KProgressBarColors.blocked,
            true,
          );
          return SquareCardListWidget(title: _title, items: topDomainsList);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
