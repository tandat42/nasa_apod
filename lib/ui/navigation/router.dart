import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:nasa_apod/ui/screens/image_viewer/image_viewer_screen.dart';

import '../screens/main/main_screen.dart';

part 'router.g.dart';

@TypedGoRoute<MainRoute>(path: '/')
class MainRoute extends GoRouteData {
  const MainRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const MainScreen();
}

@TypedGoRoute<ImageViewerRoute>(path: '/image_viewer')
class ImageViewerRoute extends GoRouteData {
  const ImageViewerRoute(this.imageUrl, {required this.width, required this.height});

  final String? imageUrl;
  final int? width;
  final int? height;

  @override
  CustomTransitionPage<void> buildPage(
    BuildContext context,
    GoRouterState state,
  ) {
    return CustomTransitionPage<void>(
        key: state.pageKey,
        child: ImageViewerScreen(imageUrl, width: width, height: height),
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child));
  }
}

@module
abstract class RouterModule {
  @Singleton()
  GoRouter router() => GoRouter(routes: $appRoutes);
}
