import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nasa_apod/ui/widgets/platform_selector_widget.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen(
    this.imageUrl, {
    super.key,
    required this.width,
    required this.height,
  });

  static const heroTag = "apod_image";

  final String? imageUrl;
  final int? width;
  final int? height;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || width == null || height == null) {
      return Material(
        child: Center(
          child: Text('Failed to show image, please open page with valid parameters'),
        ),
      );
    }

    return PlatformSelectorWidget(
      mobileBuilder: (context) => _ImageViewerMobileContent(
        imageUrl: imageUrl!,
        width: width!,
        height: height!,
      ),
      webBuilder: (context) => _ImageViewerWebContent(
        imageUrl: imageUrl!,
        width: width!,
        height: height!,
      ),
    );
  }
}

class _ImageViewerMobileContent extends StatelessWidget {
  const _ImageViewerMobileContent({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  final String imageUrl;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _ImageViewerContent(
        imageUrl: imageUrl,
        width: width,
        height: height,
      ),
    );
  }
}

class _ImageViewerWebContent extends StatelessWidget {
  const _ImageViewerWebContent({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  final String imageUrl;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ImageViewerContent(
        imageUrl: imageUrl,
        width: width,
        height: height,
      ),
    );
  }
}

class _ImageViewerContent extends StatelessWidget {
  const _ImageViewerContent({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  final String imageUrl;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final minScale = math.min(constraints.maxWidth / width, constraints.maxHeight / height) / 2;
      final maxScale = math.max(width / constraints.maxWidth, height / constraints.maxHeight) * 4;

      return InteractiveViewer(
        constrained: true,
        minScale: minScale,
        maxScale: maxScale,
        child: Container(
          alignment: Alignment.center,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Hero(
              tag: ImageViewerScreen.heroTag,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                width: width.toDouble(),
                height: height.toDouble(),
              ),
            ),
          ),
        ),
      );
    });
  }
}
