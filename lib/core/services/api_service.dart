import 'package:injectable/injectable.dart';
import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/core/resolvers/api_resolver.dart';

@singleton
class ApiService(final ApiResolver _resolver) {
  Future<Apod> getApod() async {
    final apods = await _resolver.getApods();
    return apods.first;
  }
}
