import 'package:flutter/services.dart';

class RequestAnkidroidPermissionUseCase {
  final MethodChannel methodChannel;

  RequestAnkidroidPermissionUseCase({required this.methodChannel});

  Future<void> call() async {
    await methodChannel.invokeMethod('requestPermissions');
  }
}
