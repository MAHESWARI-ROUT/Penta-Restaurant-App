import 'package:dio/dio.dart';
import 'package:penta_restaurant/models/info_model.dart';
import 'dio_client.dart';

class InfoService {
  final Dio _dio = DioClient().dio;

  // ... (getFAQ method is unchanged)
  Future<List<FaqItem>> getFAQ() async {
    try {
      final response = await _dio.get('/JSON/faq.php');

      // OLD LOGIC (that is likely causing the error):
      // final List<dynamic> data = response.data; 

      // NEW LOGIC:
      // Access the list from its key inside the response map.
      // IMPORTANT: Replace 'faqs' with the actual key from your API.
      final List<dynamic> data = response.data['faqs'] ?? [];

      return data.map((json) => FaqItem.fromJson(json)).toList();
    } catch (e) {
      // It's helpful to print the error to the console for debugging
      print('Failed to load FAQs: $e'); 
      throw Exception('Failed to load FAQs: $e');
    }
  }

  
  // ## THIS IS THE METHOD TO CHANGE ##
  Future<TermsInfo> getTerms() async {
    try {
      final response = await _dio.get('/JSON/terms.php');
      
      // OLD CODE:
      // final String termsContent = response.data.toString();
      // return TermsInfo(content: termsContent);

      // NEW CODE:
      // Treat the response as a Map and get the value from the "terms" key.
      // The '??' provides a default empty string if 'terms' is null.
      final String termsContent = response.data['terms'] ?? '';
      return TermsInfo(content: termsContent);

    } catch (e) {
      throw Exception('Failed to load terms: $e');
    }
  }
}