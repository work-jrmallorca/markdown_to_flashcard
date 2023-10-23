import 'package:flutter/services.dart';

import '../entities/note_entity.dart';
import 'markdown_files_local_data_source.dart';

class AndroidOSFilesLocalDataSource implements MarkdownFilesLocalDataSource {
  final MethodChannel methodChannel;

  AndroidOSFilesLocalDataSource({required this.methodChannel});

  @override
  Future<NoteEntity?> getFile() async {
    Map<String, String>? file =
        await methodChannel.invokeMethod<Map<String, String>>('pickFile');

    return file != null
        ? NoteEntity(
            uri: file['uri'],
            fileName: file['fileName']!,
            fileContents: file['fileContents']!,
          )
        : null;
  }
}
