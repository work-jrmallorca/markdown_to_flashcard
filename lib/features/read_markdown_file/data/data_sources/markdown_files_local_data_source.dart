import 'dart:io';

// The result will be null, if the user aborted the dialog
abstract class MarkdownFilesLocalDataSource {
  Future<File?> getFile();
}
