import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/add_flashcard_ids_to_note_use_case.dart';

void main() {
  final File deckMultipleTagsTitleMultipleQaFile =
      File('test/fixtures/file_with__deck_multiple-tags_title_multiple-qa.md');
  final File deckMultipleTagsTitleMultipleQaWithIdsFile = File(
      'test/fixtures/file_with__deck_multiple-tags_title_multiple-qa-with-ids.md');

  late AddFlashcardIDsToNoteUseCase useCase;

  setUp(() {
    useCase = AddFlashcardIDsToNoteUseCase();
  });

  group('call()', () {
    test(
        'GIVEN a note with question answer pairs with no IDs, '
        "WHEN 'call()' is called, "
        'THEN return the note\'s question answer pairs ', () async {
      Note original = Note(
          fileContents: deckMultipleTagsTitleMultipleQaFile.readAsStringSync());
      Note expected = Note(
          fileContents:
              deckMultipleTagsTitleMultipleQaWithIdsFile.readAsStringSync());

      Note result = useCase(original, [123, 456, 789]);

      expect(result, expected);
    });
  });
}
