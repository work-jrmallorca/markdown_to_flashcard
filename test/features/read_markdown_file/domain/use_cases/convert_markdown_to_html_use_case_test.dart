import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/convert_markdown_to_html_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockMarkdownToHTMLProxy extends Mock implements MarkdownToHTMLProxy {}

void main() {
  final File deckMultipleTagsTitleOneQaDecoratedFile = File(
      'test/fixtures/file_with__deck_multiple-tags_title_one-qa_decorated.md');
  final File deckMultipleTagsTitleOneQaHTMLFile =
      File('test/fixtures/file_with__deck_multiple-tags_title_one-qa_html.md');
  final File deckMultipleTagsTitleMultipleQaDecoratedFile = File(
      'test/fixtures/file_with__deck_multiple-tags_title_multiple-qa_decorated.md');
  final File deckMultipleTagsTitleMultipleQaHTMLFile = File(
      'test/fixtures/file_with__deck_multiple-tags_title_multiple-qa_html.md');
  final File deckMultipleTagsTitleMultipleQaWithIDsDecoratedFile = File(
      'test/fixtures/file_with__deck_multiple-tags_title_multiple-qa-with-ids_decorated.md');
  final File deckMultipleTagsTitleMultipleQaWithIDsHTMLFile = File(
      'test/fixtures/file_with__deck_multiple-tags_title_multiple-qa-with-ids_html.md');

  group('GIVEN MarkdownToHTML is mocked', () {
    late ConvertMarkdownToHTMLUseCase useCase;
    late MockMarkdownToHTMLProxy mock;

    setUp(() {
      mock = MockMarkdownToHTMLProxy();
      useCase = ConvertMarkdownToHTMLUseCase(markdownToHTMLProxy: mock);
    });

    test(
        'AND a note with flashcards with no IDs is given, '
        "WHEN 'call()' is called, "
        'THEN return the flashcards as HTML', () async {
      Note original = Note(
          fileContents:
              deckMultipleTagsTitleOneQaDecoratedFile.readAsStringSync());
      Note expected = Note(
          fileContents: deckMultipleTagsTitleOneQaHTMLFile.readAsStringSync());
      when(() => mock(any())).thenReturn(
          '<p>Test <strong>question</strong> :: Test <strong>answer</strong></p>');

      Note result = useCase(original);

      expect(result, expected);
    });
  });

  group('GIVEN MarkdownToHTML is not mocked', () {
    late ConvertMarkdownToHTMLUseCase useCase;
    late MarkdownToHTMLProxy proxy;

    setUp(() {
      proxy = MarkdownToHTMLProxy();
      useCase = ConvertMarkdownToHTMLUseCase(markdownToHTMLProxy: proxy);
    });

    test(
        'AND a note with flashcards with no IDs is given, '
        "WHEN 'call()' is called, "
        'THEN return the flashcards as HTML', () async {
      Note original = Note(
          fileContents:
              deckMultipleTagsTitleMultipleQaDecoratedFile.readAsStringSync());
      Note expected = Note(
          fileContents:
              deckMultipleTagsTitleMultipleQaHTMLFile.readAsStringSync());

      Note result = useCase(original);

      expect(result, expected);
    });

    test(
        'AND a note with flashcards with IDs is given, '
        "WHEN 'call()' is called, "
        'THEN return the flashcards as HTML', () async {
      Note original = Note(
          fileContents: deckMultipleTagsTitleMultipleQaWithIDsDecoratedFile
              .readAsStringSync());
      Note expected = Note(
          fileContents: deckMultipleTagsTitleMultipleQaWithIDsHTMLFile
              .readAsStringSync());

      Note result = useCase(original);

      expect(result, expected);
    });
  });
}
