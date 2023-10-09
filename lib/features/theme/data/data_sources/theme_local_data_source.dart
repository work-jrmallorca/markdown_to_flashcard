import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/bloc/theme_state.dart';

class ThemeLocalDataSource {
  final String key;
  final SharedPreferences preferences;

  ThemeLocalDataSource({
    required this.key,
    required this.preferences,
  });

  // Default to light mode if there is no set theme.
  String getTheme() => preferences.getString(key) ?? ThemeStatus.light.name;

  Future<bool> setTheme(ThemeStatus themeStatus) async =>
      await preferences.setString(key, themeStatus.name);
}
