class Terms {
  final String terms;

  Terms({
    required this.terms,
  });

  factory Terms.fromJson(Map<String, dynamic> json) {
    return Terms(
      terms: json['terms'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'terms': terms,
    };
  }
}

class TermsResponse {
  final bool success;
  final String message;
  final Terms? terms;

  TermsResponse({
    required this.success,
    required this.message,
    this.terms,
  });

  factory TermsResponse.fromJson(Map<String, dynamic> json) {
    return TermsResponse(
      success: json['success'] == true || json['success'] == 'true',
      message: json['message'] ?? '',
      terms: json['success'] == true || json['success'] == 'true'
          ? Terms.fromJson(json)
          : null,
    );
  }
}
