import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/clients_stats/clients_permitted_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/clients_model.dart';
import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/row_with_progressbar.dart';
import 'package:pi_block/widgets/square_card_list_widget.dart';

class PermittedClientStats extends StatelessWidget {
  const PermittedClientStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ClientsPermittedBloc(context.read<PiholeRepository>())
            ..add(LoadPermittedClients({})),
      child: const PermittedClientsListView(),
    );
  }
}

class PermittedClientsListView extends StatelessWidget {
  const PermittedClientsListView({super.key});

  static const _title = "Top Clients (Total)";

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
    return BlocConsumer<ClientsPermittedBloc, ClientsPermittedState>(
      listener: (context, state) {
        if (state is ClientsPermittedError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is ClientsPermittedError) {
          return const ErrorCardWidget(
            header: _title,
            message: "Error loading data",
          );
        } else if (state is ClientsPermittedEmpty) {
          return const EmptyCardWidget(header: _title, message: "No data");
        } else if (state is ClientsPermittedLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ClientsPermittedLoaded) {
          ClientsModel clientsModel = state.clients;
          List<ClientModel> clients = clientsModel.clients;
          int totalQueries = clientsModel.totalQueries;
          var topClientsList = generateTopClientsData(
            clients,
            totalQueries,
            KProgressBarColors.permitted,
            false,
          );
          return SquareCardListWidget(title: _title, items: topClientsList);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
