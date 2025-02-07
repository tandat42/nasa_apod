import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformSelectorWidget extends StatelessWidget {
  const PlatformSelectorWidget({
    super.key,
    required this.mobileBuilder,
    required this.webBuilder,
  });

  final WidgetBuilder mobileBuilder;
  final WidgetBuilder webBuilder;

  @override
  Widget build(BuildContext context) {
    return !kIsWeb ? mobileBuilder(context) : webBuilder(context);
  }
}
