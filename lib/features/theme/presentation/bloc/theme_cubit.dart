import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_to_flashcard/features/theme/data/repositories/theme_repository.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeRepository repository;

  ThemeCubit({required this.repository})
      : super(repository.getThemeFromSharedPreferences());

  void cycleTheme() {
    ThemeStatus nextStatus;

    switch (state.status) {
      case ThemeStatus.light:
        nextStatus = ThemeStatus.dark;
        break;
      case ThemeStatus.dark:
        nextStatus = ThemeStatus.amoled;
        break;
      case ThemeStatus.amoled:
        nextStatus = ThemeStatus.light;
        break;
    }

    repository.setThemeToSharedPreferences(nextStatus);

    emit(ThemeState(
      status: nextStatus,
      themeData: repository.getThemeFromStatus(nextStatus),
    ));
  }
}
