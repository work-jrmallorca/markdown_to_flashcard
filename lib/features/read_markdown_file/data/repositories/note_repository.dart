import 'package:markdown_to_flashcard/features/read_markdown_file/data/entities/note_entity.dart';

import '../../../../core/errors/exception.dart';
import '../../domain/entities/note.dart';
import '../../domain/entities/question_answer_pair.dart';
import '../data_sources/markdown_files_local_data_source.dart';

class NoteRepository {
  final MarkdownFilesLocalDataSource localDataSource;

  NoteRepository({required this.localDataSource});

  Future<Note?> getNote() async {
    NoteEntity? entity = await localDataSource.getFile();

    return entity != null
        ? Note(
            uri: entity.uri,
            fileName: entity.fileName,
            deck: _getDeck(entity.fileContents),
            tags: _getTags(entity.fileContents),
            questionAnswerPairs: _getQuestionAnswerPairs(entity.fileContents),
          )
        : null;
  }

  String _getDeck(String fileContents) {
    RegExp regex = RegExp(r'deck: ([^\n]+)');

    return regex.firstMatch(fileContents)?.group(1) ??
        (throw ConversionException(
          message:
              'Unable to detect deck in the file. Please format deck into "deck: <some_deck_name>"',
        ));
  }

  List<String> _getTags(String fileContents) {
    RegExp regex = RegExp(r'tags: \[(.*)\]');
    String? regexResult = regex.firstMatch(fileContents)?.group(1)!;

    if (regexResult != null) {
      List<String> trimmedTags =
          regexResult.split(',').map((e) => e.trim()).toList();

      return regexResult.isEmpty ? [] : trimmedTags;
    } else {
      throw ConversionException(
        message:
            'Unable to detect tags in the file. Please format tags into a comma-separated list "tags: <first_tag>, <second_tag> ... <last_tag>"',
      );
    }
  }

  List<QuestionAnswerPair> _getQuestionAnswerPairs(String fileContents) {
    RegExp regex = RegExp(r'.* :: .*');
    Iterable<RegExpMatch> regexResult = regex.allMatches(fileContents);

    return regexResult.isNotEmpty
        ? regexResult.map((match) {
            List<String> qaPair = match.group(0)!.split(' :: ');
            return QuestionAnswerPair(
                question: qaPair.first, answer: qaPair.last);
          }).toList()
        : throw ConversionException(
            message:
                'Unable to detect any question-answer pairs in the file. Please format question-answer pairs into "Question :: Answer"',
          );
  }
}
