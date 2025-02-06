import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/di.dart';
import 'package:nasa_apod/core/services/api_service.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_screen_provider.g.dart';

@riverpod
Future<Apod> getApod(Ref ref) {
  return getIt.get<ApiService>().getApod();
}
