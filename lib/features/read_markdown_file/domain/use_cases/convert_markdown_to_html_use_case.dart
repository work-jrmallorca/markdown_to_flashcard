import 'package:markdown/markdown.dart';

import '../entities/note.dart';

class MarkdownToHTMLProxy {
  String call(String markdown) => markdownToHtml(markdown);
}

class ConvertMarkdownToHTMLUseCase {
  final MarkdownToHTMLProxy markdownToHTMLProxy;

  ConvertMarkdownToHTMLUseCase({required this.markdownToHTMLProxy});

  Note call(Note note) {
    RegExp regex = RegExp(r'.* :: .*');

    String newFileContents = note.fileContents.splitMapJoin(
      regex,
      onMatch: (match) {
        String flashcard = match.group(0)!;
        RegExp regex = RegExp(r'^(.*?)(?:\^(\d+))?$');

        String qaPair = regex.firstMatch(flashcard)!.group(1)!;
        String? id = regex.firstMatch(flashcard)?.group(2);

        String idWithCaret = id != null ? '^$id' : '';

        return '${markdownToHTMLProxy(qaPair)}$idWithCaret'
            .replaceAll('\n', '');
      },
    );

    return note.copyWith(fileContents: newFileContents);
  }
}
