import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:penta_restaurant/models/info_model.dart';
import 'package:penta_restaurant/services/info_service.dart';


class TermsPage extends StatefulWidget {
  const TermsPage({super.key});
   @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
   late Future<TermsInfo> _termsFuture;

  @override
  void initState() {
    super.initState();
    _termsFuture = InfoService().getTerms();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Terms of Use'),
    ),
    body: FutureBuilder<TermsInfo>(
      future: _termsFuture,
      builder: (context, snapshot) {
        // ... (loading and error states are the same)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.content.isEmpty) {
          return const Center(child: Text('Terms not available.'));
        }
        
        // 1. Get the data from the snapshot
        final terms = snapshot.data!;

        // 2. -> ADD THE CLEANING CODE HERE <-
        final cleanedHtml = terms.content
            .replaceAll(RegExp(r'\\r|\\n|\\t'), '')
            .replaceAll('</Vli>', '</li>');

        // 3. Return the widget tree
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Html(
            // 4. Use the new 'cleanedHtml' variable here
            data: cleanedHtml, 
            style: {
              "body": Style(
                fontSize: FontSize(16.0),
                color: Colors.black87,
              ),
              "h2": Style(
                fontSize: FontSize(22.0),
                fontWeight: FontWeight.bold,
              ),
            },
          ),
        );
      },
    ),
  );
}}