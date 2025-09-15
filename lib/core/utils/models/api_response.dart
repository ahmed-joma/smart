class ApiResponse<T> {
  final bool status;
  final int code;
  final String msg;
  final T? data;

  ApiResponse({
    required this.status,
    required this.code,
    required this.msg,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'code': code, 'msg': msg, 'data': data};
  }

  bool get isSuccess => status && code >= 200 && code < 300;
  bool get isError => !status || code >= 400;
}
