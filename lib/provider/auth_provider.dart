import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:developer';

import 'package:pi_block/components/pi_http_client.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _sid;
  String? _csrf;
  String? _message;
  int? _validity;
  String? _scheme;
  String? _server;
  int? _port;
  int? _sessionValidUntil;
  PiHttpClient piHttpClient = PiHttpClient();

  String? get sid => _sid;
  String? get csrf => _csrf;
  String? get message => _message;
  int? get validity => _validity;
  String? get scheme => _scheme;
  String? get server => _server;
  int? get port => _port;
  int? get sessionValidUntil => _sessionValidUntil;

  bool get isAuthenticated => checkSessionValidity();

  bool checkSessionValidity() {
    int millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    if (_sid != null &&
        ((_sessionValidUntil != null) &&
            (_sessionValidUntil! - millisecondsSinceEpoch) > 0)) {
      return true;
    }
    return false;
  }

  Future<bool> login(Uri uri, String password) async {
    try {
      var body = jsonEncode(<String, String>{'password': password});
      var result = await piHttpClient.post(
        KUrls.auth,
        body,
        uri.scheme,
        uri.host,
        uri.port,
        password,
      );

      PiUtils.handleAPIException(result, true);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "AuthProvider.login",
      );
      _sid = result["session"]["sid"];
      _csrf = result["session"]["csrf"];
      _message = result["session"]["message"];
      _validity = result["session"]["validity"];
      _scheme = uri.scheme;
      _server = uri.host;
      _port = uri.port;
      DateTime time = DateTime.now();
      _sessionValidUntil = time.millisecondsSinceEpoch + (_validity! * 1000);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("sid", _sid!);
      prefs.setString("csrf", _csrf!);
      prefs.setString("message", _message!);
      prefs.setInt("validity", _validity!);
      prefs.setString("scheme", _scheme!);
      prefs.setString("server", _server!);
      prefs.setInt("port", _port!);
      prefs.setInt("sessionValidUntil", _sessionValidUntil!);

      notifyListeners();
      return true;
    } catch (e) {
      log(
        e.toString(),
        level: Level.SEVERE.value,
        name: "AuthProvider.login",
        error: e,
      );
      rethrow;
    }
  }

  Future<void> loadAuthInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString("message");
    prefs.getString("scheme");
    prefs.getString("server");
    prefs.getInt("port");
    prefs.getInt("validity");
    prefs.getInt("sessionValidUntil");
    notifyListeners();
  }

  Future<bool> logout(AuthProvider auth) async {
    try {
      Uri uri = Uri(
        scheme: auth._scheme,
        host: auth._server,
        port: auth._port,
        path: KUrls.auth,
      );
      var response = await piHttpClient.delete(uri, _sid!);

      log(
        response.toString(),
        level: Level.FINE.value,
        name: "AuthProvider.logout",
      );

      if (response.statusCode != 204) {
        final data = jsonDecode(response.body);
        PiUtils.handleAPIException(data, true);
      }

      final prefs = await SharedPreferences.getInstance();

      prefs.setString("sid", "");
      prefs.setString("csrf", "");
      prefs.setString("message", "");
      prefs.setInt("validity", 0);
      prefs.setString("scheme", "");
      prefs.setString("server", "");
      prefs.setInt("port", 0);

      _sid = null;
      _csrf = null;
      _message = null;
      _validity = null;
      _scheme = null;
      _server = null;
      _port = 0;

      notifyListeners();
      return true;
    } catch (e) {
      log(
        e.toString(),
        level: Level.SEVERE.value,
        name: "AuthProvider.logout",
        error: e,
      );
      rethrow;
    }
  }
}
