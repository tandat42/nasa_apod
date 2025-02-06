import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/core/data/media_type.dart';
import 'package:nasa_apod/core/services/api_service.dart';
import 'package:nasa_apod/di.dart';
import 'package:nasa_apod/ui/screens/main/main_screen_provider.dart';
import 'package:riverpod/riverpod.dart';

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
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
    getIt.reset();
  });

  test('getApod provider should return Apod data from ApiService', () async {
    // Arrange
    final apod = Apod(
      mediaType: MediaType.image,
      title: 'Galaxy Image',
      url: 'https://example.com/image.jpg',
      thumbnailUrl: 'https://example.com/thumb.jpg',
    );

    when(mockApiService.getApod()).thenAnswer((_) async => apod);

    // Act
    final result = await container.read(getApodProvider.future);

    // Assert
    expect(result, equals(apod));
    verify(mockApiService.getApod()).called(1);
  });

  test('getApod provider should throw an exception when ApiService fails', () async {
    // Arrange
    when(mockApiService.getApod()).thenThrow(Exception('API Error'));

    // Act & Assert
    expect(() async => await container.read(getApodProvider.future), throwsA(isA<Exception>()));
    verify(mockApiService.getApod()).called(1);
  });
}
