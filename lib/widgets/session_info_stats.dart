import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/auth/auth_bloc.dart';
import 'package:pi_block/data/constants.dart';

class SessionInfoStats extends StatelessWidget {
  const SessionInfoStats({super.key});

  Stream<DateTime> getTimeStream() {
    return Stream.periodic(Duration(seconds: KTimers.session), (_) => DateTime.now());
  }

  String getSessionExpiresIn(int sessionValidUntil) {
    DateTime expiryTimestamp = DateTime.fromMillisecondsSinceEpoch(
      sessionValidUntil,
    );
    DateTime currentTimestamp = DateTime.now();
    Duration difference = expiryTimestamp.difference(currentTimestamp);

    if (currentTimestamp.isAfter(expiryTimestamp)) {
      return "Session Expired";
    } else {
      return "${difference.inMinutes} Mins ${difference.inSeconds % 60} Secs";
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
                          StreamBuilder(
                            stream: getTimeStream(),
                            builder: (context, asyncSnapshot) {
                              return Text(
                                getSessionExpiresIn(state.sessionValidUntil),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              );
                            }
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
