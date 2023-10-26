import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/data_sources/agnostic_os_files_local_data_source.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:mocktail/mocktail.dart';

class MockPickFilesProxy extends Mock implements PickFilesProxy {}

void main() {
  late AgnosticOSFilesLocalDataSource localDataSource;

  late MockPickFilesProxy mock;

  setUp(() async {
    mock = MockPickFilesProxy();
    localDataSource = AgnosticOSFilesLocalDataSource(pickFilesProxy: mock);
  });

  group('getFile', () {
    test(
        'GIVEN a file is successfully picked, '
        "WHEN 'call()' is called from the pick files proxy, "
        "THEN return 'FilePickerResult'", () async {
      const fileName = 'test.md';
      const fileContents = 'Test contents';
      final PlatformFile platformFile = PlatformFile(
          path: 'path/to/$fileName',
          name: fileName,
          size: 0,
          bytes: Uint8List.fromList(utf8.encode(fileContents)));
      FilePickerResult filePickerResult = FilePickerResult([platformFile]);
      const Note expected = Note(fileContents: fileContents);

      when(() => mock()).thenAnswer((_) async => filePickerResult);

      final Note? result = await localDataSource.getFile();

      verify(() => mock()).called(1);
      expect(result, expected);
    });

    test(
        'GIVEN the file picker is cancelled, '
        "WHEN 'call()' is called from the pick files proxy, "
        "THEN return 'FilePickerResult'", () async {
      when(() => mock()).thenAnswer((_) async => null);

      final Note? result = await localDataSource.getFile();

      verify(() => mock()).called(1);
      expect(result, null);
    });
  });

  group('updateFile', () {
    test(
        'GIVEN a file is being updated, '
        "WHEN 'updateFile()' is called, "
        "THEN throw 'UnimplementedError'", () async {
      final Future<void> Function(Note note) result =
          localDataSource.updateFile;

      expect(
        () async => await result(const Note(fileContents: '')),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}