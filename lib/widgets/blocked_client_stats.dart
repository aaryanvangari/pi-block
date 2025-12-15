import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/stats/clients_stats/clients_blocked_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/clients_model.dart';
import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/row_with_progressbar.dart';
import 'package:pi_block/widgets/square_card_list_widget.dart';

class BlockedClientStats extends StatefulWidget {
  const BlockedClientStats({super.key});

  @override
  State<BlockedClientStats> createState() => _BlockedClientStatsState();
}

class _BlockedClientStatsState extends State<BlockedClientStats> {
  @override
  void initState() {
    super.initState();
    context.read<ClientsBlockedBloc>().add(
      LoadBlockedClients(jsonDecode('{"blocked": "true"}')),
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
    return BlocConsumer<ClientsBlockedBloc, ClientsBlockedState>(
      buildWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        if (state is ClientsBlockedError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        Widget widget = SizedBox();
        if (state is ClientsBlockedError) {
          widget = ErrorCardWidget(
            header: "Top Clients (Blocked only)",
            message: "Error loading data",
          );
        } else if (state is ClientsBlockedEmpty) {
          widget = EmptyCardWidget(
            header: "Top Clients (Blocked only)",
            message: "No data",
          );
        } else if (state is ClientsBlockedLoading) {
          widget = Center(child: CircularProgressIndicator());
        } else if (state is ClientsBlockedLoaded) {
          ClientsModel clientsModel = state.clients;
          List<ClientModel> clients = clientsModel.clients;
          int totalQueries = clientsModel.blockedQueries;
          var topClientsList = generateTopClientsData(
            clients,
            totalQueries,
            Color(0xFFb00000),
            true,
          );
          widget = SquareCardListWidget(
            title: "Top Clients (Blocked only)",
            items: topClientsList,
          );
        }
        return widget;
      },
    );
  }
}
