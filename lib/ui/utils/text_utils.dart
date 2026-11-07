import 'package:flutter/material.dart';

abstract final class TextUtils {
  static String getErrorMessage(BuildContext context, Object error) {
    //todo use l10n and meaningful messages
    return 'Something went wrong';
  }
}
