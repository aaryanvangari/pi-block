import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/dashboard/version_info_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/constants/pihole_urls.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/version_model.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/waiting_card_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionInfoStats extends StatelessWidget {
  const VersionInfoStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          VersionInfoBloc(context.read<PiholeRepository>())
            ..add(LoadVersionInfo()),
      child: const VersionInfoStatsView(),
    );
  }
}

class VersionInfoStatsView extends StatefulWidget {
  const VersionInfoStatsView({super.key});

  @override
  State<VersionInfoStatsView> createState() => _VersionInfoStatsViewState();
}

class _VersionInfoStatsViewState extends State<VersionInfoStatsView> {

  static const _title = "Versions";

  VersionUpdateInfo getUpdateInfo(VersionModel model) {
    final core =
        model.version.core.local.version != model.version.core.remote.version;
    final web =
        model.version.web.local.version != model.version.web.remote.version;
    final ftl =
        model.version.ftl.local.version != model.version.ftl.remote.version;
    final docker = model.version.docker.local != model.version.docker.remote;

    return VersionUpdateInfo(
      updateAvailable: core || web || ftl || docker,
      core: core,
      web: web,
      ftl: ftl,
      docker: docker,
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  TableRow _versionTableRow({
    required String component,
    required String local,
    required String remote,
    String? url,
    bool isHeader = false,
    bool showNewBadge = false,
  }) {
    final textStyle = TextStyle(
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
    );

    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 4,
            right: 2,
            bottom: 4.0,
            left: 4,
          ),
          child: Text(component, style: textStyle),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 4,
            right: 2,
            bottom: 4.0,
            left: 4,
          ),
          child: Text(local, style: textStyle, textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 4,
            right: 2,
            bottom: 4.0,
            left: 4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => isHeader ? {} : _launch(url!),
                child: Text(
                  remote,
                  style: TextStyle(
                    color: isHeader
                        ? Theme.of(context).colorScheme.onSurface
                        : KColors.links,
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (!isHeader && showNewBadge)
                const Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                    right: 2,
                    bottom: 4.0,
                    left: 4,
                  ),
                  child: Icon(
                    Icons.new_releases,
                    size: 15,
                    color: KColors.newVersion,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VersionInfoBloc, VersionInfoState>(
      listener: (context, state) {
        if (state.status == VersionStateStatus.failure) {
          PiUtils.handleGeneralException(context, state.error);
        }
      },
      builder: (context, state) {
        if (state.status == VersionStateStatus.failure) {
          return const ErrorCardWidget(
            header: _title,
            message: "Error loading data",
          );
        } else if (state.status == VersionStateStatus.loading) {
          return const WaitingCardWidget(header: _title);
        } else if (state.status == VersionStateStatus.success) {
          VersionModel versionModel = state.versionModel;
          final updateInfo = getUpdateInfo(versionModel);

          final isUpdateAvailable = updateInfo.updateAvailable;
          final isCoreUpdate = updateInfo.core;
          final isWebUpdate = updateInfo.web;
          final isFtlUpdate = updateInfo.ftl;
          final isDockerUpdate = updateInfo.docker;

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: KCardStyle.dashboardCardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        _title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      isUpdateAvailable
                          ? FilledButton.tonalIcon(
                              label: const Text("New"),
                              onPressed: () => _launch(PiholeUrls.update),
                              icon: const Icon(
                                Icons.new_releases,
                                color: KColors.newVersion,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2), // Component name
                      1: FlexColumnWidth(2), // Local version
                      2: FlexColumnWidth(2), // Remote version
                    },
                    border: TableBorder.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      // Header row
                      _versionTableRow(
                        component: "Component",
                        local: "Local",
                        remote: "Remote",
                        isHeader: true,
                      ),
                      // Core row
                      _versionTableRow(
                        component: "Core",
                        local: versionModel.version.core.local.version,
                        remote: versionModel.version.core.remote.version,
                        showNewBadge: isCoreUpdate,
                        url:
                            '${PiholeUrls.core}/${versionModel.version.core.remote.version}',
                      ),
                      // Web row
                      _versionTableRow(
                        component: "Web",
                        local: versionModel.version.web.local.version,
                        remote: versionModel.version.web.remote.version,
                        showNewBadge: isWebUpdate,
                        url:
                            '${PiholeUrls.web}/${versionModel.version.web.remote.version}',
                      ),
                      // FTL row
                      _versionTableRow(
                        component: "FTL",
                        local: versionModel.version.ftl.local.version,
                        remote: versionModel.version.ftl.remote.version,
                        showNewBadge: isFtlUpdate,
                        url:
                            '${PiholeUrls.ftl}/${versionModel.version.ftl.remote.version}',
                      ),
                      // Docker row
                      _versionTableRow(
                        component: "Docker",
                        local: versionModel.version.docker.local,
                        remote: versionModel.version.docker.remote,
                        showNewBadge: isDockerUpdate,
                        url: PiholeUrls.docker,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class VersionUpdateInfo {
  final bool updateAvailable;
  final bool core;
  final bool web;
  final bool ftl;
  final bool docker;

  const VersionUpdateInfo({
    required this.updateAvailable,
    required this.core,
    required this.web,
    required this.ftl,
    required this.docker,
  });
}
