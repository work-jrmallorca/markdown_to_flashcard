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
      onMatch: (match) => markdownToHTMLProxy(match.group(0)!),
    );

    return note.copyWith(fileContents: newFileContents);
  }
}
