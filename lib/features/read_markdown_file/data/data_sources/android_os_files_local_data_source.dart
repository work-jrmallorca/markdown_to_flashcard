import 'package:flutter/services.dart';

import '../../domain/entities/note.dart';
import 'markdown_files_local_data_source.dart';

class AndroidOSFilesLocalDataSource implements MarkdownFilesLocalDataSource {
  final MethodChannel methodChannel;

  AndroidOSFilesLocalDataSource({required this.methodChannel});

  @override
  Future<List<Note>?> getFiles() async {
    List? result = await methodChannel.invokeMethod('pickFiles');
    if (result != null) {
      List<Map<String, String>> files =
          result.map((file) => Map<String, String>.from(file)).toList();
      List<Note> notes = [];

      for (Map<String, String> file in files) {
        notes.add(
          Note(
            uri: file['uri'],
            fileContents: file['fileContents']!,
          ),
        );
      }

      return notes;
    } else {
      return null;
    }
  }

  @override
  Future<void> updateFile(Note note) async {
    await methodChannel.invokeMethod(
      'writeFile',
      <String, dynamic>{
        'uri': note.uri,
        'fileContents': note.fileContents,
      },
    );
  }
}
