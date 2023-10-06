import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/theme/presentation/bloc/theme_cubit.dart';
import 'package:markdown_to_flashcard/features/theme/presentation/bloc/theme_state.dart';

void main() {
  late ThemeCubit cubit;

  setUp(() {
    cubit = ThemeCubit();
  });

  group('getMarkdownFile()', () {
    blocTest<ThemeCubit, ThemeState>(
      'GIVEN the app is on light mode, '
      "WHEN 'cycleTheme()' is called from the cubit, "
      'THEN emit [ThemeStatus.dark]',
      seed: () => ThemeState.light(),
      build: () => cubit,
      act: (cubit) => cubit.cycleTheme(),
      expect: () => <ThemeState>[ThemeState.dark()],
    );

    blocTest<ThemeCubit, ThemeState>(
      'GIVEN the app is on dark mode, '
      "WHEN 'cycleTheme()' is called from the cubit, "
      'THEN emit [ThemeStatus.amoled]',
      seed: () => ThemeState.dark(),
      build: () => cubit,
      act: (cubit) => cubit.cycleTheme(),
      expect: () => <ThemeState>[ThemeState.amoled()],
    );

    blocTest<ThemeCubit, ThemeState>(
      'GIVEN the app is on AMOLED mode, '
      "WHEN 'cycleTheme()' is called from the cubit, "
      'THEN emit [ThemeStatus.light]',
      seed: () => ThemeState.amoled(),
      build: () => cubit,
      act: (cubit) => cubit.cycleTheme(),
      expect: () => <ThemeState>[ThemeState.light()],
    );
  });
}
