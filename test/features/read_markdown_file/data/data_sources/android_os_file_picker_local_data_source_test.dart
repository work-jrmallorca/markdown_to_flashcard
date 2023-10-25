import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/data_sources/android_os_files_local_data_source.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:mocktail/mocktail.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  late AndroidOSFilesLocalDataSource localDataSource;

  late MockMethodChannel mock;

  setUp(() async {
    mock = MockMethodChannel();
    localDataSource = AndroidOSFilesLocalDataSource(methodChannel: mock);
  });

  group('getFile', () {
    test(
        'GIVEN a file is successfully picked, '
        "WHEN 'getFile()' is called, "
        "THEN return 'FilePickerResult'", () async {
      Map<String, String> file = {
        'uri': 'test uri',
        'fileContents': 'test fileContents',
      };
      Note expected = Note(
        uri: file['uri'],
        fileContents: file['fileContents']!,
      );

      when(() => mock.invokeMethod<Map>('pickFile'))
          .thenAnswer((_) async => file);

      final Note? result = await localDataSource.getFile();

      expect(result, expected);
      verify(() => mock.invokeMethod<Map>('pickFile')).called(1);
    });

    test(
        'GIVEN the file picker is cancelled, '
        "WHEN 'getFile()' is called, "
        "THEN return 'FilePickerResult'", () async {
      when(() => mock.invokeMethod<Map>('pickFile'))
          .thenAnswer((_) async => null);

      final Note? result = await localDataSource.getFile();

      verify(() => mock.invokeMethod<Map>('pickFile')).called(1);
      expect(result, null);
    });
  });

  group('updateFile', () {
    test(
        'GIVEN a file is being updated, '
        "WHEN 'updateFile()' is called, "
        "THEN return 'FilePickerResult'", () async {
      Map<String, String> file = {
        'uri': 'test uri',
        'fileContents': 'test fileContents',
      };
      Note note = Note(
        uri: file['uri'],
        fileContents: file['fileContents']!,
      );

      when(() => mock.invokeMethod(
            'writeFile',
            <String, dynamic>{
              'uri': note.uri,
              'fileContents': note.fileContents,
            },
          )).thenAnswer((_) async => file);

      await localDataSource.updateFile(note);

      verify(() => mock.invokeMethod('writeFile', any())).called(1);
    });
  });
}
