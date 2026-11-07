import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract final class Env {
  @EnviedField(varName: 'NASA_API_KEY', obfuscate: true)
  static final String nasaApiKey = _Env.nasaApiKey;
}
