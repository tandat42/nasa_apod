import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nasa_apod/di.dart';

class const ApodApp({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: getIt.get<GoRouter>(),
        title: 'Flutter APOD task',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      ),
    );
  }
}
