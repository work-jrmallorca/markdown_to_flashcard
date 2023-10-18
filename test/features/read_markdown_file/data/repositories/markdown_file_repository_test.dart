import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/data_sources/markdown_files_local_data_source.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/repositories/markdown_file_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockMarkdownFilePickerLocalDataSource extends Mock
    implements MarkdownFilesLocalDataSource {}

void main() {
  late MarkdownFileRepository repository;
  late MockMarkdownFilePickerLocalDataSource mock;

  setUp(() {
    mock = MockMarkdownFilePickerLocalDataSource();
    repository = MarkdownFileRepository(localDataSource: mock);
  });

  group('getMarkdownFile()', () {
    test(
        'GIVEN the user selects a Markdown file, '
        "WHEN 'getMarkdownFile()' is called from the repository, "
        "THEN call 'FilePicker.platform.pickFiles()' once, "
        "AND return a 'File'", () async {
      final File expected = File('test.md');
      when(() => mock.getFile()).thenAnswer((_) async => expected);

      final File? result = await repository.getMarkdownFile();

      verify(() => mock.getFile()).called(1);
      expect(result!.path, expected.path);
    });

    test(
        'GIVEN the user does not select a Markdown file, '
        "WHEN 'getMarkdownFile()' is called from the repository, "
        "THEN call 'FilePicker.platform.pickFiles()' once, "
        "AND return 'null'", () async {
      const File? expected = null;
      when(() => mock.getFile()).thenAnswer((_) async => null);

      final File? result = await repository.getMarkdownFile();

      verify(() => mock.getFile()).called(1);
      expect(result, expected);
    });
  });
}
