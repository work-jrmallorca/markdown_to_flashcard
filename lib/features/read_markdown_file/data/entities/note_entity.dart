import 'package:equatable/equatable.dart';

class NoteEntity extends Equatable {
  final String? uri;
  final String fileName;
  final String fileContents;

  const NoteEntity({
    this.uri,
    required this.fileName,
    required this.fileContents,
  });

  NoteEntity copyWith({
    uri,
    fileName,
    fileContents,
  }) =>
      NoteEntity(
        uri: uri ?? this.uri,
        fileName: fileName ?? this.fileName,
        fileContents: fileContents ?? this.fileContents,
      );

  @override
  List<Object?> get props => [
        uri,
        fileName,
        fileContents,
      ];
}
