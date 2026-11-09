import 'package:freezed_annotation/freezed_annotation.dart';

part 'apod.freezed.dart';

part 'apod.g.dart';

@Freezed()
abstract class Apod with _$Apod {
  // Freezed forwards this annotation to the generated class, which the analyzer can't see.
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: .snake)
  factory({
    required String title,
    required String explanation,
    @JsonKey(name: 'hdurl') required String? imageUrl,
  }) = _Apod;

  factory fromJson(Map<String, dynamic> json) => _$ApodFromJson(json);
}
