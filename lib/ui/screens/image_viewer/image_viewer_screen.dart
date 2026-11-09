import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nasa_apod/ui/widgets/platform_selector_widget.dart';

class const ImageViewerScreen(
  final String? imageUrl, {
  required final int? width,
  required final int? height,
  super.key,
}) extends StatelessWidget {
  static const heroTag = 'apod_image';

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || width == null || height == null) {
      return const Material(
        child: Center(child: Text('Failed to show image, please open page with valid parameters')),
      );
    }

    return PlatformSelectorWidget(
      mobileBuilder: (context) =>
          _ImageViewerMobileContent(imageUrl: imageUrl!, width: width!, height: height!),
      webBuilder: (context) =>
          _ImageViewerWebContent(imageUrl: imageUrl!, width: width!, height: height!),
    );
  }
}

class const _ImageViewerMobileContent({
  required final String imageUrl,
  required final int width,
  required final int height,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _ImageViewerContent(imageUrl: imageUrl, width: width, height: height),
    );
  }
}

class const _ImageViewerWebContent({
  required final String imageUrl,
  required final int width,
  required final int height,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ImageViewerContent(imageUrl: imageUrl, width: width, height: height),
    );
  }
}

class const _ImageViewerContent({
  required final String imageUrl,
  required final int width,
  required final int height,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minScale = math.min(constraints.maxWidth / width, constraints.maxHeight / height) / 2;
        final maxScale = math.max(width / constraints.maxWidth, height / constraints.maxHeight) * 4;

        return InteractiveViewer(
          constrained: true,
          minScale: minScale,
          maxScale: maxScale,
          child: Container(
            alignment: .center,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: FittedBox(
              fit: .contain,
              child: Hero(
                tag: ImageViewerScreen.heroTag,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: .cover,
                  alignment: .center,
                  width: width.toDouble(),
                  height: height.toDouble(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
