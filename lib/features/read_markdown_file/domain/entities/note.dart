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

  Note copyWith({
    fileName,
    deck,
    tags,
    questionAnswerPairs,
  }) =>
      Note(
        fileName: fileName ?? this.fileName,
        deck: deck ?? this.deck,
        tags: tags ?? this.tags,
        questionAnswerPairs: questionAnswerPairs ?? this.questionAnswerPairs,
      );

  @override
  List<Object?> get props => [
        fileName,
        deck,
        tags,
        questionAnswerPairs,
      ];
}
