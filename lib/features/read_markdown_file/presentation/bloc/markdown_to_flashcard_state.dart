import 'package:equatable/equatable.dart';

import '../../domain/entities/note.dart';

enum GetMarkdownFilesStatus {
  initial,
  loading,
  success,
  failure,
  cancelled,
}

class MarkdownToFlashcardState extends Equatable {
  final GetMarkdownFilesStatus status;
  final List<Note> notes;
  final Exception? exception;

  const MarkdownToFlashcardState({
    this.status = GetMarkdownFilesStatus.initial,
    this.notes = const [],
    this.exception,
  });

  MarkdownToFlashcardState copyWith({
    GetMarkdownFilesStatus? status,
    List<Note>? notes,
    Exception? exception,
  }) {
    return MarkdownToFlashcardState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, notes, exception];
}
