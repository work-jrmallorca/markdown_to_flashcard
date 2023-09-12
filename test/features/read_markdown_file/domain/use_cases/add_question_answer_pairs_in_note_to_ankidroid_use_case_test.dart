import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/question_answer_pair.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/add_question_answer_pairs_in_note_to_ankidroid_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  const Note emptyNote = Note(
    fileName: 'Test file name',
    deck: 'Test deck name',
    tags: [],
    questionAnswerPairs: [],
  );

  const Note noteWithOneQAPair = Note(
    fileName: 'Test file name',
    deck: 'Test deck name',
    tags: [],
    questionAnswerPairs: [
      QuestionAnswerPair(question: 'Test question', answer: 'Test answer')
    ],
  );

  const Note noteWithMultipleQAPairs = Note(
    fileName: 'Test file name',
    deck: 'Test deck name',
    tags: [],
    questionAnswerPairs: [
      QuestionAnswerPair(question: 'Test question 1', answer: 'Test answer 1'),
      QuestionAnswerPair(question: 'Test question 2', answer: 'Test answer 2'),
      QuestionAnswerPair(question: 'Test question 3', answer: 'Test answer 3'),
    ],
  );

  late MockMethodChannel mock;
  late AddQuestionAnswerPairsInNoteToAnkidroidUseCase useCase;

  setUp(() {
    mock = MockMethodChannel();
    useCase =
        AddQuestionAnswerPairsInNoteToAnkidroidUseCase(methodChannel: mock);
  });

  group('call()', () {
    test(
        'GIVEN a note has no question-answer pairs, '
        "WHEN 'call()' is called from the use case, "
        "THEN don't call 'invokeMethod()' from the method channel, "
        'AND return an empty list.', () async {
      Note note = emptyNote;
      const List<int> expected = [];

      final List<int> result = await useCase(note);

      expect(result, expected);
      verifyZeroInteractions(mock);
    });

    test(
        'GIVEN the method channel throws an exception, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'invokeMethod()' once from the method channel, "
        'AND throw an exception.', () async {
      Note note = noteWithOneQAPair;
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
        'GIVEN a note has one question-answer pair, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'invokeMethod()' once from the method channel, "
        'AND return a list with one note ID.', () async {
      Note note = noteWithOneQAPair;
      const List<int> expected = [123];
      when(() => mock.invokeMethod(any(), any())).thenAnswer((_) async => 123);

      final List<int> result = await useCase(note);

      expect(result, expected);
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
