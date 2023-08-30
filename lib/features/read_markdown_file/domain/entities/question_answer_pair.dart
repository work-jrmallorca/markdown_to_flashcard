import 'package:equatable/equatable.dart';

class QuestionAnswerPair extends Equatable {
  final String question;
  final String answer;

  const QuestionAnswerPair({required this.question, required this.answer});

  @override
  List<Object?> get props => [question, answer];
}
