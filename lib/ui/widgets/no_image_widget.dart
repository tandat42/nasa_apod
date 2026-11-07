import 'package:flutter/material.dart';

class NoImageWidget extends StatelessWidget {
  const NoImageWidget({super.key, required this.onTryAgainTap});

  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Sorry, looks like there is no picture today :('),
        SizedBox(height: 24),
        ElevatedButton(onPressed: onTryAgainTap, child: Text('Try again')),
      ],
    );
  }
}
