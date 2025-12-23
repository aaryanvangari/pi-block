import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

class SessionModel extends Equatable {
  final Session? session;
  final double took;

  const SessionModel({required this.session, required this.took});

  // Factory constructor to create SessionModel from JSON
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
      took: json['took'],
    );
  }

  // Method to convert SessionModel to JSON
  Map<String, dynamic> toJson() {
    return {'session': session?.toJson(), 'took': took};
  }

  @override
  List<Object?> get props => [session, took];
}

class Session extends Equatable {
  final bool valid; // Valid session indicator (client is authenticated)
  final bool totp; // Whether 2FA (TOTP) is enabled
  final String sid; // Session ID (can be null)
  final String csrf; // CSRF token (can be null)
  final int validity; // Remaining lifetime of the session in seconds
  final String message; // Human-readable message describing session status

  const Session({
    this.valid = false,
    this.totp = false,
    this.sid = "",
    this.csrf = "",
    this.validity = 0,
    this.message = "",
  });

  // Factory constructor to create Session from JSON
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      valid: json['valid'],
      totp: json['totp'],
      sid: json['sid'],
      csrf: json['csrf'],
      validity: json['validity'],
      message: json['message'],
    );
  }

  // Method to convert Session to JSON
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

  // CopyWith method to clone and modify the Session instance
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

  @override
  List<Object?> get props => [valid, totp, sid, csrf, validity, message];
}
