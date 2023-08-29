import 'package:file_picker/file_picker.dart';

// The result will be null, if the user aborted the dialog
class MarkdownFilePickerLocalDataSource {
  Future<FilePickerResult?> call() async => await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['md'],
      );
}
