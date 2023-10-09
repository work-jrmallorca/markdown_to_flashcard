class ConversionException implements Exception {
  String? message;

  ConversionException({this.message});
}

class ThemeNotSetException implements Exception {
  String? message;

  ThemeNotSetException({this.message});
}
