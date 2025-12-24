// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsModelAdapter extends TypeAdapter<AppSettingsModel> {
  @override
  final int typeId = 3;

  @override
  AppSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettingsModel(themeModeOption: fields[0] as ThemeModeOption);
  }

  @override
  void write(BinaryWriter writer, AppSettingsModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.themeModeOption);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThemeModeOptionAdapter extends TypeAdapter<ThemeModeOption> {
  @override
  final int typeId = 4;

  @override
  ThemeModeOption read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemeModeOption.dark;
      case 1:
        return ThemeModeOption.light;
      case 2:
        return ThemeModeOption.system;
      default:
        return ThemeModeOption.dark;
    }
  }

  @override
  void write(BinaryWriter writer, ThemeModeOption obj) {
    switch (obj) {
      case ThemeModeOption.dark:
        writer.writeByte(0);
        break;
      case ThemeModeOption.light:
        writer.writeByte(1);
        break;
      case ThemeModeOption.system:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeModeOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
