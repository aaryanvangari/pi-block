import 'package:flutter/foundation.dart';

class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(List<Listenable> listenables) {
    for (final l in listenables) {
      l.addListener(notifyListeners);
    }
  }
}
