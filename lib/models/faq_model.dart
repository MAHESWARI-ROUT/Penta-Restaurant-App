class FAQ {
  final String title;
  final String description;

  FAQ({
    required this.title,
    required this.description,
  });

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}

class FAQResponse {
  final bool success;
  final String message;
  final FAQ? faq;

  FAQResponse({
    required this.success,
    required this.message,
    this.faq,
  });

  factory FAQResponse.fromJson(Map<String, dynamic> json) {
    return FAQResponse(
      success: json['success'] == true || json['success'] == 'true',
      message: json['message'] ?? '',
      faq: json['success'] == true || json['success'] == 'true'
          ? FAQ.fromJson(json)
          : null,
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
