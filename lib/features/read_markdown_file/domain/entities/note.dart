import 'package:equatable/equatable.dart';

import 'question_answer_pair.dart';

class Note extends Equatable {
  final String fileName;
  final String deck;
  final List<String> tags;
  final List<QuestionAnswerPair> questionAnswerPairs;

  const Note({
    required this.fileName,
    required this.deck,
    required this.tags,
    required this.questionAnswerPairs,
  });

  @override
  List<Object?> get props => [
        fileName,
        deck,
        tags,
        questionAnswerPairs,
      ];
}
