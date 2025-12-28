import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:pi_block/blocs/blocking_bloc.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/theme/app_colors.dart';

class BlockingInfoStats extends StatelessWidget {
  const BlockingInfoStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          BlockingBloc(context.read<PiholeRepository>())..add(LoadBlocking()),
      child: const BlockingInfoView(),
    );
  }
}

class BlockingInfoView extends StatefulWidget {
  const BlockingInfoView({super.key});

  @override
  State<BlockingInfoView> createState() => _BlockingInfoViewState();
}

class _BlockingInfoViewState extends State<BlockingInfoView> {
  bool isBlockingEnabled = false;
  bool blockingExpansionTileEnabled = true;
  List blockingTimes = [
    ["10 Seconds", 10],
    ["30 Seconds", 30],
    ["1 Minute", 60],
    ["5 Minutes", 300],
    ["10 Minutes", 600],
    ["30 Minutes", 1800],
    ["1 Hour", 3600],
    ["5 Hours", 18000],
  ];
  ExpansibleController blockingExpansibleController = ExpansibleController();

  @override
  void dispose() {
    blockingExpansibleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        showTrailingIcon: false,
        enabled: blockingExpansionTileEnabled,
        childrenPadding: EdgeInsets.symmetric(
          // horizontal: 10,
          vertical: 5,
        ),
        tilePadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.compact,
        expandedAlignment: Alignment.topLeft,
        collapsedShape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        controller: blockingExpansibleController,
        onExpansionChanged: (value) {
          blockedExpandedStateNotifier.value = value;
        },
        title: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            // vertical: 10,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Blocking",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: blockedTimerNotifier,
                        builder: (context, blockedTimer, child) {
                          return (blockedTimer.inSeconds > 0)
                              ? TimerCountdown(
                                  format:
                                      CountDownTimerFormat.hoursMinutesSeconds,
                                  enableDescriptions: false,
                                  spacerWidth: 5,
                                  endTime: DateTime.now().add(blockedTimer),
                                  onEnd: () {
                                    context.read<BlockingBloc>().add(
                                      LoadBlocking(),
                                    );
                                    blockedTimerNotifier.value = Duration();
                                    blockedExpandedStateNotifier.value = true;
                                    blockedExpandedStateNotifier.value = false;
                                  },
                                )
                              : SizedBox();
                        },
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: blockedExpandedStateNotifier,
                    builder: (context, blockedExpandedState, child) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 26.0),
                        child: Center(
                          child: blockedExpandedState
                              ? Icon(Icons.keyboard_arrow_up, size: 20)
                              : Icon(Icons.keyboard_arrow_down, size: 20),
                        ),
                      );
                    },
                  ),
                  BlocConsumer<BlockingBloc, BlockingState>(
                    listener: (context, state) {
                      if (state is BlockingChangeLoaded) {
                        blockingExpansibleController.collapse();
                      }
                    },
                    builder: (context, state) {
                      bool isBlockingEnabled = false;
                      if (state is BlockingChangeLoaded) {
                        isBlockingEnabled = state.isBlockingEnabled;
                      } else if (state is BlockingLoaded) {
                        isBlockingEnabled = state.isBlockingEnabled;
                      }
                      return Switch(
                        value: isBlockingEnabled,
                        onChanged: (value) => context.read<BlockingBloc>().add(
                          OnBlockingChanged(value, null),
                        ),
                        activeThumbColor: KColors.switchOn,
                        inactiveThumbColor: KColors.switchOff,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0, // Space between columns
                mainAxisSpacing: 8.0, // Space between rows
                childAspectRatio: 1.0,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 8,
              itemBuilder: (context, index) {
                // gradient from green to red using hue
                double hue = 120.0;
                double decrementFactor = (hue / 8).toDouble();
                hue = hue - (decrementFactor * index);
                return GestureDetector(
                  onTap: () {
                    context.read<BlockingBloc>().add(
                      OnBlockingChanged(false, blockingTimes[index][1]),
                    );
                    blockedExpandedStateNotifier.value = false;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: HSVColor.fromAHSV(1.0, hue, 1.0, 0.7).toColor(),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          blockingTimes[index][0],
                          style: TextStyle(
                            fontSize: 18,
                            color: KColors.blockingTimesTitles,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
