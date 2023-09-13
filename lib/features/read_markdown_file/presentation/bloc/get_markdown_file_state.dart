import 'package:equatable/equatable.dart';

import '../../domain/entities/note.dart';

enum GetMarkdownFileStatus {
  initial,
  loading,
  success,
  failure,
  cancelled,
}

class GetMarkdownFileState extends Equatable {
  final GetMarkdownFileStatus status;
  final Note? note;
  final Exception? exception;

  const GetMarkdownFileState({
    this.status = GetMarkdownFileStatus.initial,
    this.note,
    this.exception,
  });

  GetMarkdownFileState copyWith({
    GetMarkdownFileStatus? status,
    Note? note,
    Exception? exception,
  }) {
    return GetMarkdownFileState(
      status: status ?? this.status,
      note: note ?? this.note,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, note, exception];
}
