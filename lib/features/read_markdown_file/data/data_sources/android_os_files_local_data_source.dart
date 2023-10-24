import 'package:flutter/services.dart';

import '../entities/note_entity.dart';
import 'markdown_files_local_data_source.dart';

class AndroidOSFilesLocalDataSource implements MarkdownFilesLocalDataSource {
  final MethodChannel methodChannel;

  AndroidOSFilesLocalDataSource({required this.methodChannel});

  @override
  Future<NoteEntity?> getFile() async {
    Map? result = await methodChannel.invokeMethod('pickFile');

    if (result != null) {
      Map<String, String> file = Map.from(result);

      return NoteEntity(
        uri: file['uri'],
        fileContents: file['fileContents']!,
      );
    } else {
      return null;
    }
  }
}
