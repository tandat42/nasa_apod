import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nasa_apod/core/data/api_exception.dart';
import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/core/env/env.dart';
import 'package:retrofit/retrofit.dart';

part 'api_resolver.g.dart';

@singleton
@RestApi(baseUrl: 'https://science.nasa.gov')
abstract class ApiResolver {
  @factoryMethod
  factory ApiResolver(Dio dio) = _ApiResolver;

  @GET('/wp-json/wp/v2/apod-basic')
  Future<List<Apod>> getApods({
    @Query('page') int page = 1,
    @Query('per_page') int perPage = 1,
  });
}

@module
abstract class ApiResolverModule {
  @singleton
  Dio dio() =>
      Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        )
        ..interceptors.add(ApiKeyInterceptor())
        ..interceptors.add(ApiResultInterceptor());
}

class ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({'api_key': Env.nasaApiKey});

    super.onRequest(options, handler);
  }
}

class ApiResultInterceptor extends Interceptor {
  static const _successCode = 200;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('_ApiResultExceptionInterceptor onResponse: $response');

    if (response.statusCode != _successCode) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: ApiException(response.statusCode),
        ),
      );
    } else {
      super.onResponse(response, handler);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('_ApiResultExceptionInterceptor onError: $err');

    super.onError(err, handler);
  }
}
