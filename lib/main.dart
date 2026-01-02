import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pi_block/blocs/app_bloc_observer.dart';
import 'package:pi_block/blocs/auth/auth_bloc.dart';
import 'package:pi_block/blocs/dashboard/metrics_bloc.dart';
import 'package:pi_block/logging/app_logger.dart';
import 'package:pi_block/pages/appview.dart';
import 'package:pi_block/services/settings_service.dart';
import 'package:pi_block/constants/hive/hive_boxes.dart';
import 'package:pi_block/data/data_provider/pihole_data_provider.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/models/app_settings_model.dart';
import 'package:pi_block/models/session_model.dart';
import 'package:pi_block/models/user_session_model.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(UserSessionModelAdapter());
  Hive.registerAdapter(AppSettingsModelAdapter());
  Hive.registerAdapter(ThemeModeOptionAdapter());

  // Open boxes
  await Hive.openBox<UserSessionModel>(HiveBoxes.userSessions);
  await Hive.openBox<AppSettingsModel>(HiveBoxes.settings);

  runApp(Directionality(textDirection: TextDirection.ltr, child: MainApp()));
  // runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    initTheme();
    AppLogger.init();
    super.initState();
  }

  void initTheme() async {
    ThemeModeOption currentMode = SettingsService()
        .getSettings()
        .themeModeOption;
    themeModeNotifier.value = SettingsService().getThemeMode(currentMode);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      // # Status bar dark color issue
      value: SystemUiOverlayStyle.light,
      child: RepositoryProvider(
        create: (context) => PiholeRepository(PiholeDataProvider()),
        dispose: (repository) => repository.dispose(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(context.read<PiholeRepository>()),
              lazy: false,
            ),

            /// setting up here since this bloc provides data for 4 different widgets
            /// and I can call the event only once here and all widgets have data
            BlocProvider<MetricsBloc>(
              create: (context) =>
                  MetricsBloc(context.read<PiholeRepository>())
                    ..add(LoadMetrics()),
            ),
          ],
          child: AppView(),
        ),
      ),
    );
  }
}
