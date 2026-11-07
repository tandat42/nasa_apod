import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nasa_apod/core/data/apod.dart';
import 'package:nasa_apod/ui/navigation/router.dart';
import 'package:nasa_apod/ui/screens/main/data/image_size.dart';
import 'package:nasa_apod/ui/screens/image_viewer/image_viewer_screen.dart';
import 'package:nasa_apod/ui/screens/main/providers/image_size_provider.dart';
import 'package:nasa_apod/ui/screens/main/providers/latest_apod_provider.dart';
import 'package:nasa_apod/ui/widgets/error_widget.dart';
import 'package:nasa_apod/ui/widgets/no_image_widget.dart';
import 'package:nasa_apod/ui/widgets/progress_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class const MainScreen({super.key}) extends ConsumerWidget {
  void _onImageTap(
    BuildContext context, {
    required String url,
    required ImageSize size,
  }) {
    ImageViewerRoute(url, width: size.width, height: size.height).push(context);
  }

  void _onTryAgainTap(WidgetRef ref, Apod? apod) {
    ref.invalidate(imageSizeProvider(apod?.imageUrl));
    ref.invalidate(latestApodProvider);
  }

  Future<bool> _onTapUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    return launchUrl(uri, mode: .externalApplication);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apodValue = ref.watch(latestApodProvider);
    final imageSizeValue = ref.watch(
      imageSizeProvider(apodValue.value?.imageUrl),
    );

    return Scaffold(
      body: apodValue.when(
        skipLoadingOnRefresh: false,
        data: (apod) => _MainContentWidget(
          apod: apod,
          imageSizeValue: imageSizeValue,
          onImageTap: () {
            _onImageTap(
              context,
              url: apod.imageUrl!,
              size: imageSizeValue.value!,
            );
          },
          onTryAgainTap: () => _onTryAgainTap(ref, apodValue.value),
          onTapUrl: _onTapUrl,
        ),
        loading: () => const ProgressWidget(),
        error: (e, _) => ApodErrorWidget(
          error: e,
          onTryAgainTap: () => _onTryAgainTap(ref, apodValue.value),
        ),
      ),
    );
  }
}

class const _MainContentWidget({
  required final Apod apod,
  required final AsyncValue<ImageSize?> imageSizeValue,
  required final VoidCallback onImageTap,
  required final VoidCallback onTryAgainTap,
  required final Future<bool> Function(String url) onTapUrl,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imageUrl = apod.imageUrl;

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewPadding = MediaQuery.viewPaddingOf(context);
        final imageWidgetHeight = constraints.maxHeight / 2;

        return ListView(
          padding: .fromLTRB(
            constraints.maxWidth / 16,
            imageWidgetHeight / 8 + viewPadding.top,
            constraints.maxWidth / 16,
            imageWidgetHeight / 8 + viewPadding.bottom,
          ),
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              SizedBox(
                height: imageWidgetHeight,
                child: imageSizeValue.when(
                  skipLoadingOnRefresh: false,
                  data: (_) => Hero(
                    tag: ImageViewerScreen.heroTag,
                    child: GestureDetector(
                      onTap: onImageTap,
                      child: Image(
                        image: CachedNetworkImageProvider(imageUrl),
                        fit: .cover,
                      ),
                    ),
                  ),
                  loading: () => const ProgressWidget(),
                  error: (e, _) =>
                      ApodErrorWidget(error: e, onTryAgainTap: onTryAgainTap),
                ),
              )
            else
              SizedBox(
                height: imageWidgetHeight,
                child: NoImageWidget(onTryAgainTap: onTryAgainTap),
              ),
            Container(
              alignment: .center,
              padding: const .all(12),
              child: Column(
                spacing: 12,
                children: [
                  Text(
                    apod.title,
                    style: TextTheme.of(context).titleLarge,
                    softWrap: true,
                  ),
                  HtmlWidget(apod.explanation, onTapUrl: onTapUrl),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
