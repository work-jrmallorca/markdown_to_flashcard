import 'package:equatable/equatable.dart';

import '../../domain/entities/note.dart';

enum GetMarkdownFileStatus {
  initial,
  loading,
  success,
  failure,
  cancelled,
}

class MarkdownToFlashcardState extends Equatable {
  final GetMarkdownFileStatus status;
  final Note? note;
  final Exception? exception;

  const MarkdownToFlashcardState({
    this.status = GetMarkdownFileStatus.initial,
    this.note,
    this.exception,
  });

  MarkdownToFlashcardState copyWith({
    GetMarkdownFileStatus? status,
    Note? note,
    Exception? exception,
  }) {
    return MarkdownToFlashcardState(
      status: status ?? this.status,
      note: note ?? this.note,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, note, exception];
}
