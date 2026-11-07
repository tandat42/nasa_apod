import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/core/resolvers/api_resolver.dart';
import 'package:nasa_apod/core/services/api_service.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([ApiResolver])
void main() {
  late MockApiResolver mockApiResolver;
  late ApiService apiService;

  setUp(() {
    mockApiResolver = MockApiResolver();
    apiService = ApiService(mockApiResolver);
  });

  test('getApod() should return the latest Apod from ApiResolver', () async {
    // Arrange
    final apod = Apod(
      title: 'Galaxy Image',
      explanation: 'A galaxy far away.',
      imageUrl: 'https://example.com/image.jpg',
    );

    when(mockApiResolver.getApods()).thenAnswer((_) async => [apod]);

    // Act
    final result = await apiService.getApod();

    // Assert
    expect(result, equals(apod));
    verify(mockApiResolver.getApods()).called(1);
  });

  test('getApod() should throw when ApiResolver returns no Apod', () async {
    // Arrange
    when(mockApiResolver.getApods()).thenAnswer((_) async => []);

    // Act & Assert
    await expectLater(apiService.getApod(), throwsStateError);
  });

  test('getApod() should throw an exception when ApiResolver fails', () async {
    // Arrange
    when(mockApiResolver.getApods()).thenAnswer(
      (_) async => throw DioException(
        requestOptions: RequestOptions(path: '/wp-json/wp/v2/apod-basic'),
      ),
    );

    // Act & Assert
    await expectLater(apiService.getApod(), throwsA(isA<DioException>()));
  });
}
