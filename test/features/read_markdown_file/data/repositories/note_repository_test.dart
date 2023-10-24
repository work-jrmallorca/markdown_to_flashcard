import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/core/errors/exception.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/data_sources/markdown_files_local_data_source.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/entities/note_entity.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/repositories/note_repository.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/question_answer_pair.dart';
import 'package:mocktail/mocktail.dart';

class MockMarkdownFilePickerLocalDataSource extends Mock
    implements MarkdownFilesLocalDataSource {}

void main() {
  final File noDeckNoTagsNoTitleNoQaFile =
      File('test/fixtures/file_with__no-deck_no-tags_no-title_no-qa.md');
  final File deckNoTagsNoTitleNoQaFile =
      File('test/fixtures/file_with__deck_no-tags_no-title_no-qa.md');
  final File deckOneTagNoTitleNoQaFile =
      File('test/fixtures/file_with__deck_one-tag_no-title_no-qa.md');
  final File deckMultipleTagsNoTitleNoQaFile =
      File('test/fixtures/file_with__deck_multiple-tags_no-title_no-qa.md');
  final File deckMultipleTagsTitleNoQaFile =
      File('test/fixtures/file_with__deck_multiple-tags_title_no-qa.md');
  final File deckMultipleTagsTitleOneQaFile =
      File('test/fixtures/file_with__deck_multiple-tags_title_one-qa.md');
  final File deckMultipleTagsTitleMultipleQaFile =
      File('test/fixtures/file_with__deck_multiple-tags_title_multiple-qa.md');

  late MockMarkdownFilePickerLocalDataSource mock;
  late NoteRepository repository;

  setUp(() {
    mock = MockMarkdownFilePickerLocalDataSource();
    repository = NoteRepository(localDataSource: mock);
  });

  group('call()', () {
    test(
        'GIVEN the user does not select a Markdown file, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        "AND return 'null'", () async {
      const Note? expected = null;
      when(() => mock.getFile()).thenAnswer((_) async => null);

      final Note? result = await repository.getNote();

      expect(result, expected);
      verify(() => mock.getFile()).called(1);
    });

    test(
        'GIVEN the user selects an incorrectly formatted Markdown file, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        'AND throw a ConversionException', () async {
      File file = noDeckNoTagsNoTitleNoQaFile;
      NoteEntity entity = NoteEntity(
        fileContents: file.readAsStringSync(),
      );
      when(() => mock.getFile()).thenAnswer((_) async => entity);

      final Future<Note?> Function() result = repository.getNote;

      expect(() async => await result(), throwsA(isA<ConversionException>()));
      verify(() => mock.getFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name, no tags, and no QA pairs, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        'AND throw a ConversionException', () async {
      File file = deckNoTagsNoTitleNoQaFile;
      NoteEntity entity = NoteEntity(
        fileContents: file.readAsStringSync(),
      );
      when(() => mock.getFile()).thenAnswer((_) async => entity);

      final Future<Note?> Function() result = repository.getNote;

      expect(() async => await result(), throwsA(isA<ConversionException>()));
      verify(() => mock.getFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name, one tag, and no QA pairs, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        'AND throw a ConversionException', () async {
      File file = deckOneTagNoTitleNoQaFile;
      NoteEntity entity = NoteEntity(
        fileContents: file.readAsStringSync(),
      );
      when(() => mock.getFile()).thenAnswer((_) async => entity);

      final Future<Note?> Function() result = repository.getNote;

      expect(() async => await result(), throwsA(isA<ConversionException>()));
      verify(() => mock.getFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name and multiple tags, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        "AND return 'Note'", () async {
      File file = deckMultipleTagsNoTitleNoQaFile;
      NoteEntity entity = NoteEntity(
        fileContents: file.readAsStringSync(),
      );
      when(() => mock.getFile()).thenAnswer((_) async => entity);

      final Future<Note?> Function() result = repository.getNote;

      expect(() async => await result(), throwsA(isA<ConversionException>()));
      verify(() => mock.getFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name and multiple tags, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        "AND return 'Note'", () async {
      File file = deckMultipleTagsTitleNoQaFile;
      NoteEntity entity = NoteEntity(
        fileContents: file.readAsStringSync(),
      );
      when(() => mock.getFile()).thenAnswer((_) async => entity);

      final Future<Note?> Function() result = repository.getNote;

      expect(() async => await result(), throwsA(isA<ConversionException>()));
      verify(() => mock.getFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name, multiple tags, and one question/answer pair, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        "AND return 'Note'", () async {
      File file = deckMultipleTagsTitleOneQaFile;
      NoteEntity entity = NoteEntity(
        fileContents: file.readAsStringSync(),
      );
      Note expected = const Note(
        title: 'Title',
        deck: 'test deck',
        tags: ['test-tag1', 'test-tag2', 'test-tag3'],
        questionAnswerPairs: [
          QuestionAnswerPair(
            question: 'Test question 1',
            answer: 'Test answer 1',
          ),
        ],
      );
      when(() => mock.getFile()).thenAnswer((_) async => entity);

      final Note? result = await repository.getNote();

      expect(result, expected);
      verify(() => mock.getFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name, multiple tags, and multiple question/answer pairs, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        "AND return 'Note'", () async {
      File file = deckMultipleTagsTitleMultipleQaFile;
      NoteEntity entity = NoteEntity(
        fileContents: file.readAsStringSync(),
      );
      Note expected = const Note(
        title: 'Title',
        deck: 'test deck',
        tags: ['test-tag1', 'test-tag2', 'test-tag3'],
        questionAnswerPairs: [
          QuestionAnswerPair(
            question: 'Test question 1',
            answer: 'Test answer 1',
          ),
          QuestionAnswerPair(
            question: 'Test question 2',
            answer: 'Test answer 2',
          ),
          QuestionAnswerPair(
            question: 'Test question 3',
            answer: 'Test answer 3',
          ),
        ],
      );
      when(() => mock.getFile()).thenAnswer((_) async => entity);

      final Note? result = await repository.getNote();

      expect(result, expected);
      verify(() => mock.getFile()).called(1);
    });
  });
}
