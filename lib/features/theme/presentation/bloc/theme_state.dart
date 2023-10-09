import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ThemeStatus {
  light,
  dark,
  amoled,
}

class ThemeState extends Equatable {
  final ThemeStatus status;
  final ThemeData themeData;

  const ThemeState({required this.status, required this.themeData});

  @override
  List<Object?> get props => [status, themeData];
}
