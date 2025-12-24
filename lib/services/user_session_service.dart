import 'package:hive_flutter/hive_flutter.dart';
import 'package:pi_block/constants/hive/hive_boxes.dart';
import 'package:pi_block/models/user_session_model.dart';

class UserSessionService {
  // Singleton instance
  static final UserSessionService _instance = UserSessionService._internal();
  factory UserSessionService() => _instance;
  UserSessionService._internal();

  UserSessionModel? _cachedSession;

  Box<UserSessionModel> get _box =>
      Hive.box<UserSessionModel>(HiveBoxes.userSessions);

  /// Get session from cache or Hive
  UserSessionModel? getSession() {
    if (_cachedSession != null) return _cachedSession;

    if (_box.isEmpty) return null;

    _cachedSession = _box.get('current_session');
    return _cachedSession;
  }

  /// Save session to cache & Hive
  Future<void> saveSession(UserSessionModel session) async {
    await _box.put('current_session', session);
    _cachedSession = session;
  }

  /// Clear session from cache & Hive
  Future<void> clearSession() async {
    await _box.delete('current_session');
    _cachedSession = null;
  }

  /// Force reload session from Hive (useful after logout/login)
  Future<UserSessionModel?> reloadSession() async {
    _cachedSession = _box.get('current_session');
    return _cachedSession;
  }
}
