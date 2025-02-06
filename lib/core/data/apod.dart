import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nasa_apod/core/data/media_type.dart';

part 'apod.freezed.dart';
part 'apod.g.dart';

@Freezed()
class Apod with _$Apod {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Apod({
    required MediaType mediaType,
    required String title,
    required String url,
    required String? thumbnailUrl,
  }) = _Apod;

  factory Apod.fromJson(Map<String, dynamic> json) => _$ApodFromJson(json);
}
