import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/core/errors/exception.dart';
import 'package:markdown_to_flashcard/features/theme/data/data_sources/theme_local_data_source.dart';
import 'package:markdown_to_flashcard/features/theme/data/repositories/theme_repository.dart';
import 'package:markdown_to_flashcard/features/theme/presentation/bloc/theme_state.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeLocalDataSource extends Mock implements ThemeLocalDataSource {}

void main() {
  late ThemeRepository repository;
  late MockThemeLocalDataSource mock;

  setUp(() {
    mock = MockThemeLocalDataSource();
    repository = ThemeRepository(localDataSource: mock);
  });

  group('GIVEN the user sets a theme, ', () {
    test(
        'AND is successful, '
        "WHEN 'setTheme()' is called from the local data source, "
        'THEN return', () async {
      const ThemeStatus themeStatus = ThemeStatus.light;
      when(() => mock.setTheme(themeStatus)).thenAnswer((_) async => true);

      repository.setThemeToSharedPreferences(themeStatus);

      verify(() => mock.setTheme(themeStatus)).called(1);
    });

    test(
        'AND fails, '
        "WHEN 'setTheme()' is called from the local data source, "
        'THEN throw an exception', () async {
      const ThemeStatus themeStatus = ThemeStatus.light;
      when(() => mock.setTheme(themeStatus)).thenAnswer((_) async => false);

      final Future<void> Function(ThemeStatus themeStatus) result =
          repository.setThemeToSharedPreferences;

      expect(result(themeStatus), throwsA(isA<ThemeNotSetException>()));
      verify(() => mock.setTheme(themeStatus)).called(1);
    });
  });

  group(
      'GIVEN the app is opened and a theme is being retrieved from user preferences, ',
      () {
    test(
        'AND is successful, '
        "WHEN 'getTheme()' is called from the local data source, "
        "THEN return 'ThemeStatus'", () async {
      ThemeStatus expected = ThemeStatus.light;
      when(() => mock.getTheme()).thenReturn(expected.name);

      final ThemeStatus result =
          repository.getThemeFromSharedPreferences().status;

      expect(result, expected);
      verify(() => mock.getTheme()).called(1);
    });

    test(
        'AND fails, '
        "WHEN 'getTheme()' is called from the local data source, "
        "THEN throw 'StateError'", () async {
      when(() => mock.getTheme()).thenReturn('not an enum');

      final ThemeState Function() result =
          repository.getThemeFromSharedPreferences;

      expect(() => result(), throwsA(isA<StateError>()));
      verify(() => mock.getTheme()).called(1);
    });
  });
}
