import 'package:flutter/material.dart';

class const NoImageWidget({
  super.key,
  required final VoidCallback onTryAgainTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      spacing: 24,
      children: [
        const Text('Sorry, looks like there is no picture today :('),
        ElevatedButton(
          onPressed: onTryAgainTap,
          child: const Text('Try again'),
        ),
      ],
    );
  }
}
