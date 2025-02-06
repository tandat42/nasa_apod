import 'package:injectable/injectable.dart';
import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/core/resolvers/api_resolver.dart';

@singleton
class ApiService {
  ApiService(this._resolver);

  final ApiResolver _resolver;

  Future<Apod> getApod() async {
    return _resolver.getApod();
  }
}
