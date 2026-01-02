import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:pi_block/constants/hive/hive_typeids.dart';
import 'package:pi_block/logging/model_log.dart';
import 'package:pi_block/models/session_model.dart';

part 'user_session_model.g.dart';

@HiveType(typeId: HiveTypeIds.userSession)
class UserSessionModel extends Equatable {
  @HiveField(0)
  final Session session;

  @HiveField(1)
  final String serverUrl;

  @HiveField(2)
  final int sessionValidUntil;

  const UserSessionModel({
    required this.session,
    required this.serverUrl,
    required this.sessionValidUntil,
  });

  factory UserSessionModel.empty() => UserSessionModel(
    session: Session.empty(),
    serverUrl: '',
    sessionValidUntil: 0,
  );

  Uri get serverUri => Uri.parse(serverUrl);

  // Factory constructor to create UserSessionModel from JSON
  factory UserSessionModel.fromJson(Map<String, dynamic> json) {
    ModelLog.fromJson(UserSessionModel, json);

    return UserSessionModel(
      session: json['session'] != null
          ? Session.fromJson(json['session'])
          : Session.empty(),
      serverUrl: json['serverUrl'] ?? '',
      sessionValidUntil: json['sessionValidUntil'] ?? 0,
    );
  }

  // Method to convert UserSessionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'session': session.toJson(),
      'serverUrl': serverUrl,
      'sessionValidUntil': sessionValidUntil,
    };
  }

  UserSessionModel copyWith({
    Session? session,
    String? serverUrl,
    int? sessionValidUntil,
  }) {
    return UserSessionModel(
      session: session ?? this.session,
      serverUrl: serverUrl ?? this.serverUrl,
      sessionValidUntil: sessionValidUntil ?? this.sessionValidUntil,
    );
  }

  @override
  List<Object?> get props => [session, serverUrl, sessionValidUntil];
}
