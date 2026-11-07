import 'package:freezed_annotation/freezed_annotation.dart';

part 'apod.freezed.dart';

part 'apod.g.dart';

@Freezed()
abstract class Apod with _$Apod {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: .snake)
  factory Apod({
    required String title,
    required String explanation,
    @JsonKey(name: "hdurl") required String? imageUrl,
  }) = _Apod;

  factory Apod.fromJson(Map<String, dynamic> json) => _$ApodFromJson(json);
}
