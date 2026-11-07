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
  const date = '261107';

  late MockDio mockDio;
  late ApiResolver apiResolver;

  setUp(() {
    mockDio = MockDio();

    when(mockDio.options).thenReturn(BaseOptions());

    apiResolver = ApiResolver(mockDio);
  });

  test('getApod should return Apod object on success', () async {
    // Arrange
    final jsonResponse = {
      'title': 'Galaxy Image',
      'explanation': 'A galaxy far away.',
      'hdurl': 'https://example.com/image.jpg',
    };

    final requestOptions = RequestOptions(path: '/wp-json/wp/v2/apod-basic/$date');

    final response = Response(
      requestOptions: requestOptions,
      data: jsonResponse,
      statusCode: 200,
    );

    when(mockDio.fetch<Map<String, dynamic>>(any)).thenAnswer((_) async => response);

    // Act
    final result = await apiResolver.getApod(date);

    // Assert
    expect(result, isA<Apod>());
    expect(result.title, equals('Galaxy Image'));
    expect(result.explanation, equals('A galaxy far away.'));
    expect(result.imageUrl, equals('https://example.com/image.jpg'));

    final options = verify(mockDio.fetch<Map<String, dynamic>>(captureAny)).captured.single as RequestOptions;
    expect(options.path, equals('/wp-json/wp/v2/apod-basic/$date'));
  });

  test('ApiKeyInterceptor should add API key to requests', () async {
    // Arrange
    final interceptor = ApiKeyInterceptor();
    final options = RequestOptions(path: '/wp-json/wp/v2/apod-basic/$date', queryParameters: {});

    final handler = RequestInterceptorHandler();

    // Act
    interceptor.onRequest(options, handler);

    // Assert
    expect(options.queryParameters.containsKey('api_key'), true);
    expect(options.queryParameters['api_key'], equals('kGjbFgzNmFJWrFQwmpLPKbhGBWMCTNGjPd7RRTDn'));
  });

  test('ApiResultExceptionInterceptor should throw ApiException on failure', () async {
    // Arrange
    final interceptor = ApiResultExceptionInterceptor();
    final response = Response(
      requestOptions: RequestOptions(path: '/wp-json/wp/v2/apod-basic/$date'),
      statusCode: 500,
    );

    final handler = ResponseInterceptorHandler();

    // Act & Assert
    expect(() => interceptor.onResponse(response, handler), throwsA(isA<ApiException>()));
  });

  test('getApod should throw an error on API failure', () async {
    // Arrange
    final requestOptions = RequestOptions(path: '/wp-json/wp/v2/apod-basic/$date');

    when(mockDio.fetch<Map<String, dynamic>>(any))
        .thenThrow(DioException(requestOptions: requestOptions));

    // Act & Assert
    await expectLater(apiResolver.getApod(date), throwsA(isA<DioException>()));

    verify(mockDio.fetch<Map<String, dynamic>>(any)).called(1);
  });
}
