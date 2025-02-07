import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nasa_apod/di.dart';
import 'package:nasa_apod/ui/app.dart';

void main() {
  configureDependencies();

  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(const ApodApp());
}
