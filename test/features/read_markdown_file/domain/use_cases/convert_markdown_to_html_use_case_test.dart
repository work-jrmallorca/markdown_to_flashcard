import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/convert_markdown_to_html_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockMarkdownToHTMLProxy extends Mock implements MarkdownToHTMLProxy {}

void main() {
  final File deckMultipleTagsTitleMultipleQaDecoratedFile = File(
      'test/fixtures/file_with__deck_multiple-tags_title_multiple-qa_decorated.md');
  final File deckMultipleTagsTitleMultipleQaHTMLFile = File(
      'test/fixtures/file_with__deck_multiple-tags_title_multiple-qa_html.md');

  late ConvertMarkdownToHTMLUseCase useCase;
  late MockMarkdownToHTMLProxy mock;

  setUp(() {
    mock = MockMarkdownToHTMLProxy();
    useCase = ConvertMarkdownToHTMLUseCase(markdownToHTMLProxy: mock);
  });

  group('call()', () {
    test(
        'GIVEN a note with question answer pairs with no IDs, '
        "WHEN 'call()' is called, "
        'THEN return the note as HTML', () async {
      Note original = Note(
          fileContents:
              deckMultipleTagsTitleMultipleQaDecoratedFile.readAsStringSync());
      Note expected = Note(
          fileContents:
              deckMultipleTagsTitleMultipleQaHTMLFile.readAsStringSync());
      when(() => mock(any()))
          .thenReturn('<p>Test <em>question</em> :: Test <em>answer</em></p>');

      Note result = useCase(original);

      expect(result, expected);
    });
  });
}
