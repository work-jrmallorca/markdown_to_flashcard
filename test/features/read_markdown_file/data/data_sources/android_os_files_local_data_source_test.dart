import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/data_sources/android_os_files_local_data_source.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:mocktail/mocktail.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  late AndroidOSFilesLocalDataSource localDataSource;
  late String methodName;

  late MockMethodChannel mock;

  setUp(() async {
    mock = MockMethodChannel();
    localDataSource = AndroidOSFilesLocalDataSource(methodChannel: mock);
  });

  group('getFiles', () {
    setUp(() async {
      methodName = 'pickFiles';
    });

    test(
        'GIVEN a file is successfully picked, '
        "WHEN 'getFiles()' is called, "
        'THEN return list of notes', () async {
      List<Map<String, String>> files = [
        {
          'uri': 'test uri',
          'fileContents': 'test fileContents',
        }
      ];
      List<Note> expected = files
          .map((e) => Note(uri: e['uri'], fileContents: e['fileContents']!))
          .toList();

      when(() => mock.invokeMethod<List>(methodName))
          .thenAnswer((_) async => files);

      final List<Note>? result = await localDataSource.getFiles();

      verify(() => mock.invokeMethod<List>(methodName)).called(1);
      expect(result, expected);
    });

    test(
        'GIVEN multiple files are successfully picked, '
        "WHEN 'getFiles()' is called, "
        'THEN return list of notes', () async {
      List<Map<String, String>> files = [
        {
          'uri': 'test uri 1',
          'fileContents': 'test fileContents',
        },
        {
          'uri': 'test uri 2',
          'fileContents': 'test fileContents',
        },
        {
          'uri': 'test uri 3',
          'fileContents': 'test fileContents',
        }
      ];
      List<Note> expected = files
          .map((e) => Note(uri: e['uri'], fileContents: e['fileContents']!))
          .toList();

      when(() => mock.invokeMethod<List>(methodName))
          .thenAnswer((_) async => files);

      final List<Note>? result = await localDataSource.getFiles();

      verify(() => mock.invokeMethod<List>(methodName)).called(1);
      expect(result, expected);
    });

    test(
        'GIVEN the file picker is cancelled, '
        "WHEN 'getFiles()' is called, "
        'THEN return list of notes', () async {
      const List<Note>? expected = null;
      when(() => mock.invokeMethod<List>(methodName))
          .thenAnswer((_) async => expected);

      final List<Note>? result = await localDataSource.getFiles();

      verify(() => mock.invokeMethod<List>(methodName)).called(1);
      expect(result, expected);
    });
  });

  group('updateFile', () {
    setUp(() async {
      methodName = 'writeFile';
    });

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
            methodName,
            <String, dynamic>{
              'uri': note.uri,
              'fileContents': note.fileContents,
            },
          )).thenAnswer((_) async => file);

      await localDataSource.updateFile(note);

      verify(() => mock.invokeMethod(methodName, any())).called(1);
    });
  });
}
