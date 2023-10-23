import 'package:equatable/equatable.dart';

import 'question_answer_pair.dart';

class Note extends Equatable {
  final String? uri;
  final String fileName;
  final String deck;
  final List<String> tags;
  final List<QuestionAnswerPair> questionAnswerPairs;

  const Note({
    this.uri,
    required this.fileName,
    required this.deck,
    required this.tags,
    required this.questionAnswerPairs,
  });

  Note copyWith({
    String? uri,
    String? fileName,
    String? deck,
    List<String>? tags,
    List<QuestionAnswerPair>? questionAnswerPairs,
  }) =>
      Note(
        uri: uri ?? this.uri,
        fileName: fileName ?? this.fileName,
        deck: deck ?? this.deck,
        tags: tags ?? this.tags,
        questionAnswerPairs: questionAnswerPairs ?? this.questionAnswerPairs,
      );

  @override
  List<Object?> get props => [
        uri,
        fileName,
        deck,
        tags,
        questionAnswerPairs,
      ];
}
