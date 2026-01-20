import "package:flutter/material.dart";
import "package:pi_block/theme/app_colors.dart";
import "package:pi_block/theme/app_ui_tokens.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0058bd),
      surfaceTint: Color(0xff005ac2),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1970e6),
      onPrimaryContainer: Color(0xfffefcff),
      secondary: Color(0xff475e8c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffb2c9fe),
      onSecondaryContainer: Color(0xff3d5481),
      tertiary: Color(0xff386845),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9ed3a8),
      onTertiaryContainer: Color(0xff2b5c3a),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff191b23),
      onSurfaceVariant: Color(0xff424754),
      outline: Color(0xff727785),
      outlineVariant: Color(0xffc2c6d6),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3038),
      inversePrimary: Color(0xffadc6ff),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff001a41),
      primaryFixedDim: Color(0xffadc6ff),
      onPrimaryFixedVariant: Color(0xff004494),
      secondaryFixed: Color(0xffd8e2ff),
      onSecondaryFixed: Color(0xff001a41),
      secondaryFixedDim: Color(0xffafc6fb),
      onSecondaryFixedVariant: Color(0xff2f4673),
      tertiaryFixed: Color(0xffb9efc3),
      onTertiaryFixed: Color(0xff00210d),
      tertiaryFixedDim: Color(0xff9ed3a8),
      onTertiaryFixedVariant: Color(0xff1f502f),
      surfaceDim: Color(0xffd8d9e4),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fd),
      surfaceContainer: Color(0xffecedf8),
      surfaceContainerHigh: Color(0xffe6e8f2),
      surfaceContainerHighest: Color(0xffe1e2ec),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003475),
      surfaceTint: Color(0xff005ac2),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff0068de),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1d3561),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff566d9c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff0a3f20),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff467853),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff0e1118),
      onSurfaceVariant: Color(0xff313643),
      outline: Color(0xff4d5260),
      outlineVariant: Color(0xff686d7b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3038),
      inversePrimary: Color(0xffadc6ff),
      primaryFixed: Color(0xff0068de),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff0051af),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff566d9c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff3d5482),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff467853),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff2e5f3c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc4c6d0),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fd),
      surfaceContainer: Color(0xffe6e8f2),
      surfaceContainerHigh: Color(0xffdbdce6),
      surfaceContainerHighest: Color(0xffd0d1db),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002a61),
      surfaceTint: Color(0xff005ac2),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004699),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff112b56),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff314976),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003417),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff215331),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff272c38),
      outlineVariant: Color(0xff444956),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3038),
      inversePrimary: Color(0xffadc6ff),
      primaryFixed: Color(0xff004699),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00306e),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff314976),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff19325d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff215331),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff053b1d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb7b8c2),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff0fa),
      surfaceContainer: Color(0xffe1e2ec),
      surfaceContainerHigh: Color(0xffd2d4de),
      surfaceContainerHighest: Color(0xffc4c6d0),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      // primary: Color(0xffadc6ff), // original
      primary: Color.fromARGB(255, 127, 161, 239),
      // surfaceTint: Color(0xffadc6ff), // original
      surfaceTint: Color.fromARGB(255, 127, 161, 239),
      onPrimary: Color(0xff002e69),
      primaryContainer: Color(0xff4c8eff),
      onPrimaryContainer: Color(0xff002352),
      secondary: Color(0xffafc6fb),
      onSecondary: Color(0xff162f5b),
      secondaryContainer: Color(0xff2f4673),
      onSecondaryContainer: Color(0xff9eb5e9),
      tertiary: Color(0xffb9efc3),
      onTertiary: Color(0xff02391b),
      tertiaryContainer: Color(0xff9ed3a8),
      onTertiaryContainer: Color(0xff2b5c3a),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff10131a),
      onSurface: Color(0xffe1e2ec),
      onSurfaceVariant: Color(0xffc2c6d6),
      outline: Color(0xff8c909f),
      outlineVariant: Color(0xff424754),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2ec),
      inversePrimary: Color(0xff005ac2),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff001a41),
      primaryFixedDim: Color(0xffadc6ff),
      onPrimaryFixedVariant: Color(0xff004494),
      secondaryFixed: Color(0xffd8e2ff),
      onSecondaryFixed: Color(0xff001a41),
      secondaryFixedDim: Color(0xffafc6fb),
      onSecondaryFixedVariant: Color(0xff2f4673),
      tertiaryFixed: Color(0xffb9efc3),
      onTertiaryFixed: Color(0xff00210d),
      tertiaryFixedDim: Color(0xff9ed3a8),
      onTertiaryFixedVariant: Color(0xff1f502f),
      surfaceDim: Color(0xff10131a),
      surfaceBright: Color(0xff363941),
      surfaceContainerLowest: Color(0xff0b0e15),
      surfaceContainerLow: Color(0xff191b23),
      surfaceContainer: Color(0xff1d2027),
      surfaceContainerHigh: Color(0xff272a31),
      surfaceContainerHighest: Color(0xff32353c),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcfdcff),
      surfaceTint: Color(0xffadc6ff),
      onPrimary: Color(0xff002455),
      primaryContainer: Color(0xff4c8eff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffcfdcff),
      onSecondary: Color(0xff072450),
      secondaryContainer: Color(0xff7a91c2),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffb9efc3),
      onTertiary: Color(0xff003216),
      tertiaryContainer: Color(0xff9ed3a8),
      onTertiaryContainer: Color(0xff0a3f20),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff10131a),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd8dcec),
      outline: Color(0xffadb1c1),
      outlineVariant: Color(0xff8b909f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2ec),
      inversePrimary: Color(0xff004597),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff00102e),
      primaryFixedDim: Color(0xffadc6ff),
      onPrimaryFixedVariant: Color(0xff003475),
      secondaryFixed: Color(0xffd8e2ff),
      onSecondaryFixed: Color(0xff00102e),
      secondaryFixedDim: Color(0xffafc6fb),
      onSecondaryFixedVariant: Color(0xff1d3561),
      tertiaryFixed: Color(0xffb9efc3),
      onTertiaryFixed: Color(0xff001506),
      tertiaryFixedDim: Color(0xff9ed3a8),
      onTertiaryFixedVariant: Color(0xff0a3f20),
      surfaceDim: Color(0xff10131a),
      surfaceBright: Color(0xff42444c),
      surfaceContainerLowest: Color(0xff05070e),
      surfaceContainerLow: Color(0xff1b1d25),
      surfaceContainer: Color(0xff25282f),
      surfaceContainerHigh: Color(0xff30323a),
      surfaceContainerHighest: Color(0xff3b3d45),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffecefff),
      surfaceTint: Color(0xffadc6ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa7c2ff),
      onPrimaryContainer: Color(0xff000a22),
      secondary: Color(0xffecefff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffacc2f7),
      onSecondaryContainer: Color(0xff000a22),
      tertiary: Color(0xffc6fdd0),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff9ed3a8),
      onTertiaryContainer: Color(0xff001506),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff10131a),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffecefff),
      outlineVariant: Color(0xffbec2d2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2ec),
      inversePrimary: Color(0xff004597),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffadc6ff),
      onPrimaryFixedVariant: Color(0xff00102e),
      secondaryFixed: Color(0xffd8e2ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffafc6fb),
      onSecondaryFixedVariant: Color(0xff00102e),
      tertiaryFixed: Color(0xffb9efc3),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff9ed3a8),
      onTertiaryFixedVariant: Color(0xff001506),
      surfaceDim: Color(0xff10131a),
      surfaceBright: Color(0xff4d5058),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1d2027),
      surfaceContainer: Color(0xff2d3038),
      surfaceContainerHigh: Color(0xff393b43),
      surfaceContainerHighest: Color(0xff44474f),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
    buttonTheme: const ButtonThemeData(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      shape: StadiumBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.onSurface.withAlpha(20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.onSurface),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.onSurface),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.error),
      ),
    ),

    /// load extensions based on current color scheme
    /// This changes our custom colors on the fly and can be used as below
    /// Deprecated: Theme.of(context).extension<AppUiTokens>()!.slidePrimary
    /// Update: use `context.ui.slidePrimary` as we have `ui` extension method on
    /// buildcontext which gets updated when theme changes and thereby our AppUiTokens
    extensions: [
      (colorScheme.brightness == Brightness.dark)
          ? darkUiTokens(colorScheme)
          : lightUiTokens(colorScheme),
    ],
  );

  List<ExtendedColor> get extendedColors => [];

  AppUiTokens lightUiTokens(ColorScheme cs) => AppUiTokens(
    slidePrimary: cs.primary.withAlpha(180),
    slideError: cs.error.withAlpha(200),
    circularLoadingOnPrimary: cs.onPrimary.withAlpha(180),
    circularLoadingOnError: cs.onError.withAlpha(180),
    listHeaderTitleAllow: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: KColors.listHeaderTitleAllowLight,
    ),
    listHeaderTitleBlock: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: KColors.listHeaderTitleBlockLight,
    ),
    tagBackground: cs.onSurfaceVariant.withAlpha(50),
    editIconColor: cs.onSurface.withAlpha(170),
    deleteIconColor: cs.error.withAlpha(170),
    networkAddressColor: KColors.networkGatewayAddress.withAlpha(170),
    networkAddressBackgroundColor: KColors.networkGatewayAddress.withAlpha(20),
    networkDeviceLessThanHour: KColors.deviceLessThanHour.withAlpha(170),
    networkDeviceLessThanDay: KColors.deviceLessThanDay.withAlpha(170),
    networkDeviceGreaterThanDay: KColors.deviceGreaterThanDay.withAlpha(170),
    networkDeviceDoesNotUsePihole: KColors.deviceDoesNotUsePihole.withAlpha(
      170,
    ),
  );

  AppUiTokens darkUiTokens(ColorScheme cs) => AppUiTokens(
    slidePrimary: cs.primary,
    slideError: cs.error,
    circularLoadingOnPrimary: cs.onPrimary.withAlpha(180),
    circularLoadingOnError: cs.onError.withAlpha(180),
    listHeaderTitleAllow: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: KColors.listHeaderTitleAllowDark,
    ),
    listHeaderTitleBlock: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: KColors.listHeaderTitleBlockDark,
    ),
    tagBackground: cs.onSurfaceVariant.withAlpha(50),
    editIconColor: cs.onSurface.withAlpha(170),
    deleteIconColor: cs.error.withAlpha(170),
    networkAddressColor: cs.onSurface.withAlpha(170),
    networkAddressBackgroundColor: cs.onSurfaceVariant.withAlpha(50),
    networkDeviceLessThanHour: KColors.deviceLessThanHour.withAlpha(170),
    networkDeviceLessThanDay: KColors.deviceLessThanDay.withAlpha(170),
    networkDeviceGreaterThanDay: KColors.deviceGreaterThanDay.withAlpha(170),
    networkDeviceDoesNotUsePihole: KColors.deviceDoesNotUsePihole.withAlpha(
      170,
    ),
  );
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
