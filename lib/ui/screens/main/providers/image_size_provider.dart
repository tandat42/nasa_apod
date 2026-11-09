import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:nasa_apod/ui/screens/main/data/image_size.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_size_provider.g.dart';

@riverpod
Future<ImageSize?> imageSize(Ref ref, String? url) {
  if (url == null) return Future.value(null);

  final completer = Completer<ImageSize?>();
  final stream = CachedNetworkImageProvider(url).resolve(.empty);

  late final ImageStreamListener listener;
  listener = ImageStreamListener(
    (info, _) {
      stream.removeListener(listener);
      completer.complete(ImageSize(width: info.image.width, height: info.image.height));
      info.dispose();
    },
    onError: (error, stackTrace) {
      stream.removeListener(listener);
      completer.completeError(error, stackTrace ?? StackTrace.current);
    },
  );

  stream.addListener(listener);
  ref.onDispose(() => stream.removeListener(listener));

  return completer.future;
}
