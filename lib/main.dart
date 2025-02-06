import 'package:flutter/material.dart';
import 'package:nasa_apod/di.dart';
import 'package:nasa_apod/ui/app.dart';

void main() {
  configureDependencies();

  runApp(const ApodApp());
}
