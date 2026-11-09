import 'package:flutter/material.dart';
import 'package:nasa_apod/ui/utils/text_utils.dart';

class const ApodErrorWidget({
  required final VoidCallback onTryAgainTap,
  required final Object error,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      spacing: 24,
      children: [
        Text(TextUtils.getErrorMessage(context, error)),
        ElevatedButton(onPressed: onTryAgainTap, child: const Text('Try again')),
      ],
    );
  }
}
