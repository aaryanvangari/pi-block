import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/logging/app_logger.dart';
import 'package:pi_block/models/gravity_log_model.dart';
import 'package:pi_block/services/user_session_service.dart';
import 'package:pi_block/models/user_session_model.dart';
import 'package:http_parser/http_parser.dart';

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

  Stream<GravityLog> postStream(
    String urlEndpoint,
    dynamic queryParams,
    dynamic body, [
    String? scheme,
    String? server,
    int? port,
    String? password,
  ]) async* {
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

      _log.info('postStream: ${url.toString()}');

      final request = http.Request('POST', url);
      request.headers.addAll({...headers});
      if (body != null) {
        request.body = body;
      }

      http.StreamedResponse response = await _httpClient.send(request);

      _log.info('postStream: ${response.statusCode.toString()}');

      final ansiRegex = RegExp(r'\x1B\[[0-9;]*[A-Za-z]');

      // send streamed response
      yield* response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .map((line) => line.replaceAll(ansiRegex, ''))
          .map((line) => PiUtils.parseGravityLog(line));
    } catch (e) {
      _log.severe('postStream: ${e.toString()}', e);
      rethrow;
    }
  }

  dynamic downloadFile(String urlEndpoint, {dynamic queryParams}) async {
    UserSessionModel? userSessionModel = UserSessionService().getSession();
    String scheme = userSessionModel!.serverUri.scheme;
    String server = userSessionModel.serverUri.host;
    int port = userSessionModel.serverUri.port;
    String sid = userSessionModel.session.sid;
    Uri url;
    dynamic result;
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
        'Accept': 'application/zip',
        "sid": sid.toString(),
      },
    );

    if (response.statusCode != 200) {
      result = jsonDecode(response.body);
      return result;
    }

    _log.info('get: ${response.statusCode.toString()}');
    return response;
  }

  dynamic uploadFile(
    String urlEndpoint,
    dynamic queryParams,
    dynamic body,
    Uint8List fileBytes,
    String fileName, [
    String? scheme,
    String? server,
    int? port,
    String? password,
    String fileField = 'file',
    String jsonField = 'import',
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

      _log.info('uploadFile: ${url.toString()}');

      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        // JSON part
        ..fields[jsonField] = jsonEncode(body)
        // File part
        ..files.add(
          http.MultipartFile.fromBytes(
            fileField,
            fileBytes,
            filename: fileName,
            contentType: MediaType('application', 'zip'),
          ),
        );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _log.info('uploadFile: ${response.statusCode}');

      result = jsonDecode(response.body);
      return result;
    } catch (e) {
      _log.severe('post: ${e.toString()}', e);
      rethrow;
    }
  }

  void close() => _httpClient.close();
}
