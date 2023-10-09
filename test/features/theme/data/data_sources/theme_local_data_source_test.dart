import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/theme/data/data_sources/theme_local_data_source.dart';
import 'package:markdown_to_flashcard/features/theme/presentation/bloc/theme_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  const String key = 'themeStatus';

  late ThemeLocalDataSource localDataSource;

  group('GIVEN the shared preferences is mocked, ', () {
    late MockSharedPreferences mockPreferences;

    setUp(() async {
      mockPreferences = MockSharedPreferences();
      localDataSource = ThemeLocalDataSource(
        key: key,
        preferences: mockPreferences,
      );
    });

    test(
        'AND a theme is successfully set, '
        "WHEN 'setTheme()' is called from the shared preferences, "
        "THEN return 'true'", () async {
      const ThemeStatus expected = ThemeStatus.light;
      when(() => mockPreferences.setString(any(), expected.name))
          .thenAnswer((_) async => true);

      final bool result = await localDataSource.setTheme(expected);

      verify(() => mockPreferences.setString(any(), expected.name)).called(1);
      expect(result, true);
    });

    test(
        'AND a theme fails to be set, '
        "WHEN 'setTheme()' is called from the shared preferences, "
        "THEN return a 'false'", () async {
      const ThemeStatus expected = ThemeStatus.light;
      when(() => mockPreferences.setString(any(), expected.name))
          .thenAnswer((_) async => false);

      final bool result = await localDataSource.setTheme(expected);

      verify(() => mockPreferences.setString(any(), expected.name)).called(1);
      expect(result, false);
    });

    test(
        'AND a theme is successfully retrieved, '
        "WHEN 'getTheme()' is called from the shared preferences, "
        "THEN return a 'ThemeStatus'", () async {
      const ThemeStatus expected = ThemeStatus.light;
      when(() => mockPreferences.getString(any())).thenReturn(expected.name);

      final String result = localDataSource.getTheme();

      verify(() => mockPreferences.getString(any())).called(1);
      expect(result, expected.name);
    });

    test(
        'AND a theme fails to be retrieved, '
        "WHEN 'getTheme()' is called from the shared preferences, "
        "THEN return a 'ThemeStatus.light'", () async {
      const ThemeStatus expected = ThemeStatus.light;
      when(() => mockPreferences.getString(any())).thenReturn(null);

      final String result = localDataSource.getTheme();

      verify(() => mockPreferences.getString(any())).called(1);
      expect(result, expected.name);
    });
  });

  group('GIVEN the shared preferences is real, ', () {
    late SharedPreferences realPreferences;

    setUpAll(() async => TestWidgetsFlutterBinding.ensureInitialized());

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      realPreferences = await SharedPreferences.getInstance();
      localDataSource = ThemeLocalDataSource(
        key: key,
        preferences: realPreferences,
      );
    });

    test(
        'AND a theme is successfully set, '
        "WHEN 'setTheme()' is called from the shared preferences, "
        "THEN return 'true'", () async {
      const ThemeStatus expected = ThemeStatus.light;

      final bool result = await localDataSource.setTheme(expected);

      expect(result, true);
      expect(realPreferences.getString(key), expected.name);
    });

    test(
        'AND a theme is successfully retrieved, '
        "WHEN 'getTheme()' is called from the shared preferences, "
        "THEN return a 'ThemeStatus'", () async {
      const ThemeStatus expected = ThemeStatus.light;
      SharedPreferences.setMockInitialValues({key: expected.name});

      final String result = localDataSource.getTheme();

      expect(result, expected.name);
    });
  });
}
