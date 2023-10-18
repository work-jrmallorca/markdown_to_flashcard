import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'markdown_file_picker_local_data_source.dart';

class PickFilesProxy {
  Future<FilePickerResult?> call() {
    return FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['md', 'txt'],
    );
  }
}

class AgnosticOSFilesLocalDataSource implements MarkdownFilesLocalDataSource {
  final PickFilesProxy pickFiles;

  AgnosticOSFilesLocalDataSource({required this.pickFiles});

  @override
  Future<File?> getFile() async {
    FilePickerResult? result = await pickFiles();

    return result != null ? File(result.files.first.path!) : null;
  }
}
