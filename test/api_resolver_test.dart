import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:nasa_apod/core/data/api_exception.dart';
import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/core/resolvers/api_resolver.dart';

import 'api_resolver_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late ApiResolver apiResolver;

  setUp(() {
    mockDio = MockDio();

    // Add this missing stub
    when(mockDio.options).thenReturn(BaseOptions());

    apiResolver = ApiResolver(mockDio);
  });

  test('getApod should return Apod object on success', () async {
    // Arrange
    final jsonResponse = {
      'media_type': 'image',
      'title': 'Galaxy Image',
      'url': 'https://example.com/image.jpg',
      'thumbnail_url': 'https://example.com/thumb.jpg',
    };

    final requestOptions = RequestOptions(path: '/planetary/apod');

    final response = Response(
      requestOptions: requestOptions,
      data: jsonResponse,
      statusCode: 200,
    );

    // Stub fetch() instead of get()
    when(mockDio.fetch(any)).thenAnswer((_) async => response);

    // Act
    final result = await apiResolver.getApod();

    // Assert
    expect(result, isA<Apod>());
    expect(result.title, equals('Galaxy Image'));
    expect(result.url, equals('https://example.com/image.jpg'));

    verify(mockDio.fetch(any)).called(1);
  });

  test('ApiKeyInterceptor should add API key to requests', () async {
    // Arrange
    final interceptor = ApiKeyInterceptor();
    final options = RequestOptions(path: '/planetary/apod', queryParameters: {});

    final handler = RequestInterceptorHandler();

    // Act
    interceptor.onRequest(options, handler);

    // Assert
    expect(options.queryParameters.containsKey('api_key'), true);
    expect(options.queryParameters['api_key'], equals('IHE6wfIXbhRbcJKIZQTcJt0MmvCPQffEa3Ox70ey'));
  });

  test('ApiResultExceptionInterceptor should throw ApiException on failure', () async {
    // Arrange
    final interceptor = ApiResultExceptionInterceptor();
    final response = Response(
      requestOptions: RequestOptions(path: '/planetary/apod'),
      statusCode: 500, // Simulating a failed request
    );

    final handler = ResponseInterceptorHandler();

    // Act & Assert
    expect(() => interceptor.onResponse(response, handler), throwsA(isA<ApiException>()));
  });

  test('getApod should throw an error on API failure', () async {
    // Arrange
    final requestOptions = RequestOptions(path: '/planetary/apod');

    when(mockDio.fetch(any))
        .thenThrow(DioException(requestOptions: requestOptions));

    // Act & Assert
    expect(() async => await apiResolver.getApod(), throwsA(isA<DioException>()));

    verify(mockDio.fetch(any)).called(1);
  });
}