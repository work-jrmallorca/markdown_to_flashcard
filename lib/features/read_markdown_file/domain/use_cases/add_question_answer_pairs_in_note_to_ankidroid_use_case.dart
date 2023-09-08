import 'package:flutter/services.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/question_answer_pair.dart';

import '../entities/note.dart';

class AddQuestionAnswerPairsInNoteToAnkidroidUseCase {
  final MethodChannel methodChannel;

  AddQuestionAnswerPairsInNoteToAnkidroidUseCase({required this.methodChannel});

  Future<List<int>> call(Note note) async {
    List<int> createdNoteIds = [];

    for (QuestionAnswerPair qaPair in note.questionAnswerPairs) {
      int createdNoteId = await methodChannel.invokeMethod(
        'addAnkiNote',
        <String, dynamic>{
          'deck': note.deck,
          'question': qaPair.question,
          'answer': qaPair.answer,
          'source': note.fileName,
          'tags': note.tags,
        },
      );

      createdNoteIds.add(createdNoteId);
    }

    return createdNoteIds;
  }
}
