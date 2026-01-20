import 'dart:convert';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:logging/logging.dart';
import 'package:pi_block/components/global_banner.dart';
import 'package:pi_block/error/exceptions/api_exception.dart';
import 'package:pi_block/error/exceptions/session_exception.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/logging/app_logger.dart';
import 'package:pi_block/models/app_settings_model.dart';
import 'package:pi_block/models/gravity_log_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class PiUtils {
  static final Logger _log = AppLogger.get('PiUtils');

  static handleAPIException(dynamic result, bool isAuth) {
    if (isAuth) {
      if (result?.containsKey("session") &&
          result?["session"]?["sid"] == null) {
        String apiErrorMessage = result["session"]?["message"];
        // String apiErrorHint = result["session"]?["hint"] ?? "";
        _log.severe('handleAPIException: ${result.toString()}', result);
        throw APIException(apiErrorMessage, "");
      } else if (result?.containsKey("error") ?? false) {
        String apiErrorMessage = result["error"]?["message"];
        String apiErrorHint = result["error"]?["hint"] ?? "";
        _log.severe('handleAPIException: ${result.toString()}', result);
        throw APIException(apiErrorMessage, apiErrorHint);
      }
    } else {
      if (result?.containsKey("error") ?? false) {
        String apiErrorMessage = result["error"]?["message"];
        String apiErrorHint = result["error"]?["hint"] ?? "";
        _log.severe('handleAPIException: ${result.toString()}', result);
        throw APIException(apiErrorMessage, apiErrorHint);
      } else if (result.keys.length == 0) {
        _log.severe('handleAPIException: ${result.toString()}', result);
        throw Exception("Error loading data");
      }
    }
  }

  static handleGeneralException(BuildContext context, Object e) async {
    _log.severe('handleGeneralException: ${e.toString()}', e);
    final maxTitleLength = 30;
    String errorClass = e.runtimeType.toString();
    String errorTitle = e.toString().length > maxTitleLength
        ? e.toString().substring(0, maxTitleLength)
        : e.toString();
    String errorDescription = e.toString().length > maxTitleLength
        ? e.toString()
        : "";
    if (errorClass == "APIException") {
      APIException apiException = e as APIException;
      errorTitle = apiException.message;
      errorDescription = apiException.description;
    } else if (errorClass == "SessionException") {
      SessionException sessionException = e as SessionException;
      errorTitle = sessionException.message;
      errorDescription = sessionException.description;
    }

    GlobalBanner.error(context, errorTitle, errorDescription);
  }

  static String getDateFormatter(
    double milliseconds, {
    String format = 'yyyy-MM-dd H:m:s.SSS',
  }) {
    if (milliseconds == 0) return "N/A";
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      (milliseconds * 1000).toInt(),
    );
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(dateTime);
    return formatted;
  }

  static String getTimeAgo(int entity, String type) {
    dynamic dateTime;
    if (entity == 0) return "N/A";
    if (type == "seconds") {
      dateTime = DateTime.now().subtract(Duration(seconds: entity));
    } else if (type == "milliseconds") {
      dateTime = DateTime.fromMillisecondsSinceEpoch(entity * 1000);
    }

    return timeago.format(dateTime);
  }

  static String calculateTime(double time) {
    return time < 1e-4
        ? "${(1e6 * time).toStringAsFixed(1)} µs"
        : time < 1
        ? "${(1e3 * time).toStringAsFixed(1)} ms"
        : "${time.toStringAsFixed(1)} s";
  }

  static double roundDouble(double value, int places) {
    double mod = pow(10.0, places).toDouble();
    return ((value * mod).round().toDouble() / mod);
  }

  static Color getRandomColor(BuildContext context) {
    // String themeMode = isDarkModeNotifier.value;
    // bool isDarkMode = false;
    // switch (themeMode) {
    //   case "System":
    //     isDarkMode =
    //         (MediaQuery.of(context).platformBrightness == Brightness.dark)
    //         ? true
    //         : false;
    //     break;
    //   case "Light":
    //     isDarkMode = false;
    //     break;
    //   case "Dark":
    //     isDarkMode = true;
    //     break;
    //   default:
    // }
    bool isDarkMode = getDarkMode(context);
    // Generate a Flutter Color object
    Color randomColor = RandomColor.getColorObject(
      Options(
        luminosity: isDarkMode ? Luminosity.bright : Luminosity.bright,
        alpha: isDarkMode ? 0.1 : 0.9,
        // colorType: ColorType.random
      ),
    );
    return randomColor;
  }

  static bool getDarkMode(BuildContext context) {
    ThemeModeOption themeMode = themeModeOptionNotifier.value;
    bool isDarkMode = false;
    switch (themeMode) {
      case ThemeModeOption.system:
        isDarkMode =
            (MediaQuery.of(context).platformBrightness == Brightness.dark)
            ? true
            : false;
        break;
      case ThemeModeOption.light:
        isDarkMode = false;
        break;
      case ThemeModeOption.dark:
        isDarkMode = true;
        break;
    }
    return isDarkMode;
  }

  static WoltModalType getModalTypeBuilder(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 523) {
      return WoltModalType.bottomSheet();
    } else if (width < 800) {
      return WoltModalType.dialog();
    } else {
      return WoltModalType.sideSheet();
    }
  }

  static GravityLog parseGravityLog(String line) {
    _log.fine('parseGravityLog: $line');

    // Handle error which comes as JSON
    // Usually we can parse json body from response but since this is stream
    // even error comes in stream as pure text, we need to parse it
    if (line.contains('{"error"')) {
      try {
        final decoded = jsonDecode(line);
        _log.severe('parseGravityLog: $decoded', decoded);

        if (decoded is Map && decoded['error'] != null) {
          final error = decoded['error'];

          return GravityLog(
            type: GravityLogType.streamError,
            message: error['message']?.toString() ?? 'Unknown error',
            error: error['key']?.toString(),
          );
        }
      } catch (_) {
        // Not valid JSON, continue parsing as normal text
      }
    }

    // regular stream text
    if (line.contains('[✓]')) {
      return GravityLog(
        type: GravityLogType.success,
        message: line.replaceAll('[✓]', ''),
      );
    }
    if (line.contains('[i]')) {
      return GravityLog(
        type: GravityLogType.info,
        message: line.replaceAll('[i]', ''),
      );
    }
    if (line.contains('[✗]')) {
      return GravityLog(
        type: GravityLogType.error,
        message: line.replaceAll('[✗]', ''),
      );
    }
    return GravityLog(type: GravityLogType.none, message: line);
  }
}
