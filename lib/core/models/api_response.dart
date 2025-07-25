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

  /// Factory constructor to create ApiResponse from JSON.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic> json)? fromJsonT,
  }) {
    return ApiResponse<T>(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      redirect: json['redirect'],
      payload: json['payload'] != null
          ? fromJsonT != null
              ? fromJsonT(json['payload'])
              : json['payload'] as T
          : null,
    );
  }

  /// Factory constructor to create ApiResponse without payload
  factory ApiResponse.fromJsonNoPayload(Map<String, dynamic> json) {
    return ApiResponse<T>(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      redirect: json['redirect'],
      payload: null,
    );
  }

  /// Converts the ApiResponse to JSON (excluding payload)
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (redirect != null) 'redirect': redirect,
    };
  }
}
