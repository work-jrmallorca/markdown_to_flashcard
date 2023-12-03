import '../../domain/entities/note.dart';

// The result will be null, if the user aborted the dialog
abstract class MarkdownFilesLocalDataSource {
  Future<List<Note>> getFiles();

  Future<void> updateFile(Note note);
}
