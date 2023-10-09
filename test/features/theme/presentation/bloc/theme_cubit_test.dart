import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/theme/data/repositories/theme_repository.dart';
import 'package:markdown_to_flashcard/features/theme/presentation/bloc/theme_cubit.dart';
import 'package:markdown_to_flashcard/features/theme/presentation/bloc/theme_state.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeRepository extends Mock implements ThemeRepository {}

void main() {
  ThemeState themeStateLight =
      ThemeState(status: ThemeStatus.light, themeData: ThemeData());
  ThemeState themeStateDark =
      ThemeState(status: ThemeStatus.dark, themeData: ThemeData());
  ThemeState themeStateAmoled =
      ThemeState(status: ThemeStatus.amoled, themeData: ThemeData());

  late MockThemeRepository mock;
  late ThemeCubit cubit;

  setUp(() {
    mock = MockThemeRepository();
    when(() => mock.getThemeFromSharedPreferences())
        .thenReturn(themeStateLight);
    cubit = ThemeCubit(repository: mock);
  });

  group('getMarkdownFile()', () {
    blocTest<ThemeCubit, ThemeState>(
      'GIVEN the app is on light mode, '
      "WHEN 'cycleTheme()' is called from the cubit, "
      'THEN emit [ThemeStatus.dark]',
      setUp: () {
        when(() => mock.setThemeToSharedPreferences(themeStateDark.status))
            .thenAnswer((_) async {});
        when(() => mock.getThemeFromStatus(themeStateDark.status))
            .thenReturn(themeStateDark.themeData);
      },
      seed: () => themeStateLight,
      build: () => cubit,
      act: (cubit) => cubit.cycleTheme(),
      expect: () => <ThemeState>[themeStateDark],
    );

    blocTest<ThemeCubit, ThemeState>(
      'GIVEN the app is on dark mode, '
      "WHEN 'cycleTheme()' is called from the cubit, "
      'THEN emit [ThemeStatus.amoled]',
      setUp: () {
        when(() => mock.setThemeToSharedPreferences(themeStateAmoled.status))
            .thenAnswer((_) async {});
        when(() => mock.getThemeFromStatus(themeStateAmoled.status))
            .thenReturn(themeStateAmoled.themeData);
      },
      seed: () => themeStateDark,
      build: () => cubit,
      act: (cubit) => cubit.cycleTheme(),
      expect: () => <ThemeState>[themeStateAmoled],
    );

    blocTest<ThemeCubit, ThemeState>(
      'GIVEN the app is on AMOLED mode, '
      "WHEN 'cycleTheme()' is called from the cubit, "
      'THEN emit [ThemeStatus.light]',
      setUp: () {
        when(() => mock.setThemeToSharedPreferences(themeStateLight.status))
            .thenAnswer((_) async {});
        when(() => mock.getThemeFromStatus(themeStateLight.status))
            .thenReturn(themeStateLight.themeData);
      },
      seed: () => themeStateAmoled,
      build: () => cubit,
      act: (cubit) => cubit.cycleTheme(),
      expect: () => <ThemeState>[themeStateLight],
    );
  });
}
