import '../../domain/entities/note.dart';
import '../data_sources/markdown_files_local_data_source.dart';

class NoteRepository {
  final MarkdownFilesLocalDataSource localDataSource;

  NoteRepository({required this.localDataSource});

  Future<Note?> getNote() async => await localDataSource.getFile();

  Future<void> updateNote(Note note) async =>
      await localDataSource.updateFile(note);
}
