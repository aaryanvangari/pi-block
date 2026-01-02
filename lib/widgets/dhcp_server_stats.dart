import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/dashboard/metrics_bloc.dart';
import 'package:pi_block/models/metrics_model.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/widgets/waiting_card_widget.dart';

class DhcpServerStats extends StatelessWidget {
  const DhcpServerStats({super.key});

  @override
  Widget build(BuildContext context) {
    return DhcpServerStatsView();
  }
}

class DhcpServerStatsView extends StatelessWidget {
  const DhcpServerStatsView({super.key});

  static const _title = "DHCP Server Metrics";

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MetricsBloc, MetricsState, SectionState<DhcpMetrics>>(
      selector: (state) => state.dhcp,
      builder: (context, state) {
        switch (state.status) {
          case SectionStatus.loading:
            return const WaitingCardWidget(header: _title);
          case SectionStatus.empty:
            return const EmptyCardWidget(header: _title, message: "No Data");
          case SectionStatus.failure:
            return const ErrorCardWidget(
              header: _title,
              message: "Error loading data",
            );
          case SectionStatus.success:
            DhcpMetrics dhcpMetrics = state.data!;

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
                    const Text(
                      _title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("DHCPDISCOVER"),
                            Text(
                              dhcpMetrics.discover.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("DHCPOFFER"),
                            Text(
                              dhcpMetrics.offer.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("DHCPREQUEST"),
                            Text(
                              dhcpMetrics.request.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("DHCPACK"),
                            Text(
                              dhcpMetrics.ack.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("DHCPNAK"),
                            Text(
                              dhcpMetrics.nak.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("DHCPDECLINE"),
                            Text(
                              dhcpMetrics.decline.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("DHCPINFORM"),
                            Text(
                              dhcpMetrics.inform.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("DHCPRELEASE"),
                            Text(
                              dhcpMetrics.release.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("DHCPNOANSWER"),
                            Text(
                              dhcpMetrics.noanswer.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("BOOTP"),
                            Text(
                              dhcpMetrics.bootp.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("PXE"),
                            Text(
                              dhcpMetrics.pxe.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Allocated / pruned IPv4 leases"),
                            Text(
                              '${dhcpMetrics.leases.allocated4}/${dhcpMetrics.leases.pruned4}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Allocated / pruned IPv6 leases"),
                            Text(
                              '${dhcpMetrics.leases.allocated6}/${dhcpMetrics.leases.pruned6}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
