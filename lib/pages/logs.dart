import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/logs/dnsmasq_bloc.dart';
import 'package:pi_block/blocs/logs/ftl_bloc.dart';
import 'package:pi_block/blocs/logs/webserver_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/widgets/dnsmasq_log_view.dart';
import 'package:pi_block/widgets/ftl_log_view.dart';
import 'package:pi_block/widgets/webserver_log_view.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              FtlBloc(context.read<PiholeRepository>())..add(LoadFtl(0)),
        ),
        BlocProvider(
          create: (_) =>
              WebserverBloc(context.read<PiholeRepository>())
                ..add(LoadWebserver(0)),
        ),
        BlocProvider(
          create: (_) =>
              DnsmasqBloc(context.read<PiholeRepository>())
                ..add(LoadDnsmasq(0)),
        ),
      ],
      child: _LogsView(),
    );
  }
}

class _LogsView extends StatefulWidget {
  const _LogsView();
  @override
  State<_LogsView> createState() => _LogsViewState();
}

class _LogsViewState extends State<_LogsView> {
  late DnsmasqBloc _dnsmasqBloc;
  late FtlBloc _ftlBloc;
  late WebserverBloc _webserverBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dnsmasqBloc = context.read<DnsmasqBloc>();
    _ftlBloc = context.read<FtlBloc>();
    _webserverBloc = context.read<WebserverBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Dnsmasq'),
              Tab(text: 'FTL'),
              Tab(text: 'Webserver'),
            ],
          ),
          const Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [DnsmasqLogView(), FtlLogView(), WebserverLogView()],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dnsmasqBloc.add(DisableAutoRefreshDnsmasq());
    _ftlBloc.add(DisableAutoRefreshFtl());
    _webserverBloc.add(DisableAutoRefreshWebserver());
    super.dispose();
  }
}
