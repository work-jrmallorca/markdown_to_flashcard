import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/data_sources/android_os_files_local_data_source.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/data/entities/note_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  late AndroidOSFilesLocalDataSource localDataSource;

  late MockMethodChannel mock;

  setUp(() async {
    mock = MockMethodChannel();
    localDataSource = AndroidOSFilesLocalDataSource(methodChannel: mock);
  });

  test(
      'GIVEN a file is successfully picked, '
      "WHEN 'call()' is called from the pick files proxy, "
      "THEN return 'FilePickerResult'", () async {
    Map<String, String> file = {
      'uri': 'test uri',
      'fileContents': 'test fileContents',
    };
    NoteEntity expected = NoteEntity(
      uri: file['uri'],
      fileContents: file['fileContents']!,
    );

    when(() => mock.invokeMethod<Map>(any())).thenAnswer((_) async => file);

    final NoteEntity? result = await localDataSource.getFile();

    expect(result, expected);
    verify(() => mock.invokeMethod<Map>(any())).called(1);
  });

  test(
      'GIVEN the file picker is cancelled, '
      "WHEN 'call()' is called from the pick files proxy, "
      "THEN return 'FilePickerResult'", () async {
    when(() => mock.invokeMethod<Map>(any())).thenAnswer((_) async => null);

    final NoteEntity? result = await localDataSource.getFile();

    verify(() => mock.invokeMethod<Map>(any())).called(1);
    expect(result, null);
  });
}
