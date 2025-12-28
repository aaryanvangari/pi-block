import 'package:flutter/material.dart';

@immutable
class AppUiTokens extends ThemeExtension<AppUiTokens> {
  final Color slidePrimary;
  final Color slideError;
  final Color circularLoadingOnPrimary;
  final Color circularLoadingOnError;
  final TextStyle listHeaderTitleAllow;
  final TextStyle listHeaderTitleBlock;
  final Color tagBackground;

  const AppUiTokens({
    required this.slidePrimary,
    required this.slideError,
    required this.circularLoadingOnPrimary,
    required this.circularLoadingOnError,
    required this.listHeaderTitleAllow,
    required this.listHeaderTitleBlock,
    required this.tagBackground,
  });

  @override
  AppUiTokens copyWith({
    Color? slidePrimary,
    Color? slideError,
    Color? circularLoadingOnPrimary,
    Color? circularLoadingOnError,
    TextStyle? listHeaderTitleAllow,
    TextStyle? listHeaderTitleBlock,
    Color? tagBackground,
  }) {
    return AppUiTokens(
      slidePrimary: slidePrimary ?? this.slidePrimary,
      slideError: slideError ?? this.slideError,
      circularLoadingOnPrimary:
          circularLoadingOnPrimary ?? this.circularLoadingOnPrimary,
      circularLoadingOnError:
          circularLoadingOnError ?? this.circularLoadingOnError,
      listHeaderTitleAllow: listHeaderTitleAllow ?? this.listHeaderTitleAllow,
      listHeaderTitleBlock: listHeaderTitleBlock ?? this.listHeaderTitleBlock,
      tagBackground: tagBackground ?? this.tagBackground,
    );
  }

  @override
  AppUiTokens lerp(ThemeExtension<AppUiTokens>? other, double t) {
    if (other is! AppUiTokens) return this;

    return AppUiTokens(
      slidePrimary: Color.lerp(slidePrimary, other.slidePrimary, t)!,
      slideError: Color.lerp(slideError, other.slideError, t)!,
      circularLoadingOnPrimary: Color.lerp(
        circularLoadingOnPrimary,
        other.circularLoadingOnPrimary,
        t,
      )!,
      circularLoadingOnError: Color.lerp(
        circularLoadingOnError,
        other.circularLoadingOnError,
        t,
      )!,
      listHeaderTitleAllow: TextStyle.lerp(
        listHeaderTitleAllow,
        other.listHeaderTitleAllow,
        t,
      )!,
      listHeaderTitleBlock: TextStyle.lerp(
        listHeaderTitleBlock,
        other.listHeaderTitleBlock,
        t,
      )!,
      tagBackground: Color.lerp(tagBackground, other.tagBackground, t)!,
    );
  }
}
