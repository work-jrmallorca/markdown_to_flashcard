import 'dart:convert';

import 'package:file_picker/file_picker.dart';

import '../../domain/entities/note.dart';
import 'markdown_files_local_data_source.dart';

class PickFilesProxy {
  Future<FilePickerResult?> call() {
    return FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['md', 'txt'],
    );
  }
}

class AgnosticOSFilesLocalDataSource implements MarkdownFilesLocalDataSource {
  final PickFilesProxy pickFilesProxy;

  AgnosticOSFilesLocalDataSource({required this.pickFilesProxy});

  @override
  Future<Note?> getFile() async {
    FilePickerResult? result = await pickFilesProxy();
    if (result != null) {
      return Note(
        fileContents: utf8.decode(result.files.first.bytes!),
      );
    } else {
      return null;
    }
  }

  @override
  Future<void> updateFile(Note note) {
    // TODO: implement updateFile
    throw UnimplementedError();
  }
}
