// Model for a single FAQ item
class FaqItem {
  // ... (This part remains the same)
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      question: json['question'] ?? 'No Question',
      answer: json['answer'] ?? 'No Answer',
    );
  }
}

// ## THIS IS THE PART TO CHANGE ##
// Model for the Terms content
class TermsInfo {
  final String content;

  // The constructor is all you need
  TermsInfo({required this.content});

  // You can completely REMOVE the fromJson factory constructor for this model
}