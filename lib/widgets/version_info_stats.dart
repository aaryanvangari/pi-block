import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/dashboard/dashboard_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/models/version_model.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionInfoStats extends StatefulWidget {
  const VersionInfoStats({super.key});

  @override
  State<VersionInfoStats> createState() => _VersionInfoStatsState();
}

class _VersionInfoStatsState extends State<VersionInfoStats> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadVersionInfo());
  }

  Map<String, dynamic> getIsUpdateAvailable(VersionModel versionModel) {
    var coreLocal = versionModel.version.core.local.version;
    var coreRemote = versionModel.version.core.remote.version;
    var webLocal = versionModel.version.web.local.version;
    var webRemote = versionModel.version.web.remote.version;
    var ftlLocal = versionModel.version.ftl.local.version;
    var ftlRemote = versionModel.version.ftl.remote.version;
    var dockerLocal = versionModel.version.docker.local;
    var dockerRemote = versionModel.version.docker.remote;

    bool coreUpdate = false;
    bool webUpdate = false;
    bool ftlUpdate = false;
    bool dockerUpdate = false;
    bool updateAvailable = false;
    if (coreLocal != coreRemote) coreUpdate = true;
    if (webLocal != webRemote) webUpdate = true;
    if (ftlLocal != ftlRemote) ftlUpdate = true;
    if (dockerLocal != dockerRemote) dockerUpdate = true;

    if (coreUpdate || webUpdate || ftlUpdate || dockerUpdate) {
      updateAvailable = true;
    }
    return {
      "update": updateAvailable,
      "core": coreUpdate,
      "web": webUpdate,
      "ftl": ftlUpdate,
      "docker": dockerUpdate,
    };
  }

  Widget _versionRow({
    required String component,
    required String local,
    required String remote,
    required bool header,
    required bool newVersion,
    required String url,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                component,
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                local,
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  }
                },
                child: Text(
                  remote,
                  style: TextStyle(
                    color: header
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.blue,
                    fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              header
                  ? SizedBox()
                  : newVersion
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.new_releases,
                        size: 15,
                        color: Colors.green,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) {
        if ((current is VersionInfoInitial ||
                current is VersionInfoLoaded ||
                current is VersionInfoLoading ||
                current is VersionInfoError) &&
            previous != current) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is VersionInfoError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        Widget widget = SizedBox();
        if (state is VersionInfoError) {
          widget = ErrorCardWidget(
            header: "Versions",
            message: "Error loading data",
          );
        } else if (state is VersionInfoLoading) {
          widget = Center(child: CircularProgressIndicator());
        } else if (state is VersionInfoLoaded) {
          VersionModel versionModel = state.versionModel;
          Map<String, dynamic> newReleasesInfo = getIsUpdateAvailable(
            versionModel,
          );
          bool isUpdateAvailable = newReleasesInfo["update"];
          bool isCoreUpdate = newReleasesInfo["core"];
          bool isWebUpdate = newReleasesInfo["web"];
          bool isFtlUpdate = newReleasesInfo["ftl"];
          bool isDockerUpdate = newReleasesInfo["docker"];

          widget = Card(
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
                      Text(
                        "Versions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          // color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      isUpdateAvailable
                          ? FilledButton.tonalIcon(
                              label: Text("New"),
                              onPressed: () async {
                                if (await canLaunchUrl(
                                  Uri.parse(PiholeUrls.update),
                                )) {
                                  await launchUrl(Uri.parse(PiholeUrls.update));
                                }
                              },
                              icon: Icon(
                                Icons.new_releases,
                                color: Colors.green,
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  SizedBox(height: 10),
                  _versionRow(
                    component: "Component",
                    local: "Local",
                    remote: "Remote",
                    header: true,
                    newVersion: false,
                    url: "",
                  ),
                  SizedBox(height: 5),
                  _versionRow(
                    component: "Core",
                    local: versionModel.version.core.local.version,
                    remote: versionModel.version.core.remote.version,
                    header: false,
                    newVersion: isCoreUpdate,
                    url:
                        '${PiholeUrls.core}/${versionModel.version.core.remote.version}',
                  ),
                  _versionRow(
                    component: "Web",
                    local: versionModel.version.web.local.version,
                    remote: versionModel.version.web.remote.version,
                    header: false,
                    newVersion: isWebUpdate,
                    url:
                        '${PiholeUrls.web}/${versionModel.version.web.remote.version}',
                  ),
                  _versionRow(
                    component: "FTL",
                    local: versionModel.version.ftl.local.version,
                    remote: versionModel.version.ftl.remote.version,
                    header: false,
                    newVersion: isFtlUpdate,
                    url:
                        '${PiholeUrls.ftl}/${versionModel.version.ftl.remote.version}',
                  ),
                  _versionRow(
                    component: "Docker",
                    local: versionModel.version.docker.local,
                    remote: versionModel.version.docker.remote,
                    header: false,
                    newVersion: isDockerUpdate,
                    url: PiholeUrls.docker,
                  ),
                ],
              ),
            ),
          );
        }
        return widget;
      },
    );
  }
}
