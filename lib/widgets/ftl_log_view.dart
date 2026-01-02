import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pi_block/blocs/logs/ftl_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/log_model.dart';
import 'package:pi_block/models/logs_model.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/empty_widget.dart';

class FtlLogView extends StatefulWidget {
  const FtlLogView({super.key});

  @override
  State<FtlLogView> createState() => _FtlLogViewState();
}

class _FtlLogViewState extends State<FtlLogView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget getLogPriority(BuildContext context, String? priority) {
    final scheme = Theme.of(context).colorScheme;

    final normalized = switch (priority) {
      'ERR' || 'ERROR' || 'EMERG' || 'ALERT' || 'CRIT' => 'ERROR',
      'WARN' || 'WARNING' => 'WARNING',
      'INFO' => 'INFO',
      _ => null,
    };

    final color =
        {
          'INFO': KLogsColors.info,
          'WARNING': KLogsColors.warning,
          'ERROR': KLogsColors.error,
        }[normalized] ??
        scheme.onSurface;

    return Text(
      priority ?? '',
      style: TextStyle(color: color, fontWeight: FontWeight.w500),
    );
  }

  Widget _logRow(LogModel logModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getLogPriority(context, logModel.prio),
              (logModel.prio != null)
                  ? const SizedBox(width: 8)
                  : const SizedBox.shrink(),
              Text(
                DateFormat(
                  'yyyy-MM-dd HH:mm:ss.SSS',
                ).format(logModel.timestamp.toLocal()),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(logModel.message, textAlign: TextAlign.left, softWrap: true),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<FtlBloc, FtlState>(
      listener: (context, state) {
        if (state.status == FtlStateStatus.failure) {
          PiUtils.handleGeneralException(context, "An Error Occured");
        }
      },
      builder: (context, state) {
        if (state.status == FtlStateStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == FtlStateStatus.failure) {
          return const CustomErrorWidget(message: "Error loading data");
        } else if (state.logsModel.isEmpty) {
          return const Center(child: EmptyWidget(message: "No data"));
        } else if (state.status == FtlStateStatus.success) {
          LogsModel logsModel = state.logsModel;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "FTL",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              logsModel.file,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          tooltip: "Auto Refresh",
                          onPressed: () {
                            context.read<FtlBloc>().add(
                              state.autoRefreshOn
                                  ? DisableAutoRefreshFtl()
                                  : AutoRefreshFtl(),
                            );
                          },
                          icon: Icon(Icons.autorenew, size: 24),
                          visualDensity: VisualDensity.compact,
                          color: state.autoRefreshOn
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).disabledColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: logsModel.log.length,
                  itemBuilder: (context, index) {
                    var selectedPageItem = logsModel.log[index];
                    return _logRow(selectedPageItem);
                  },
                  padding: EdgeInsets.all(10),
                  separatorBuilder: (context, index) {
                    return KDivider.listDivider;
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
