import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:pi_block/constants/hive/hive_typeids.dart';

part 'session_model.g.dart';

class SessionModel extends Equatable {
  final Session? session;
  final double took;

  const SessionModel({required this.session, required this.took});

  /// Empty SessionModel
  factory SessionModel.empty() => const SessionModel(session: null, took: 0);

  /// Factory constructor to create SessionModel from JSON
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    log(
      json.toString(),
      level: Level.FINEST.value,
      name: "SessionModel.fromJson",
    );
    return SessionModel(
      session: json['session'] != null
          ? Session.fromJson(json['session'])
          : null,
      took: (json['took'] as num?)?.toDouble() ?? 0,
    );
  }

  /// Convert SessionModel to JSON
  Map<String, dynamic> toJson() {
    return {'session': session?.toJson(), 'took': took};
  }

  /// Convenience getter
  bool get hasValidSession => session?.valid ?? false;

  @override
  List<Object?> get props => [session, took];
}

// ---------------------------------------------------------------------------
@HiveType(typeId: HiveTypeIds.session)
class Session extends Equatable {
  @HiveField(0)
  /// Valid session indicator (client is authenticated)
  final bool valid;

  @HiveField(1)
  /// Whether 2FA (TOTP) is enabled
  final bool totp;

  @HiveField(2)
  /// Session ID
  final String sid;

  @HiveField(3)
  /// CSRF token
  final String csrf;

  @HiveField(4)
  /// Remaining lifetime of the session in seconds
  final int validity;

  @HiveField(5)
  /// Human-readable message describing session status
  final String message;

  const Session({
    this.valid = false,
    this.totp = false,
    this.sid = "",
    this.csrf = "",
    this.validity = 0,
    this.message = "",
  });

  /// Empty Session
  factory Session.empty() => const Session();

  /// Factory constructor to create Session from JSON
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      valid: json['valid'] ?? false,
      totp: json['totp'] ?? false,
      sid: json['sid'] ?? "",
      csrf: json['csrf'] ?? "",
      validity: json['validity'] ?? 0,
      message: json['message'] ?? "",
    );
  }

  /// Convert Session to JSON
  Map<String, dynamic> toJson() {
    return {
      'valid': valid,
      'totp': totp,
      'sid': sid,
      'csrf': csrf,
      'validity': validity,
      'message': message,
    };
  }

  /// CopyWith method
  Session copyWith({
    bool? valid,
    bool? totp,
    String? sid,
    String? csrf,
    int? validity,
    String? message,
  }) {
    return Session(
      valid: valid ?? this.valid,
      totp: totp ?? this.totp,
      sid: sid ?? this.sid,
      csrf: csrf ?? this.csrf,
      validity: validity ?? this.validity,
      message: message ?? this.message,
    );
  }

  /// Helpers
  bool get isEmpty => !valid && sid.isEmpty && csrf.isEmpty;
  bool get isExpired => validity <= 0;

  @override
  List<Object?> get props => [valid, totp, sid, csrf, validity, message];
}
