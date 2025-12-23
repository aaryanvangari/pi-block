import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/clients_stats/clients_blocked_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/clients_model.dart';
import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/row_with_progressbar.dart';
import 'package:pi_block/widgets/square_card_list_widget.dart';

class BlockedClientStats extends StatelessWidget {
  const BlockedClientStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ClientsBlockedBloc(context.read<PiholeRepository>())
            ..add(LoadBlockedClients({"blocked": "true"})),
      child: const BlockedClientsListView(),
    );
  }
}

class BlockedClientsListView extends StatelessWidget {
  const BlockedClientsListView({super.key});

  static const _title = "Top Clients (Blocked only)";

  Widget generateTopClientsData(
    List<ClientModel> clients,
    int totalQueries,
    Color progressBarColor,
    bool isBlocked,
  ) {
    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, index) {
        String name = clients[index].name;
        int count = clients[index].count;
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
    return BlocConsumer<ClientsBlockedBloc, ClientsBlockedState>(
      listener: (context, state) {
        if (state is ClientsBlockedError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is ClientsBlockedError) {
          return const ErrorCardWidget(
            header: _title,
            message: "Error loading data",
          );
        } else if (state is ClientsBlockedEmpty) {
          return const EmptyCardWidget(header: _title, message: "No data");
        } else if (state is ClientsBlockedLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ClientsBlockedLoaded) {
          ClientsModel clientsModel = state.clients;
          List<ClientModel> clients = clientsModel.clients;
          int totalQueries = clientsModel.blockedQueries;
          var topClientsList = generateTopClientsData(
            clients,
            totalQueries,
            KProgressBarColors.blocked,
            true,
          );
          return SquareCardListWidget(title: _title, items: topClientsList);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
