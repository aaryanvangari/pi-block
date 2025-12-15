import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/clients_stats/clients_permitted_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/clients_model.dart';
import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/row_with_progressbar.dart';
import 'package:pi_block/widgets/square_card_list_widget.dart';

class PermittedClientStats extends StatefulWidget {
  const PermittedClientStats({super.key});

  @override
  State<PermittedClientStats> createState() => _PermittedClientStatsState();
}

class _PermittedClientStatsState extends State<PermittedClientStats> {
  @override
  void initState() {
    super.initState();
    context.read<ClientsPermittedBloc>().add(
      LoadPermittedClients(jsonDecode('{}')),
    );
  }

  Widget generateTopClientsData(
    List<ClientModel> clients,
    int totalQueries,
    Color progressBarColor,
    bool isBlocked,
  ) {
    ListView listView = ListView.builder(
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

    return listView;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientsPermittedBloc, ClientsPermittedState>(
      buildWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        if (state is ClientsPermittedError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        Widget widget = SizedBox();
        if (state is ClientsPermittedError) {
          widget = ErrorCardWidget(
            header: "Top Clients (Total)",
            message: "Error loading data",
          );
        } else if (state is ClientsPermittedEmpty) {
          widget = EmptyCardWidget(
            header: "Top Clients (Total)",
            message: "No data",
          );
        } else if (state is ClientsPermittedLoading) {
          widget = Center(child: CircularProgressIndicator());
        } else if (state is ClientsPermittedLoaded) {
          ClientsModel clientsModel = state.clients;
          List<ClientModel> clients = clientsModel.clients;
          int totalQueries = clientsModel.totalQueries;
          var topClientsList = generateTopClientsData(
            clients,
            totalQueries,
            Color(0xFF00a65a),
            false,
          );
          widget = SquareCardListWidget(
            title: "Top Clients (Total)",
            items: topClientsList,
          );
        }
        return widget;
      },
    );
  }
}
