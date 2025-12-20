import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/auth/auth_bloc.dart';
import 'package:pi_block/data/constants.dart';

class SessionInfoStats extends StatelessWidget {
  const SessionInfoStats({super.key});

  String getSessionExpiresIn(int sessionValidUntil) {
    // Current timestamp
    DateTime currentTimestamp = DateTime.now();

    // Old timestamp (example: 1 hour ago)
    DateTime oldTimestamp = DateTime.fromMillisecondsSinceEpoch(
      sessionValidUntil,
    );

    if (currentTimestamp.millisecondsSinceEpoch >
        oldTimestamp.millisecondsSinceEpoch) {
      return "Session Expired";
    } else {
      // Calculate the difference
      Duration difference = currentTimestamp.difference(oldTimestamp);
      int seconds = difference.inMinutes.abs() * 60;
      int differenceInSeconds = (seconds - difference.inSeconds.abs()).abs();
      return "${difference.inMinutes.abs().toString()} Mins ${differenceInSeconds.toString()} Secs";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: KCardStyle.dashboardCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Session",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                // color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 10),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                Widget widget = SizedBox();
                if (state.status == AuthStateStatus.loggedIn) {
                  widget = Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Server"),
                          Text(
                            '${state.scheme}://${state.server}:${state.port}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Expires In"),
                          Text(
                            getSessionExpiresIn(state.sessionValidUntil),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return widget;
              },
            ),
          ],
        ),
      ),
    );
  }
}
