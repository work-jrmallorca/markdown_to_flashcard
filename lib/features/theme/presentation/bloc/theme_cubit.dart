import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.light());

  void cycleTheme() {
    switch (state.status) {
      case ThemeStatus.light:
        emit(ThemeState.dark());
        break;
      case ThemeStatus.dark:
        emit(ThemeState.amoled());
        break;
      case ThemeStatus.amoled:
        emit(ThemeState.light());
        break;
    }
  }
}
