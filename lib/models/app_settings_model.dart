import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:pi_block/constants/hive/hive_typeids.dart';

part 'app_settings_model.g.dart';

@HiveType(typeId: HiveTypeIds.appSettings)
class AppSettingsModel extends Equatable {
  @HiveField(0)
  final ThemeModeOption themeModeOption;

  const AppSettingsModel({this.themeModeOption = ThemeModeOption.system});

  AppSettingsModel copyWith({ThemeModeOption? themeModeOption}) {
    return AppSettingsModel(
      themeModeOption: themeModeOption ?? this.themeModeOption,
    );
  }

  @override
  List<Object?> get props => [themeModeOption];
}

@HiveType(typeId: HiveTypeIds.themeModeOption)
enum ThemeModeOption {
  @HiveField(0)
  dark,
  @HiveField(1)
  light,
  @HiveField(2)
  system,
}
