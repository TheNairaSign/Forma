class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  NetworkException({
    this.message = 'A network error occurred',
    this.statusCode,
    this.error,
  });

  @override
  String toString() {
    return 'NetworkException: $message${statusCode != null ? ' (Status Code: $statusCode)' : ''}';
  }
}
