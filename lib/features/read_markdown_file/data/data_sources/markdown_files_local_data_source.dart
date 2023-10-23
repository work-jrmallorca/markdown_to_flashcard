import 'package:markdown_to_flashcard/features/read_markdown_file/data/entities/note_entity.dart';

// The result will be null, if the user aborted the dialog
abstract class MarkdownFilesLocalDataSource {
  Future<NoteEntity?> getFile();
}
