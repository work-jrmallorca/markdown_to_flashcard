import 'package:equatable/equatable.dart';

class NoteEntity extends Equatable {
  final String? uri;
  final String fileContents;

  const NoteEntity({
    this.uri,
    required this.fileContents,
  });

  NoteEntity copyWith({
    String? uri,
    String? fileContents,
  }) =>
      NoteEntity(
        uri: uri ?? this.uri,
        fileContents: fileContents ?? this.fileContents,
      );

  @override
  List<Object?> get props => [
        uri,
        fileContents,
      ];
}
