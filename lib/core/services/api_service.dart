import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/core/resolvers/api_resolver.dart';
import 'package:nasa_apod/core/utils/date_utils.dart';

@singleton
class ApiService(final ApiResolver _resolver) {
  static const _webCorsProxyUrl = 'https://cors-anywhere.herokuapp.com/';

  Future<Apod> getApod() async {
    var apod = await _resolver.getApod(DateUtils.getApodDate());

    if (!kIsWeb) {
      return apod;
    } else {
      final receivedImageUrl = apod.imageUrl;
      final corsImageUrl = (receivedImageUrl?.isNotEmpty ?? false)
          ? '$_webCorsProxyUrl$receivedImageUrl'
          : null;
      return apod.copyWith(imageUrl: corsImageUrl);
    }
  }
}
