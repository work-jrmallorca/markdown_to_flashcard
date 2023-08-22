import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/repositories/markdown_file_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockPickMarkdownFile extends Mock implements PickMarkdownFile {}

void main() {
  late MarkdownFileRepository repository;
  late MockPickMarkdownFile mock;
  late PlatformFile platformFile;
  late FilePickerResult filePickerResult;

  setUp(() {
    mock = MockPickMarkdownFile();
    repository = MarkdownFileRepository(pickMarkdownFileAPI: mock);

    platformFile = PlatformFile(path: 'test.md', name: 'test.md', size: 0);
    filePickerResult = FilePickerResult([platformFile]);
  });

  group('GIVEN the user wants to select a Markdown file, ', () {
    test(
        "WHEN 'getMarkdownFile()' is called from the repository, "
        "THEN call 'FilePicker.platform.pickFiles()' once, "
        "AND return a 'File'", () async {
      final File expected = File(platformFile.path!);
      when(() => mock()).thenAnswer((_) async => filePickerResult);

      final File? result = await repository.getMarkdownFile();

      verify(() => mock()).called(1);
      expect(result!.path, expected.path);
    });
  });
}
