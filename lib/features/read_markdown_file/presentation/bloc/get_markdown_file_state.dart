import 'dart:io';

import 'package:equatable/equatable.dart';

enum GetMarkdownFileStatus { initial, loading, success, failure }

class GetMarkdownFileState extends Equatable {
  final GetMarkdownFileStatus status;
  final File? file;
  final Exception? exception;

  const GetMarkdownFileState({
    this.status = GetMarkdownFileStatus.initial,
    this.file,
    this.exception,
  });

  GetMarkdownFileState copyWith({
    GetMarkdownFileStatus? status,
    File? file,
    Exception? exception,
  }) {
    return GetMarkdownFileState(
      status: status ?? this.status,
      file: file ?? this.file,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, file, exception];
}
