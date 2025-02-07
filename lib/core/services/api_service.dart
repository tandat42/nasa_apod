import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/core/resolvers/api_resolver.dart';

@singleton
class ApiService {
  ApiService(this._resolver);

  static const _webCorsProxyUrl = 'https://cors-anywhere.herokuapp.com/';

  final ApiResolver _resolver;

  Future<Apod> getApod() async {
    var apod = await _resolver.getApod();

    if (!kIsWeb) {
      return apod;
    } else {
      final url = '$_webCorsProxyUrl${apod.url}';
      final thumbnailUrl = (apod.thumbnailUrl?.isNotEmpty ?? false)
          ? '$_webCorsProxyUrl${apod.thumbnailUrl}'
          : null;
      return apod.copyWith(url: url, thumbnailUrl: thumbnailUrl);
    }
  }
}
