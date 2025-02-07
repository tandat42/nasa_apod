import 'package:flutter/material.dart';
import 'package:nasa_apod/ui/utils/text_utils.dart';

class ApodErrorWidget extends StatelessWidget {
  const ApodErrorWidget({super.key, required this.onTryAgainTap, required this.error});

  final Object error;
  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(TextUtils.getErrorMessage(context, error)),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: onTryAgainTap,
          child: Text('Try again'),
        )
      ],
    );
  }
}
