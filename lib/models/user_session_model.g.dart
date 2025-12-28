// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSessionModelAdapter extends TypeAdapter<UserSessionModel> {
  @override
  final int typeId = 2;

  @override
  UserSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSessionModel(
      session: fields[0] as Session,
      serverUrl: fields[1] as String,
      sessionValidUntil: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserSessionModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.session)
      ..writeByte(1)
      ..write(obj.serverUrl)
      ..writeByte(2)
      ..write(obj.sessionValidUntil);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
