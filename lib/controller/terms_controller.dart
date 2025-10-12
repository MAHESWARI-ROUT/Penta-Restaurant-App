import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/terms_model.dart';
import '../services/terms_service.dart';

class TermsController extends GetxController {
  final TermsService _termsService = TermsService();

  // Observable variables
  final Rx<Terms?> termsData = Rx<Terms?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTerms();
  }

  Future<void> fetchTerms() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final terms = await _termsService.getTerms();
      if (terms != null) {
        termsData.value = terms;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      if (Get.isLogEnable) {
        if (kDebugMode) {
          print('Error fetching terms: $e');
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void refreshTerms() {
    fetchTerms();
  }

  // Getter methods for easy access
  String get termsContent => termsData.value?.terms ?? '';
  bool get hasTermsData => termsData.value != null;

  // Helper method to get cleaned content (remove HTML tags)
  String get cleanTermsContent {
    String content = termsContent;
    // Remove HTML tags but preserve list structure
    content = content.replaceAll(RegExp(r'<h[1-6][^>]*>'), '\n\n');
    content = content.replaceAll(RegExp(r'</h[1-6]>'), '\n');
    content = content.replaceAll(RegExp(r'<ul[^>]*>'), '\n');
    content = content.replaceAll(RegExp(r'</ul>'), '\n');
    content = content.replaceAll(RegExp(r'<li[^>]*>'), '• ');
    content = content.replaceAll(RegExp(r'</li>'), '\n');
    content = content.replaceAll(RegExp(r'<p[^>]*>'), '\n');
    content = content.replaceAll(RegExp(r'</p>'), '\n');
    content = content.replaceAll(RegExp(r'<[^>]*>'), '');

    // Decode HTML entities
    content = content.replaceAll('&nbsp;', ' ');
    content = content.replaceAll('&amp;', '&');
    content = content.replaceAll('&lt;', '<');
    content = content.replaceAll('&gt;', '>');
    content = content.replaceAll('&quot;', '"');
    content = content.replaceAll('&#39;', "'");
    content = content.replaceAll('&ldquo;', '"');
    content = content.replaceAll('&rdquo;', '"');
    content = content.replaceAll('\r\n', '\n');
    content = content.replaceAll(RegExp(r'\n\s*\n'), '\n\n');

    return content.trim();
  }

  // Parse terms into sections for better display
  List<TermsSection> get termsSections {
    List<TermsSection> sections = [];
    String content = termsContent;

    // Split by headers
    List<String> parts = content.split(RegExp(r'<h[1-6][^>]*>'));

    for (int i = 1; i < parts.length; i++) {
      String part = parts[i];
      int headerEndIndex = part.indexOf('</h');
      if (headerEndIndex != -1) {
        String title = part.substring(0, headerEndIndex).trim();
        String body = part.substring(part.indexOf('>', headerEndIndex) + 1).trim();

        // Clean up the body content
        body = body.replaceAll(RegExp(r'<[^>]*>'), '');
        body = body.replaceAll('&nbsp;', ' ');
        body = body.replaceAll('&ldquo;', '"');
        body = body.replaceAll('&rdquo;', '"');
        body = body.replaceAll('&amp;', '&');
        body = body.replaceAll('\r\n', '\n');
        body = body.trim();

        if (title.isNotEmpty && body.isNotEmpty) {
          sections.add(TermsSection(title: title, content: body));
        }
      }
    }

    return sections;
  }
}

class TermsSection {
  final String title;
  final String content;

  TermsSection({
    required this.title,
    required this.content,
  });
}
