import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nasa_apod/core/data/api_exception.dart';
import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/core/env/env.dart';
import 'package:nasa_apod/core/resolvers/api_resolver.dart';

import 'api_resolver_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  const path = '/wp-json/wp/v2/apod-basic';

  late MockDio mockDio;
  late ApiResolver apiResolver;

  setUp(() {
    mockDio = MockDio();

    when(mockDio.options).thenReturn(BaseOptions());

    apiResolver = ApiResolver(mockDio);
  });

  test('getApods should return Apod list on success', () async {
    // Arrange
    final jsonResponse = [
      {
        'title': 'Galaxy Image',
        'explanation': 'A galaxy far away.',
        'hdurl': 'https://example.com/image.jpg',
      },
    ];

    final response = Response(
      requestOptions: RequestOptions(path: path),
      data: jsonResponse,
      statusCode: 200,
    );

    when(mockDio.fetch<List<dynamic>>(any)).thenAnswer((_) async => response);

    // Act
    final result = await apiResolver.getApods();

    // Assert
    expect(result, hasLength(1));
    expect(result.single, isA<Apod>());
    expect(result.single.title, equals('Galaxy Image'));
    expect(result.single.explanation, equals('A galaxy far away.'));
    expect(result.single.imageUrl, equals('https://example.com/image.jpg'));

    final options =
        verify(mockDio.fetch<List<dynamic>>(captureAny)).captured.single
            as RequestOptions;
    expect(options.path, equals(path));
    expect(options.queryParameters, equals({'page': 1, 'per_page': 1}));
  });

  test('ApiKeyInterceptor should add API key to requests', () async {
    // Arrange
    final interceptor = ApiKeyInterceptor();
    final options = RequestOptions(path: path, queryParameters: {});

    final handler = RequestInterceptorHandler();

    // Act
    interceptor.onRequest(options, handler);

    // Assert
    expect(options.queryParameters.containsKey('api_key'), true);
    expect(options.queryParameters['api_key'], equals(Env.nasaApiKey));
  });

  test(
    'ApiResultExceptionInterceptor should reject with ApiException on failure',
    () async {
      // Arrange
      final interceptor = ApiResultInterceptor();
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: path),
        statusCode: 500,
      );

      final handler = _RecordingResponseHandler();

      // Act
      interceptor.onResponse(response, handler);

      // Assert
      expect(handler.rejected?.error, isA<ApiException>());
      expect(handler.passed, isNull);
    },
  );

  test(
    'ApiResultExceptionInterceptor should pass through successful responses',
    () async {
      // Arrange
      final interceptor = ApiResultInterceptor();
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
      );

      final handler = _RecordingResponseHandler();

      // Act
      interceptor.onResponse(response, handler);

      // Assert
      expect(handler.passed, same(response));
      expect(handler.rejected, isNull);
    },
  );

  test(
    'ApiResultExceptionInterceptor should forward errors unchanged',
    () async {
      // Arrange
      final interceptor = ApiResultInterceptor();
      final error = DioException(requestOptions: RequestOptions(path: path));

      final handler = _RecordingErrorHandler();

      // Act
      interceptor.onError(error, handler);

      // Assert
      expect(handler.passed, same(error));
    },
  );

  test('getApods should throw an error on API failure', () async {
    // Arrange
    when(mockDio.fetch<List<dynamic>>(any)).thenAnswer(
      (_) async =>
          throw DioException(requestOptions: RequestOptions(path: path)),
    );

    // Act & Assert
    await expectLater(apiResolver.getApods(), throwsA(isA<DioException>()));

    verify(mockDio.fetch<List<dynamic>>(any)).called(1);
  });
}

class _RecordingResponseHandler extends ResponseInterceptorHandler {
  DioException? rejected;
  Response<dynamic>? passed;

  @override
  void reject(
    DioException error, [
    bool callFollowingErrorInterceptor = false,
  ]) {
    rejected = error;
  }

  @override
  void next(Response<dynamic> response) {
    passed = response;
  }
}

class _RecordingErrorHandler extends ErrorInterceptorHandler {
  DioException? passed;

  @override
  void next(DioException error) {
    passed = error;
  }
}
