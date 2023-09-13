import 'package:markdown/markdown.dart';

import '../entities/note.dart';

class ConvertMarkdownToHTMLUseCase {
  Note call(Note note) => note.copyWith(
      questionAnswerPairs:
          note.questionAnswerPairs.map((qaPair) => qaPair.copyWith(
                question: markdownToHtml(qaPair.question),
                answer: markdownToHtml(qaPair.answer),
              )));
}
