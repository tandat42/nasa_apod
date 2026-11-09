import 'package:equatable/equatable.dart';

class const ImageSize({required final int width, required final int height}) extends Equatable {
  @override
  List<Object?> get props => [width, height];
}
