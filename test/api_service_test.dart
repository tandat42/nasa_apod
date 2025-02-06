import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/core/data/media_type.dart';
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

  test('getApod() should return Apod data from ApiResolver', () async {
    // Arrange
    final apod = Apod(
      mediaType: MediaType.image,
      title: 'Galaxy Image',
      url: 'https://example.com/image.jpg',
      thumbnailUrl: 'https://example.com/thumb.jpg',
    );

    when(mockApiResolver.getApod(thumbs: 'True')).thenAnswer((_) async => apod);

    // Act
    final result = await apiService.getApod();

    // Assert
    expect(result, equals(apod));
    verify(mockApiResolver.getApod(thumbs: 'True')).called(1);
  });

  test('getApod() should throw an exception when ApiResolver fails', () async {
    // Arrange
    when(mockApiResolver.getApod(thumbs: 'True')).thenThrow(DioException(
      requestOptions: RequestOptions(path: '/planetary/apod'),
    ));

    // Act & Assert
    expect(() => apiService.getApod(), throwsA(isA<DioException>()));
  });
}