import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:pi_block/services/user_session_service.dart';
import 'package:pi_block/models/user_session_model.dart';

class PiHttpClient {
  final http.Client _httpClient;

  PiHttpClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  dynamic get(String urlEndpoint, {dynamic queryParams}) async {
    dynamic result;
    try {
      UserSessionModel? userSessionModel = UserSessionService().getSession();
      String scheme = userSessionModel!.serverUri.scheme;
      String server = userSessionModel.serverUri.host;
      int port = userSessionModel.serverUri.port;
      String sid = userSessionModel.session.sid;
      Uri url;
      if ((queryParams != null) && (queryParams.keys.length > 0)) {
        url = Uri(
          scheme: scheme,
          host: server,
          port: port,
          path: urlEndpoint,
          queryParameters: queryParams,
        );
      } else {
        url = Uri(scheme: scheme, host: server, port: port, path: urlEndpoint);
      }

      log(
        url.toString(),
        level: Level.INFO.value,
        name: "PiHttpClient.get",
        time: DateTime.now(),
      );

      http.Response response = await _httpClient.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "sid": sid.toString(),
        },
      );

      log(
        response.statusCode.toString(),
        level: Level.INFO.value,
        name: "PiHttpClient.get",
      );
      result = jsonDecode(response.body);
      return result;
    } catch (e) {
      log(
        e.toString(),
        level: Level.SEVERE.value,
        name: "PiHttpClient.get",
        error: e,
      );
      rethrow;
    }
  }

  dynamic post(
    String urlEndpoint,
    dynamic queryParams,
    dynamic body, [
    String? scheme,
    String? server,
    int? port,
    String? password,
  ]) async {
    dynamic result;
    String sid = "";
    Map<String, String> headers = {};
    try {
      if (server == null) {
        UserSessionModel? userSessionModel = UserSessionService().getSession();
        scheme = userSessionModel!.serverUri.scheme;
        server = userSessionModel.serverUri.host;
        port = userSessionModel.serverUri.port;
        sid = userSessionModel.session.sid;
        headers = <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "sid": sid.toString(),
        };
      } else {
        body = jsonEncode(<String, String>{'password': password!});
      }

      Uri url;
      if ((queryParams != null) && (queryParams.keys.length > 0)) {
        url = Uri(
          scheme: scheme,
          host: server,
          port: port,
          path: urlEndpoint,
          queryParameters: queryParams,
        );
      } else {
        url = Uri(scheme: scheme, host: server, port: port, path: urlEndpoint);
      }

      log(
        url.toString(),
        level: Level.INFO.value,
        name: "PiHttpClient.post",
        time: DateTime.now(),
      );

      http.Response response = await _httpClient.post(
        url,
        headers: headers,
        body: body,
      );

      log(
        response.statusCode.toString(),
        level: Level.INFO.value,
        name: "PiHttpClient.post",
        time: DateTime.now(),
      );

      /// #TODO Refactor
      if (response.statusCode == 204) {
        return {"deleted": true};
      }
      result = jsonDecode(response.body);
      return result;
    } catch (e) {
      log(
        e.toString(),
        level: Level.SEVERE.value,
        name: "PiHttpClient.post",
        error: e,
      );
      rethrow;
    }
  }

  dynamic delete(String urlEndpoint, {dynamic queryParams}) async {
    try {
      UserSessionModel? userSessionModel = UserSessionService().getSession();
      String scheme = userSessionModel!.serverUri.scheme;
      String server = userSessionModel.serverUri.host;
      int port = userSessionModel.serverUri.port;
      String sid = userSessionModel.session.sid;
      Uri url;
      if ((queryParams != null) && (queryParams.keys.length > 0)) {
        url = Uri(
          scheme: scheme,
          host: server,
          port: port,
          path: urlEndpoint,
          queryParameters: queryParams,
        );
      } else {
        url = Uri(scheme: scheme, host: server, port: port, path: urlEndpoint);
      }

      log(
        url.toString(),
        level: Level.INFO.value,
        name: "PiHttpClient.delete",
        time: DateTime.now(),
      );
      var response = await _httpClient.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "sid": sid.toString(),
        },
      );
      log(
        response.statusCode.toString(),
        level: Level.INFO.value,
        name: "PiHttpClient.delete",
        time: DateTime.now(),
      );

      if (response.statusCode == 204) {
        return {"deleted": true};
      } else {
        return {"deleted": false};
      }
    } catch (e) {
      log(
        e.toString(),
        level: Level.SEVERE.value,
        name: "PiHttpClient.delete",
        error: e,
      );
      rethrow;
    }
  }

  dynamic put(
    String urlEndpoint,
    dynamic queryParams,
    dynamic body, [
    String? scheme,
    String? server,
    int? port,
    String? password,
  ]) async {
    dynamic result;
    String sid = "";
    Map<String, String> headers = {};
    try {
      if (server == null) {
        UserSessionModel? userSessionModel = UserSessionService().getSession();
        scheme = userSessionModel!.serverUri.scheme;
        server = userSessionModel.serverUri.host;
        port = userSessionModel.serverUri.port;
        sid = userSessionModel.session.sid;
        headers = <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "sid": sid.toString(),
        };
      } else {
        body = jsonEncode(<String, String>{'password': password!});
      }

      Uri url;
      if ((queryParams != null) && (queryParams.keys.length > 0)) {
        url = Uri(
          scheme: scheme,
          host: server,
          port: port,
          path: urlEndpoint,
          queryParameters: queryParams,
        );
      } else {
        url = Uri(scheme: scheme, host: server, port: port, path: urlEndpoint);
      }

      log(
        url.toString(),
        level: Level.INFO.value,
        name: "PiHttpClient.put",
        time: DateTime.now(),
      );

      http.Response response = await _httpClient.put(
        url,
        headers: headers,
        body: body,
      );

      log(
        response.statusCode.toString(),
        level: Level.INFO.value,
        name: "PiHttpClient.put",
        time: DateTime.now(),
      );
      result = jsonDecode(response.body);
      return result;
    } catch (e) {
      log(
        e.toString(),
        level: Level.SEVERE.value,
        name: "PiHttpClient.put",
        error: e,
      );
      rethrow;
    }
  }

  void close() => _httpClient.close();
}
