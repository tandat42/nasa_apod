import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/core/services/api_service.dart';
import 'package:nasa_apod/di.dart';
import 'package:nasa_apod/ui/screens/main/providers/latest_apod_provider.dart';

import 'main_screen_provider_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late MockApiService mockApiService;
  late ProviderContainer container;

  setUp(() {
    mockApiService = MockApiService();

    // Register mock service with dependency injection
    getIt.registerSingleton<ApiService>(mockApiService);

    // Create a Riverpod container
    container = ProviderContainer(retry: (_, _) => null);
  });

  tearDown(() async {
    container.dispose();
    await getIt.reset();
  });

  test('getApod provider should return Apod data from ApiService', () async {
    // Arrange
    final apod = Apod(
      title: 'Galaxy Image',
      explanation: 'A galaxy far away.',
      imageUrl: 'https://example.com/image.jpg',
    );

    when(mockApiService.getApod()).thenAnswer((_) async => apod);

    // Act
    final result = await container.read(latestApodProvider.future);

    // Assert
    expect(result, equals(apod));
    verify(mockApiService.getApod()).called(1);
  });

  test(
    'getApod provider should throw an exception when ApiService fails',
    () async {
      // Arrange
      when(mockApiService.getApod())
          .thenAnswer((_) async => throw Exception('API Error'));

      // Act & Assert
      await expectLater(
        container.read(latestApodProvider.future),
        throwsA(isA<Exception>()),
      );
      verify(mockApiService.getApod()).called(1);
    },
  );
}
