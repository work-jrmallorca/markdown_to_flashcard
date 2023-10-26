import 'package:flutter/services.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/question_answer_pair.dart';

import '../entities/note.dart';

class CreateOrUpdateFlashcardsInNoteToAnkidroidUseCase {
  final MethodChannel methodChannel;

  CreateOrUpdateFlashcardsInNoteToAnkidroidUseCase(
      {required this.methodChannel});

  Future<List<int>> call(Note note) async {
    List<int> createdNoteIds = [];

    for (QuestionAnswerPair qaPair in note.questionAnswerPairs) {
      if (qaPair.id != null) {
        await methodChannel.invokeMethod(
          'updateAnkiFlashcard',
          <String, dynamic>{
            'id': qaPair.id,
            'question': qaPair.question,
            'answer': qaPair.answer,
            'source': note.title,
            'tags': note.tags,
          },
        );
      } else {
        int createdNoteId = await methodChannel.invokeMethod(
          'addAnkiFlashcard',
          <String, dynamic>{
            'deck': note.deck,
            'question': qaPair.question,
            'answer': qaPair.answer,
            'source': note.title,
            'tags': note.tags,
          },
        );

        createdNoteIds.add(createdNoteId);
      }
    }

    return createdNoteIds;
  }
}
