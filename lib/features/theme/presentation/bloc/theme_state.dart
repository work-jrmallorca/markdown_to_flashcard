import 'package:equatable/equatable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

enum ThemeStatus {
  light,
  dark,
  amoled,
}

class ThemeState extends Equatable {
  final ThemeStatus status;
  final ThemeData themeData;

  ThemeState.light()
      : status = ThemeStatus.light,
        themeData = FlexThemeData.light();

  ThemeState.dark()
      : status = ThemeStatus.dark,
        themeData = FlexThemeData.dark();

  ThemeState.amoled()
      : status = ThemeStatus.amoled,
        themeData = FlexThemeData.dark(darkIsTrueBlack: true);

  @override
  List<Object?> get props => [status];
}
