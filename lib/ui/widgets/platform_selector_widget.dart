import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class const PlatformSelectorWidget({
  required final WidgetBuilder mobileBuilder,
  required final WidgetBuilder webBuilder,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return !kIsWeb ? mobileBuilder(context) : webBuilder(context);
  }
}
