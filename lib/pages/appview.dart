import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/blocs/auth/auth_bloc.dart';
import 'package:pi_block/blocs/dashboard/metrics_bloc.dart';
import 'package:pi_block/blocs/domains/domains_bloc.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/router/app_router.dart';
import 'package:pi_block/theme/app_typography.dart';
import 'package:pi_block/theme/theme.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final GoRouter _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Runs only once so single instance, survives theme changes
    _router = AppRouter.create(context.read<AuthBloc>());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// setting up here since this bloc provides data for 4 different widgets
        /// and I can call the event only once here and all widgets have data
        BlocProvider<MetricsBloc>(
          create: (context) =>
              MetricsBloc(context.read<PiholeRepository>())
                ..add(LoadMetrics()),
        ),
        // domains data is being shared by querylog and domains, so initiaing here
        // in querylog we do allow/deny domain and those changes should be reflected
        // Im not doing loadDomains here as its not necessary, I will load them in page
        BlocProvider<DomainsBloc>(
          create: (context) =>
              DomainsBloc(context.read<PiholeRepository>()),
        ),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (context, themeMode, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: MaterialTheme(
              AppTypography.lightTextTheme,
            ).theme(MaterialTheme.lightScheme()),
            darkTheme: MaterialTheme(
              AppTypography.darkTextTheme,
            ).theme(MaterialTheme.darkScheme()),
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
