import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_to_flashcard/features/read_markdown_file/domain/use_cases/request_ankidroid_permission_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  late MockMethodChannel mock;
  late RequestAnkidroidPermissionUseCase useCase;

  setUp(() {
    mock = MockMethodChannel();
    useCase = RequestAnkidroidPermissionUseCase(methodChannel: mock);
  });

  group('call()', () {
    test(
        'GIVEN the app has started and is requesting Ankidroid permissions, '
        "WHEN 'call()' is called from the use case, "
        "THEN call 'invokeMethod()' once from the method channel, ", () async {
      when(() => mock.invokeMethod(any())).thenAnswer((_) async => null);

      await useCase();

      verify(() => mock.invokeMethod(any())).called(1);
    });
  });
}
