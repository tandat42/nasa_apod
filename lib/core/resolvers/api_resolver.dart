import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nasa_apod/core/data/api_exception.dart';
import 'package:nasa_apod/core/data/apod.dart';
import 'package:retrofit/retrofit.dart';

part 'api_resolver.g.dart';

@singleton
@RestApi(baseUrl: 'https://api.nasa.gov')
abstract class ApiResolver {
  @factoryMethod
  factory ApiResolver(Dio dio) = _ApiResolver;

  @GET('/planetary/apod')
  Future<Apod> getApod({@Query('thumbs') String thumbs = 'True'});
}

@module
abstract class ApiResolverModule {
  @singleton
  Dio dio() => Dio()
    ..interceptors.add(ApiKeyInterceptor())
    ..interceptors.add(ApiResultExceptionInterceptor());
}

class ApiKeyInterceptor extends Interceptor {
  static const _apiKey = 'IHE6wfIXbhRbcJKIZQTcJt0MmvCPQffEa3Ox70ey';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({'api_key': _apiKey});

    super.onRequest(options, handler);
  }
}

class ApiResultExceptionInterceptor extends Interceptor {
  static const _successCodes = [200, 202];

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('_ApiResultExceptionInterceptor onResponse: $response');

    if (!_successCodes.contains(response.statusCode)) {
      throw ApiException(response.statusCode);
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('_ApiResultExceptionInterceptor onError: $err');

    super.onError(err, handler);
  }
}
