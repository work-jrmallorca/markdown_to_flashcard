import 'package:flutter/services.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/question_answer_pair.dart';

import '../entities/note.dart';

class AddQuestionAnswerPairsInNoteToAnkidroidUseCase {
  final MethodChannel methodChannel;

  AddQuestionAnswerPairsInNoteToAnkidroidUseCase({required this.methodChannel});

  Future<void> call(Note note) async {
    if (note.questionAnswerPairs.isNotEmpty) {
      List<List<String>> fieldsList = [];
      List<List<String>> tagsList = [];

      for (QuestionAnswerPair qaPair in note.questionAnswerPairs) {
        fieldsList.add([qaPair.question, qaPair.answer, note.title]);
        tagsList.add(note.tags);
      }

      await methodChannel.invokeMethod(
        'addAnkiNotes',
        <String, dynamic>{
          'deck': note.deck,
          'fields': fieldsList,
          'tags': tagsList,
        },
      );
    }
  }
}
