import 'package:equatable/equatable.dart';

import 'question_answer_pair.dart';

class Note extends Equatable {
  final String? uri;
  final String title;
  final String deck;
  final List<String> tags;
  final List<QuestionAnswerPair> questionAnswerPairs;

  const Note({
    this.uri,
    required this.title,
    required this.deck,
    required this.tags,
    required this.questionAnswerPairs,
  });

  Note copyWith({
    String? uri,
    String? title,
    String? deck,
    List<String>? tags,
    List<QuestionAnswerPair>? questionAnswerPairs,
  }) =>
      Note(
        uri: uri ?? this.uri,
        title: title ?? this.title,
        deck: deck ?? this.deck,
        tags: tags ?? this.tags,
        questionAnswerPairs: questionAnswerPairs ?? this.questionAnswerPairs,
      );

  @override
  List<Object?> get props => [
        uri,
        title,
        deck,
        tags,
        questionAnswerPairs,
      ];
}
