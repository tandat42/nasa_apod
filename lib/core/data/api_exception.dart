class const ApiException(final int? code) implements Exception {
  @override
  String toString() => 'ApiException(code: $code)';
}
