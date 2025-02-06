import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewerScreen extends StatefulWidget {
  const ImageViewerScreen(
    this.imageUrl, {
    super.key,
    required this.width,
    required this.height,
  });

  static const heroTag = "apod_image";

  final String imageUrl;
  final int width;
  final int height;

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(builder: (context, constraints) {
        final minScale = math.min(constraints.maxWidth / widget.width, constraints.maxHeight / widget.height) / 2;
        final maxScale = math.max(widget.width / constraints.maxWidth, widget.height / constraints.maxHeight) * 4;

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
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  // width: widget.width.toDouble(),
                  // height: widget.height.toDouble(),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
