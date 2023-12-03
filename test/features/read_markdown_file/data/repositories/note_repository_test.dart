import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/core/errors/exception.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/data_sources/markdown_files_local_data_source.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/repositories/note_repository.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:mocktail/mocktail.dart';

class MockMarkdownFilePickerLocalDataSource extends Mock
    implements MarkdownFilesLocalDataSource {}

void main() {
  final File deckMultipleTagsTitleMultipleQaFile =
      File('test/fixtures/file_with__deck_multiple-tags_title_multiple-qa.md');

  late MockMarkdownFilePickerLocalDataSource mock;
  late NoteRepository repository;

  setUp(() {
    mock = MockMarkdownFilePickerLocalDataSource();
    repository = NoteRepository(localDataSource: mock);
  });

  group('getNote()', () {
    test(
        'GIVEN the user does not select a Markdown file, '
        "WHEN 'getNote()' is called from the repository, "
        "THEN call 'getFile()' once from the local data source, "
        "AND return 'null'", () async {
      const List<Note> expected = [];
      when(() => mock.getFiles()).thenAnswer((_) async => []);

      final List<Note> result = await repository.getNote();

      expect(result, expected);
      verify(() => mock.getFiles()).called(1);
    });

    test(
        'GIVEN the user selects an incorrectly formatted Markdown file, '
        "WHEN 'getNote()' is called from the repository, "
        "THEN call 'getFile()' once from the local data source, "
        'AND throw a ConversionException', () async {
      when(() => mock.getFiles()).thenThrow(ConversionException());

      final Future<List<Note>> Function() result = repository.getNote;

      expect(() async => await result(), throwsA(isA<ConversionException>()));
      verify(() => mock.getFiles()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name, multiple tags, and multiple question/answer pairs, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        "AND return 'Note'", () async {
      File file = deckMultipleTagsTitleMultipleQaFile;
      List<Note> expected = [Note(fileContents: file.readAsStringSync())];
      when(() => mock.getFiles()).thenAnswer((_) async => expected);

      final List<Note> result = await repository.getNote();

      expect(result, expected);
      verify(() => mock.getFiles()).called(1);
    });
  });

  group('updateNote', () {
    test(
        'GIVEN a file is being updated, '
        "WHEN 'updateNote()' is called, "
        "THEN verify 'updateFile()' is called from local data source",
        () async {
      Note note = const Note(fileContents: '');
      when(() => mock.updateFile(note)).thenAnswer((_) async {});

      repository.updateNote(note);

      verify(() => mock.updateFile(note)).called(1);
    });
  });
}
