import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/core/errors/exception.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/repositories/markdown_file_repository.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/question_answer_pair.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/convert_markdown_note_to_dart_note_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockMarkdownFileRepository extends Mock
    implements MarkdownFileRepository {}

void main() {
  final File noDeckNoTagsNoQaFile =
      File('test/fixtures/file_with__deck_no-tags_no-qa.md');
  final File deckNoTagsNoQaFile =
      File('test/fixtures/file_with__deck_no-tags_no-qa.md');
  final File deckOneTagNoQaFile =
      File('test/fixtures/file_with__deck_one-tag_no-qa.md');
  final File deckMultipleTagsNoQaFile =
      File('test/fixtures/file_with__deck_multiple-tags_no-qa.md');
  final File deckMultipleTagsOneQaFile =
      File('test/fixtures/file_with__deck_multiple-tags_one-qa.md');
  final File deckMultipleTagsMultipleQaFile =
      File('test/fixtures/file_with__deck_multiple-tags_multiple-qa.md');

  late MockMarkdownFileRepository mock;
  late ConvertMarkdownNoteToDartNoteUseCase useCase;

  setUp(() {
    mock = MockMarkdownFileRepository();
    useCase = ConvertMarkdownNoteToDartNoteUseCase(repository: mock);
  });

  group('call()', () {
    test(
        'GIVEN the user does not select a Markdown file, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        "AND return 'null'", () async {
      const Note? expected = null;
      when(() => mock.getMarkdownFile()).thenAnswer((_) async => null);

      final Note? result = await useCase();

      expect(result, expected);
      verify(() => mock.getMarkdownFile()).called(1);
    });

    test(
        'GIVEN the user selects an incorrectly formatted Markdown file, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        'AND throw a ConversionException', () async {
      File file = noDeckNoTagsNoQaFile;
      when(() => mock.getMarkdownFile()).thenAnswer((_) async => file);

      final Future<Note?> Function() result = useCase.call;

      expect(() async => await result(), throwsA(isA<ConversionException>()));
      verify(() => mock.getMarkdownFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name, no tags, and no QA pairs, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        'AND throw a ConversionException', () async {
      File file = deckNoTagsNoQaFile;

      when(() => mock.getMarkdownFile()).thenAnswer((_) async => file);

      final Future<Note?> Function() result = useCase.call;

      expect(() async => await result(), throwsA(isA<ConversionException>()));
      verify(() => mock.getMarkdownFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name, one tag, and no QA pairs, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        'AND throw a ConversionException', () async {
      File file = deckOneTagNoQaFile;

      when(() => mock.getMarkdownFile()).thenAnswer((_) async => file);

      final Future<Note?> Function() result = useCase.call;

      expect(() async => await result(), throwsA(isA<ConversionException>()));
      verify(() => mock.getMarkdownFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name and multiple tags, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        "AND return 'Note'", () async {
      File file = deckMultipleTagsNoQaFile;
      when(() => mock.getMarkdownFile()).thenAnswer((_) async => file);

      final Future<Note?> Function() result = useCase.call;

      expect(() async => await result(), throwsA(isA<ConversionException>()));
      verify(() => mock.getMarkdownFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name, multiple tags, and one question/answer pair, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        "AND return 'Note'", () async {
      File file = deckMultipleTagsOneQaFile;
      Note expected = Note(
        fileName: file.path.split('/').last,
        deck: 'test deck',
        tags: const ['test-tag1', 'test-tag2', 'test-tag3'],
        questionAnswerPairs: const [
          QuestionAnswerPair(
            question: 'Test question 1',
            answer: 'Test answer 1',
          ),
        ],
      );
      when(() => mock.getMarkdownFile()).thenAnswer((_) async => file);

      final Note? result = await useCase();

      expect(result, expected);
      verify(() => mock.getMarkdownFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name, multiple tags, and multiple question/answer pairs, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        "AND return 'Note'", () async {
      File file = deckMultipleTagsMultipleQaFile;

      Note expected = Note(
        fileName: file.path.split('/').last,
        deck: 'test deck',
        tags: const ['test-tag1', 'test-tag2', 'test-tag3'],
        questionAnswerPairs: const [
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
      when(() => mock.getMarkdownFile()).thenAnswer((_) async => file);

      final Note? result = await useCase();

      expect(result, expected);
      verify(() => mock.getMarkdownFile()).called(1);
    });
  });
}
