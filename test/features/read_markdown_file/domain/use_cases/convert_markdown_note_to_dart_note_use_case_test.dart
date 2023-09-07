import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/repositories/markdown_file_repository.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/question_answer_pair.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/convert_markdown_note_to_dart_note_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockMarkdownFileRepository extends Mock
    implements MarkdownFileRepository {}

void main() {
  final File deckAndEmptyTagsFile =
      File('test/fixtures/file_with__deck_empty-tags.md');
  final File deckAndOneTagFile =
      File('test/fixtures/file_with__deck_one-tag.md');
  final File deckAndMultipleTagsFile =
      File('test/fixtures/file_with__deck_multiple-tags.md');
  final File deckMultipleTagsAndOneQaPairFile =
      File('test/fixtures/file_with__deck_multiple-tags_one-qa.md');
  final File deckMultipleTagsAndMultipleQaPairFile =
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
        'AND throw an exception', () async {
      when(() => mock.getMarkdownFile()).thenThrow(Exception());

      final Future<Note?> Function() result = useCase.call;

      expect(() async => await result(), throwsA(isA<Exception>()));
      verify(() => mock.getMarkdownFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name and empty tags, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        "AND return 'Note'", () async {
      File file = deckAndEmptyTagsFile;

      Note expected = Note(
        fileName: file.path.split('/').last,
        deck: 'test deck',
        tags: const {},
        questionAnswerPairs: const [],
      );
      when(() => mock.getMarkdownFile()).thenAnswer((_) async => file);

      final Note? result = await useCase();

      expect(result, expected);
      verify(() => mock.getMarkdownFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name and one tag, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        "AND return 'Note'", () async {
      File file = deckAndOneTagFile;

      Note expected = Note(
        fileName: file.path.split('/').last,
        deck: 'test deck',
        tags: const {'test-tag1'},
        questionAnswerPairs: const [],
      );
      when(() => mock.getMarkdownFile()).thenAnswer((_) async => file);

      final Note? result = await useCase();

      expect(result, expected);
      verify(() => mock.getMarkdownFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name and multiple tags, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        "AND return 'Note'", () async {
      File file = deckAndMultipleTagsFile;
      Note expected = Note(
        fileName: file.path.split('/').last,
        deck: 'test deck',
        tags: const {'test-tag1', 'test-tag2', 'test-tag3'},
        questionAnswerPairs: const [],
      );
      when(() => mock.getMarkdownFile()).thenAnswer((_) async => file);

      final Note? result = await useCase();

      expect(result, expected);
      verify(() => mock.getMarkdownFile()).called(1);
    });

    test(
        'GIVEN the user selects a correctly formatted Markdown file with a deck name, multiple tags, and one question/answer pair, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'getMarkdownFile()' once from the repository, "
        "AND return 'Note'", () async {
      File file = deckMultipleTagsAndOneQaPairFile;
      Note expected = Note(
        fileName: file.path.split('/').last,
        deck: 'test deck',
        tags: const {'test-tag1', 'test-tag2', 'test-tag3'},
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
      File file = deckMultipleTagsAndMultipleQaPairFile;

      Note expected = Note(
        fileName: file.path.split('/').last,
        deck: 'test deck',
        tags: const {'test-tag1', 'test-tag2', 'test-tag3'},
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
