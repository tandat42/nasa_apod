import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/ui/screens/main/data/image_size.dart';
import 'package:nasa_apod/ui/screens/main/providers/image_size_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const url = 'https://example.com/image.jpg';

  late ProviderContainer container;
  late _ControlledImageStreamCompleter completer;

  setUp(() {
    container = ProviderContainer(retry: (_, _) => null);

    // CachedNetworkImageProvider is keyed by its url, so seeding the image
    // cache makes resolve() return this completer instead of hitting network.
    completer = _ControlledImageStreamCompleter();
    imageCache.putIfAbsent(const CachedNetworkImageProvider(url), () => completer);
    // The cache attaches its own listener, which must not count as the
    // provider's.
    completer.ignoreCurrentListeners();
  });

  tearDown(() {
    container.dispose();
    imageCache
      ..clear()
      ..clearLiveImages();
  });

  test('imageSize provider should return null when url is null', () async {
    // Act
    final result = await container.read(imageSizeProvider(null).future);

    // Assert
    expect(result, isNull);
  });

  test('imageSize provider should return the size of the loaded image', () async {
    // Arrange
    container.listen(imageSizeProvider(url), (_, _) {});
    final future = container.read(imageSizeProvider(url).future);
    final image = await createTestImage(width: 3, height: 2);

    // Act
    completer.emit(ImageInfo(image: image));
    final result = await future;

    // Assert
    expect(result, equals(const ImageSize(width: 3, height: 2)));
    expect(completer.isListened, isFalse);
  });

  test('imageSize provider should throw when the image fails to load', () async {
    // Arrange
    final subscription = container.listen(imageSizeProvider(url), (_, _) {});
    final future = container.read(imageSizeProvider(url).future);

    // Act
    completer.fail(Exception('Load failed'));

    // Assert
    await expectLater(future, throwsA(isA<Exception>()));
    expect(subscription.read().hasError, isTrue);
    expect(completer.isListened, isFalse);
  });

  test('imageSize provider should stop listening when disposed', () async {
    // Arrange
    final subscription = container.listen(imageSizeProvider(url), (_, _) {});
    expect(completer.isListened, isTrue);

    // Act
    subscription.close();
    await container.pump();

    // Assert
    expect(completer.isListened, isFalse);
  });
}

class _ControlledImageStreamCompleter extends ImageStreamCompleter {
  final _listeners = <ImageStreamListener>{};
  var _ignoredListeners = <ImageStreamListener>{};

  /// Whether any listener added after [ignoreCurrentListeners] is attached.
  bool get isListened => _listeners.difference(_ignoredListeners).isNotEmpty;

  void ignoreCurrentListeners() => _ignoredListeners = {..._listeners};

  @override
  void addListener(ImageStreamListener listener) {
    _listeners.add(listener);
    super.addListener(listener);
  }

  @override
  void removeListener(ImageStreamListener listener) {
    _listeners.remove(listener);
    super.removeListener(listener);
  }

  void emit(ImageInfo info) => setImage(info);

  void fail(Object error) => reportError(exception: error);
}
