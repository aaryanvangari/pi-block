import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pi_block/logging/app_logger.dart';
import 'package:pi_block/services/user_session_service.dart';
import 'package:pi_block/models/user_session_model.dart';

class PiHttpClient {
  final http.Client _httpClient;

  PiHttpClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final _log = AppLogger.get('PiHttpClient');

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

      _log.info('get: ${url.toString()}');

      http.Response response = await _httpClient.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "sid": sid.toString(),
        },
      );

      _log.info('get: ${response.statusCode.toString()}');
      result = jsonDecode(response.body);
      return result;
    } catch (e) {
      _log.severe('get: ${e.toString()}', e);
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

      _log.info('post: ${url.toString()}');

      http.Response response = await _httpClient.post(
        url,
        headers: headers,
        body: body,
      );

      _log.info('post: ${response.statusCode.toString()}');

      /// #TODO Refactor
      if (response.statusCode == 204) {
        return {"deleted": true};
      }
      result = jsonDecode(response.body);
      return result;
    } catch (e) {
      _log.severe('post: ${e.toString()}', e);
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

      _log.info('delete: ${url.toString()}');
      var response = await _httpClient.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "sid": sid.toString(),
        },
      );
      
      _log.info('delete: ${response.statusCode.toString()}');

      if (response.statusCode == 204) {
        return {"deleted": true};
      } else {
        return {"deleted": false};
      }
    } catch (e) {
      _log.severe('delete: ${e.toString()}', e);
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

      _log.info('put: ${url.toString()}');

      http.Response response = await _httpClient.put(
        url,
        headers: headers,
        body: body,
      );

      _log.info('put: ${response.statusCode.toString()}');
      result = jsonDecode(response.body);
      return result;
    } catch (e) {
      _log.severe('put: ${e.toString()}', e);
      rethrow;
    }
  }

  void close() => _httpClient.close();
}
