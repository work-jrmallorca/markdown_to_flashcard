import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/data_sources/agnostic_os_file_picker_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockPickFilesProxy extends Mock implements PickFilesProxy {}

void main() {
  late AgnosticOSFilesLocalDataSource localDataSource;

  late MockPickFilesProxy mock;

  setUp(() async {
    mock = MockPickFilesProxy();
    localDataSource = AgnosticOSFilesLocalDataSource(pickFiles: mock);
  });

  test(
      'GIVEN a file is successfully picked, '
      "WHEN 'call()' is called from the pick files proxy, "
      "THEN return 'FilePickerResult'", () async {
    final PlatformFile expected =
        PlatformFile(path: 'path/to/', name: 'test', size: 0);
    FilePickerResult filePickerResult = FilePickerResult([expected]);

    when(() => mock()).thenAnswer((_) async => filePickerResult);

    final File? result = await localDataSource.getFile();

    verify(() => mock()).called(1);
    expect(result!.path, expected.path);
  });

  test(
      'GIVEN the file picker is cancelled, '
      "WHEN 'call()' is called from the pick files proxy, "
      "THEN return 'FilePickerResult'", () async {
    when(() => mock()).thenAnswer((_) async => null);

    final File? result = await localDataSource.getFile();

    verify(() => mock()).called(1);
    expect(result, null);
  });
}
