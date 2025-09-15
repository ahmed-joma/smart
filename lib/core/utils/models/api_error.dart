class ApiError {
  final int? code;
  final String message;
  final String? details;
  final Map<String, dynamic>? errors;

  ApiError({this.code, required this.message, this.details, this.errors});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'],
      message: json['msg'] ?? json['message'] ?? 'Unknown error',
      details: json['details'],
      errors: json['errors'],
    );
  }

  factory ApiError.fromException(dynamic exception) {
    if (exception is ApiError) {
      return exception;
    }

    return ApiError(message: exception.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'details': details,
      'errors': errors,
    };
  }

  @override
  String toString() {
    return 'ApiError(code: $code, message: $message, details: $details)';
  }
}
