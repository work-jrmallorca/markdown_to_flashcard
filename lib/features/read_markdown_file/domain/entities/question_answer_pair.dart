import 'package:equatable/equatable.dart';

class QuestionAnswerPair extends Equatable {
  final int? id;
  final String question;
  final String answer;

  const QuestionAnswerPair({
    this.id,
    required this.question,
    required this.answer,
  });

  QuestionAnswerPair copyWith({
    id,
    question,
    answer,
  }) =>
      QuestionAnswerPair(
        id: id ?? this.id,
        question: question ?? this.question,
        answer: answer ?? this.answer,
      );

  @override
  List<Object?> get props => [id, question, answer];
}
