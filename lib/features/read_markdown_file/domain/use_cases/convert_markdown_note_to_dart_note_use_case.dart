import 'dart:io';

import 'package:markdown_to_flashcard/features/read_markdown_file/domain/entities/note.dart';

import '../../data/repositories/markdown_file_repository.dart';
import '../entities/question_answer_pair.dart';

class ConvertMarkdownNoteToDartNoteUseCase {
  final MarkdownFileRepository repository;

  ConvertMarkdownNoteToDartNoteUseCase({required this.repository});

  Future<Note?> call() async {
    File? file = await repository.getMarkdownFile();

    if (file != null) {
      String fileContents = await file.readAsString();

      return Note(
        fileName: _getFileName(file.path),
        deck: _getDeck(fileContents),
        tags: _getTags(fileContents),
        questionAnswerPairs: _getQuestionAnswerPairs(fileContents),
      );
    } else {
      return null;
    }
  }

  String _getFileName(String path) => path.split('/').last;

  String _getDeck(String fileContents) {
    RegExp regex = RegExp(r'deck: ([^\n]+)');

    return regex.firstMatch(fileContents)!.group(1)!;
  }

  List<String> _getTags(String fileContents) {
    RegExp regex = RegExp(r'tags: \[(.*)\]');
    String regexResult = regex.firstMatch(fileContents)!.group(1)!;
    List<String> trimmedTags =
        regexResult.split(',').map((e) => e.trim()).toList();

    return regexResult.isEmpty ? [] : trimmedTags;
  }

  List<QuestionAnswerPair> _getQuestionAnswerPairs(String fileContents) {
    RegExp regex = RegExp(r'.* :: .*');
    Iterable<RegExpMatch> regexResult = regex.allMatches(fileContents);

    return regexResult.isEmpty
        ? []
        : regexResult.map((match) {
            List<String> qaPair = match.group(0)!.split(' :: ');
            return QuestionAnswerPair(
                question: qaPair.first, answer: qaPair.last);
          }).toList();
  }
}
