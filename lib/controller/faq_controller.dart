import 'package:get/get.dart';
import '../models/faq_model.dart';
import '../services/faq_service.dart';

class FAQController extends GetxController {
  final FAQService _faqService = FAQService();

  // Observable variables
  final Rx<FAQ?> faqData = Rx<FAQ?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFAQ();
  }

  Future<void> fetchFAQ() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final faq = await _faqService.getFAQ();
      if (faq != null) {
        faqData.value = faq;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      if (Get.isLogEnable) {
        print('Error fetching FAQ: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void refreshFAQ() {
    fetchFAQ();
  }

  // Getter methods for easy access
  String get faqTitle => faqData.value?.title ?? 'FAQ';
  String get faqDescription => faqData.value?.description ?? '';
  bool get hasFAQData => faqData.value != null;

  // Parse FAQ content to extract Q&A pairs
  List<FAQItem> get faqItems {
    if (faqDescription.isEmpty) return [];

    List<FAQItem> items = [];
    String content = faqDescription;

    // Remove HTML tags for better parsing
    content = content.replaceAll(RegExp(r'<[^>]*>'), '\n');
    content = content.replaceAll('&nbsp;', ' ');
    content = content.replaceAll('&ldquo;', '"');
    content = content.replaceAll('&rdquo;', '"');
    content = content.replaceAll('&amp;', '&');

    // Split by Q: to find questions
    List<String> sections = content.split('Q:');

    for (int i = 1; i < sections.length; i++) {
      String section = sections[i].trim();
      if (section.isNotEmpty) {
        // Find the question (everything before the first newline or before 'A:')
        int questionEndIndex = section.indexOf('\n');
        if (questionEndIndex == -1) questionEndIndex = section.length;

        String question = section.substring(0, questionEndIndex).trim();
        String answer = section.substring(questionEndIndex).trim();

        // Clean up the answer
        answer = answer.replaceAll(RegExp(r'\n+'), '\n');
        answer = answer.trim();

        if (question.isNotEmpty && answer.isNotEmpty) {
          items.add(FAQItem(question: question, answer: answer));
        }
      }
    }

    return items;
  }

  // Helper method to get cleaned content (remove HTML tags)
  String get cleanDescription {
    String desc = faqDescription;
    // Remove HTML tags
    desc = desc.replaceAll(RegExp(r'<[^>]*>'), '');
    // Decode HTML entities
    desc = desc.replaceAll('&nbsp;', ' ');
    desc = desc.replaceAll('&amp;', '&');
    desc = desc.replaceAll('&lt;', '<');
    desc = desc.replaceAll('&gt;', '>');
    desc = desc.replaceAll('&quot;', '"');
    desc = desc.replaceAll('&#39;', "'");
    desc = desc.replaceAll('&ldquo;', '"');
    desc = desc.replaceAll('&rdquo;', '"');
    return desc.trim();
  }
}
