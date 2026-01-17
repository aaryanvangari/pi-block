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
  final Color editIconColor;
  final Color deleteIconColor;
  final Color networkAddressColor;
  final Color networkAddressBackgroundColor;
  final Color networkDeviceLessThanHour;
  final Color networkDeviceLessThanDay;
  final Color networkDeviceGreaterThanDay;
  final Color networkDeviceDoesNotUsePihole;

  const AppUiTokens({
    required this.slidePrimary,
    required this.slideError,
    required this.circularLoadingOnPrimary,
    required this.circularLoadingOnError,
    required this.listHeaderTitleAllow,
    required this.listHeaderTitleBlock,
    required this.tagBackground,
    required this.editIconColor,
    required this.deleteIconColor,
    required this.networkAddressColor,
    required this.networkAddressBackgroundColor,
    required this.networkDeviceLessThanHour,
    required this.networkDeviceLessThanDay,
    required this.networkDeviceGreaterThanDay,
    required this.networkDeviceDoesNotUsePihole,
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
    Color? editIconColor,
    Color? deleteIconColor,
    Color? networkAddressColor,
    Color? networkAddressBackgroundColor,
    Color? networkDeviceLessThanHour,
    Color? networkDeviceLessThanDay,
    Color? networkDeviceGreaterThanDay,
    Color? networkDeviceDoesNotUsePihole,
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
      editIconColor: editIconColor ?? this.editIconColor,
      deleteIconColor: deleteIconColor ?? this.deleteIconColor,
      networkAddressColor: networkAddressColor ?? this.networkAddressColor,
      networkAddressBackgroundColor:
          networkAddressBackgroundColor ?? this.networkAddressBackgroundColor,
      networkDeviceLessThanHour: networkDeviceLessThanHour ?? this.networkDeviceLessThanHour,
      networkDeviceLessThanDay: networkDeviceLessThanDay ?? this.networkDeviceLessThanDay,
      networkDeviceGreaterThanDay: networkDeviceGreaterThanDay ?? this.networkDeviceGreaterThanDay,
      networkDeviceDoesNotUsePihole: networkDeviceDoesNotUsePihole ?? this.networkDeviceDoesNotUsePihole,
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
      editIconColor: Color.lerp(editIconColor, other.editIconColor, t)!,
      deleteIconColor: Color.lerp(deleteIconColor, other.deleteIconColor, t)!,
      networkAddressColor:
          Color.lerp(networkAddressColor, other.networkAddressColor, t)!,
      networkAddressBackgroundColor: Color.lerp(
        networkAddressBackgroundColor,
        other.networkAddressBackgroundColor,
        t,
      )!,
      networkDeviceLessThanHour: Color.lerp(networkDeviceLessThanHour, other.networkDeviceLessThanHour, t)!,
      networkDeviceLessThanDay: Color.lerp(networkDeviceLessThanDay, other.networkDeviceLessThanDay, t)!,
      networkDeviceGreaterThanDay: Color.lerp(networkDeviceGreaterThanDay, other.networkDeviceGreaterThanDay, t)!,
      networkDeviceDoesNotUsePihole: Color.lerp(networkDeviceDoesNotUsePihole, other.networkDeviceDoesNotUsePihole, t)! 
    );
  }
}
