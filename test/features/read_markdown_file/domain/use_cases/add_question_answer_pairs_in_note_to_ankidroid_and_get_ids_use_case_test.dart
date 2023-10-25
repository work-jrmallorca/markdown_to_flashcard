import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/core/errors/exception.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/add_question_answer_pairs_in_note_to_ankidroid_and_get_ids_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  Note emptyNote = Note(
    fileContents:
        File('test/fixtures/file_with__deck_multiple-tags_title_no-qa.md')
            .readAsStringSync(),
  );
  Note noteWithMultipleQAPairs = Note(
    fileContents:
        File('test/fixtures/file_with__deck_multiple-tags_title_multiple-qa.md')
            .readAsStringSync(),
  );

  late MockMethodChannel mock;
  late AddQuestionAnswerPairsInNoteToAnkidroidAndGetIDsUseCase useCase;

  setUp(() {
    mock = MockMethodChannel();
    useCase = AddQuestionAnswerPairsInNoteToAnkidroidAndGetIDsUseCase(
        methodChannel: mock);
  });

  group('call()', () {
    test(
        'GIVEN a note has no question-answer pairs, '
        "WHEN 'call()' is called from the use case, "
        "THEN don't call 'invokeMethod()' from the method channel, "
        'AND return an empty list.', () async {
      Note note = emptyNote;

      final Future<void> Function(Note note) result = useCase.call;

      expect(
        () async => await result(note),
        throwsA(isA<ConversionException>()),
      );
      verifyZeroInteractions(mock);
    });

    test(
        'GIVEN the method channel throws an exception, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'invokeMethod()' once from the method channel, "
        'AND throw an exception.', () async {
      Note note = noteWithMultipleQAPairs;
      when(() => mock.invokeMethod(any(), any()))
          .thenThrow(PlatformException(code: ''));

      final Future<List<int>> Function(Note note) result = useCase.call;

      expect(
        () async => await result(note),
        throwsA(isA<PlatformException>()),
      );
      verify(() => mock.invokeMethod(any(), any())).called(1);
    });

    test(
        'GIVEN a note has multiple question-answer pairs, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'invokeMethod()' multiple times from the method channel, "
        'AND return a list with multiple note IDs.', () async {
      Note note = noteWithMultipleQAPairs;
      when(() => mock.invokeMethod(any(), any()))
          .thenAnswer((_) async => Random().nextInt(10));

      final List<int> result = await useCase(note);

      expect(result.length, note.questionAnswerPairs.length);
      verify(() => mock.invokeMethod(any(), any())).called(3);
    });
  });
}
