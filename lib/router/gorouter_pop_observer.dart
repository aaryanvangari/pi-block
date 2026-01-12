import 'package:flutter/widgets.dart';

class GoRouterPopObserver extends NavigatorObserver {
  final void Function() onPop;

  GoRouterPopObserver(this.onPop);

  @override
  void didPop(Route route, Route? previousRoute) {
    // observing only pop because others were handled by refreshListenable
    // and pop is not able to be tracked by that so we are observing only that here
    onPop();
  }
}
