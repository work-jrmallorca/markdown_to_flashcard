import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:markdown_to_flashcard/core/errors/exception.dart';
import 'package:markdown_to_flashcard/features/theme/data/data_sources/theme_local_data_source.dart';

import '../../presentation/bloc/theme_state.dart';

class ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepository({required this.localDataSource});

  ThemeState getThemeFromSharedPreferences() {
    String themeStatusName = localDataSource.getTheme();

    ThemeStatus themeStatus = ThemeStatus.values
        .firstWhere((e) => e.toString() == 'ThemeStatus.$themeStatusName');

    return ThemeState(
        status: themeStatus, themeData: getThemeFromStatus(themeStatus));
  }

  ThemeData getThemeFromStatus(ThemeStatus themeStatus) {
    switch (themeStatus) {
      case ThemeStatus.light:
        return FlexThemeData.light();
      case ThemeStatus.dark:
        return FlexThemeData.dark();
      case ThemeStatus.amoled:
        return FlexThemeData.dark(darkIsTrueBlack: true);
    }
  }

  Future<void> setThemeToSharedPreferences(ThemeStatus themeStatus) async {
    bool isThemeSet = await localDataSource.setTheme(themeStatus);

    if (!isThemeSet) {
      throw ThemeNotSetException(
          message: 'Unable to set theme into user preferences.');
    }
  }
}
