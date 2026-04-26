import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/teleporter/teleporter_bloc.dart';
import 'package:pi_block/components/global_banner.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/circular_loader_in_button.dart';

class TeleporterPage extends StatelessWidget {
  const TeleporterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TeleporterBloc(context.read<PiholeRepository>()),
        ),
      ],
      child: _TeleporterView(),
    );
  }
}

class _TeleporterView extends StatefulWidget {
  const _TeleporterView();
  @override
  State<_TeleporterView> createState() => _TeleporterViewState();
}

class _TeleporterViewState extends State<_TeleporterView> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              if (width < 500) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      exportWidget(context),
                      const SizedBox(height: 10, width: 10),
                      importWidget(context),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          crossAxisSpacing: 8.0, // Space between columns
                          mainAxisSpacing: 8.0, // Space between rows
                          mainAxisExtent: KGridCardSizes.teleporter["height"]!
                              .toDouble(),
                          maxCrossAxisExtent: KGridCardSizes
                              .teleporter["width"]!
                              .toDouble(),
                        ),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          if (index == 0) return exportWidget(context);
                          return importWidget(context);
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

Widget exportWidget(BuildContext context) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Padding(
      padding: KCardStyle.cardPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                "Export Pi-Hole Configuration",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Note: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'Exported configuration file contains sensitive information so please keep it secure',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: BlocListener<TeleporterBloc, TeleporterState>(
                  listener: (context, state) {
                    if (state.status == TeleporterStateStatus.failure) {
                      PiUtils.handleGeneralException(context, state.error);
                    } else if (state.status == TeleporterStateStatus.success) {
                      GlobalBanner.info(context, state.message, "");
                    }
                  },
                  child: const SizedBox.shrink(),
                ),
              ),
            ],
          ),
          FilledButton(
            onPressed: () {
              context.read<TeleporterBloc>().add(ExportConfiguration());
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Export"),
          ),
        ],
      ),
    ),
  );
}

Widget importWidget(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Padding(
      padding: KCardStyle.cardPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                "Import Pi-Hole Configuration",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Note: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'After import please update gravity for lists to take effect',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          Text(
            "Select what to import:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Form(
            key: formKey,
            child: Builder(
              builder: (context) {
                return BlocConsumer<TeleporterBloc, TeleporterState>(
                  listener: (context, state) {
                    if (state.actionStatus ==
                        TeleporterActionStateStatus.failure) {
                      PiUtils.handleGeneralException(context, state.error);
                    } else if (state.actionStatus ==
                        TeleporterActionStateStatus.success) {
                      GlobalBanner.info(context, state.message, "");
                    }
                  },
                  builder: (context, state) {
                    final isLoading =
                        state.actionStatus ==
                        TeleporterActionStateStatus.loading;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<TeleporterBloc>().add(
                                      ImportFileSelected(),
                                    );
                                  },
                                  child: const Text('Browse'),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    (state.fileName.isEmpty)
                                        ? ""
                                        : state.fileName,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: 3.8,
                              children: [
                                _checkbox(
                                  context,
                                  title: 'Configuration',
                                  value: state.configuration,
                                  onChanged: (v) =>
                                      context.read<TeleporterBloc>().add(
                                        ToggleImportOption('configuration', v),
                                      ),
                                ),
                                _checkbox(
                                  context,
                                  title: 'DHCP leases',
                                  value: state.dhcpLeases,
                                  onChanged: (v) => context
                                      .read<TeleporterBloc>()
                                      .add(ToggleImportOption('dhcpLeases', v)),
                                ),
                                _checkbox(
                                  context,
                                  title: 'Groups',
                                  value: state.groups,
                                  onChanged: (v) => context
                                      .read<TeleporterBloc>()
                                      .add(ToggleImportOption('groups', v)),
                                ),
                                _checkbox(
                                  context,
                                  title: 'Lists',
                                  value: state.lists,
                                  onChanged: (v) => context
                                      .read<TeleporterBloc>()
                                      .add(ToggleImportOption('lists', v)),
                                ),
                                _checkbox(
                                  context,
                                  title: 'Domains / Regexes',
                                  value: state.domainsRegexes,
                                  onChanged: (v) =>
                                      context.read<TeleporterBloc>().add(
                                        ToggleImportOption('domainsRegexes', v),
                                      ),
                                ),
                                _checkbox(
                                  context,
                                  title: 'Clients',
                                  value: state.clients,
                                  onChanged: (v) => context
                                      .read<TeleporterBloc>()
                                      .add(ToggleImportOption('clients', v)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        FilledButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<TeleporterBloc>().add(
                                ImportConfiguration(),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isLoading
                              ? CircularLoaderInButton()
                              : Text("Import"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _checkbox(
  BuildContext context, {
  required String title,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return CheckboxListTile(
    contentPadding: EdgeInsets.zero,
    dense: true,
    visualDensity: VisualDensity.compact,
    title: Text(title),
    value: value,
    onChanged: (v) => onChanged(v ?? false),
  );
}
