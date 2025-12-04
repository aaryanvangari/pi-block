import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PiHttpClient {
  dynamic get(String urlEndpoint, {dynamic queryParams}) async {
    dynamic result;
    try {
      final prefs = await SharedPreferences.getInstance();
      String scheme = prefs.getString("scheme")!;
      String server = prefs.getString("server")!;
      int port = prefs.getInt("port")!;
      String sid = prefs.getString("sid")!;
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

      http.Response response = await http.get(
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
        final prefs = await SharedPreferences.getInstance();
        scheme = prefs.getString("scheme")!;
        server = prefs.getString("server")!;
        port = prefs.getInt("port")!;
        sid = prefs.getString("sid")!;
        headers = <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "sid": sid.toString(),
        };
      } else {
        body = jsonEncode(<String, String>{'password': password!});
      }

      Uri url;
      url = Uri(scheme: scheme, host: server, port: port, path: urlEndpoint);

      log(
        url.toString(),
        level: Level.INFO.value,
        name: "PiHttpClient.post",
        time: DateTime.now(),
      );

      http.Response response = await http.post(
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

  dynamic delete(Uri url, String sid) async {
    try {
      log(
        url.toString(),
        level: Level.INFO.value,
        name: "PiHttpClient.delete",
        time: DateTime.now(),
      );
      var response = await http.delete(
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
      return response;
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
        final prefs = await SharedPreferences.getInstance();
        scheme = prefs.getString("scheme")!;
        server = prefs.getString("server")!;
        port = prefs.getInt("port")!;
        sid = prefs.getString("sid")!;
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

      http.Response response = await http.put(
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
}
