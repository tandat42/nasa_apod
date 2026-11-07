import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/di.dart';
import 'package:nasa_apod/core/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'latest_apod_provider.g.dart';

@riverpod
Future<Apod> latestApod(Ref ref) {
  return getIt.get<ApiService>().getApod();
}
