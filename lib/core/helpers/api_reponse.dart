class ApiResponse<T> {
  final bool status;
  final String message;
  final String? redirect;
  final T? payload;

  ApiResponse({
    required this.status,
    required this.message,
    this.redirect,
    this.payload,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'],
      message: json['message'],
      redirect: json['redirect'],
      payload: json['payload'] != null ? fromJsonT(json['payload']) : null,
      // payload: fromJsonT(json['payload']),
    );
  }

  factory ApiResponse.fromJsonNoPayload(Map<String, dynamic> json) {
    return ApiResponse<T>(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      redirect: json['redirect'],
      payload: json['payload'],
    );
  }

  static String toRedirect(Map<String, dynamic> json) {
    return json['redirect'];
  }
}
