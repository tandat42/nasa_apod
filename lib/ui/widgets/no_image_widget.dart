import 'package:flutter/material.dart';

class const NoImageWidget({required final VoidCallback onTryAgainTap, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      spacing: 24,
      children: [
        const Text('Sorry, looks like there is no picture today :('),
        ElevatedButton(onPressed: onTryAgainTap, child: const Text('Try again')),
      ],
    );
  }
}
