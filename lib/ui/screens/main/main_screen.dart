import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/core/data/media_type.dart';
import 'package:nasa_apod/ui/navigation/router.dart';
import 'package:nasa_apod/ui/screens/image_viewer/image_viewer_screen.dart';
import 'package:nasa_apod/ui/screens/main/main_screen_provider.dart';
import 'package:nasa_apod/ui/utils/text_utils.dart';
import 'package:nasa_apod/ui/widgets/progress_widget.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  void _onImageTap(String url, {required int imageWidth, required int imageHeight}) {
    ImageViewerRoute(url, width: imageWidth, height: imageHeight).push(context);
  }

  void _onTryAgainTap() {
    ref.invalidate(getApodProvider);
  }

  @override
  Widget build(BuildContext context) {
    final apodValue = ref.watch(getApodProvider);

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: apodValue.when(
          data: (apod) => _MainContentWidget(
            apod: apod,
            onImageTap: _onImageTap,
            errorWidget: _MainErrorWidget(onTryAgainTap: _onTryAgainTap),
          ),
          loading: () => const ProgressWidget(),
          error: (e, _) => _MainErrorWidget(onTryAgainTap: _onTryAgainTap),
        ),
      ),
    );
  }
}

class _MainContentWidget extends StatefulWidget {
  const _MainContentWidget({required this.apod, required this.onImageTap, required this.errorWidget});

  final Apod apod;
  final ImageTapCallback onImageTap;
  final Widget errorWidget;

  String get _imageUrl => apod.mediaType == MediaType.video ? apod.thumbnailUrl! : apod.url;

  @override
  State<_MainContentWidget> createState() => _MainContentWidgetState();
}

class _MainContentWidgetState extends State<_MainContentWidget> {
  late String _imageUrl;

  int? _imageWidth;
  int? _imageHeight;

  bool get _imageDisplayAllowed => _imageWidth != null && _imageHeight != null;

  @override
  void initState() {
    super.initState();

    _imageUrl = widget._imageUrl;
  }

  @override
  void didUpdateWidget(covariant _MainContentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget._imageUrl != widget._imageUrl) {
      _imageWidth = null;
      _imageHeight = null;
    }
  }

  void _onImageTap() {
    widget.onImageTap(_imageUrl, imageWidth: _imageWidth!, imageHeight: _imageHeight!);
  }

  void _getImageSize(ImageProvider provider) {
    final imageUrl = _imageUrl;
    ImageStream stream = provider.resolve(ImageConfiguration());
    late final ImageStreamListener imageStreamListener;
    imageStreamListener = ImageStreamListener((ImageInfo info, bool _) {
      final resolvedWidth = info.image.width;
      final resolvedHeight = info.image.height;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if ((_imageWidth != resolvedWidth || _imageHeight == resolvedHeight) && imageUrl == _imageUrl && mounted) {
          setState(() {
            _imageWidth = resolvedWidth;
            _imageHeight = resolvedHeight;
          });
          stream.removeListener(imageStreamListener);
        }
      });
    });
    stream.addListener(imageStreamListener);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final imageWidgetHeight = constraints.maxHeight / 2;
      final freeSpaceHeight = imageWidgetHeight / 2;

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: freeSpaceHeight),
          Hero(
            tag: ImageViewerScreen.heroTag,
            child: CachedNetworkImage(
              imageUrl: _imageUrl,
              height: imageWidgetHeight,
              imageBuilder: (context, provider) {
                if (!_imageDisplayAllowed) _getImageSize(provider);

                return _imageDisplayAllowed
                    ? GestureDetector(
                        onTap: _onImageTap,
                        child: Image(image: provider, fit: BoxFit.cover),
                      )
                    : const ProgressWidget();
              },
              progressIndicatorBuilder: (context, _, __) => const ProgressWidget(),
              errorWidget: (context, _, __) => widget.errorWidget,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(12),
              child: Text(
                widget.apod.title,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      );
    });
  }
}

class _MainErrorWidget extends StatelessWidget {
  const _MainErrorWidget({required this.onTryAgainTap});

  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(TextUtils.getErrorMessage(context)),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: onTryAgainTap,
          child: Text('Try again'),
        )
      ],
    );
  }
}

typedef ImageTapCallback = void Function(String, {required int imageWidth, required int imageHeight});
