import 'package:flutter/material.dart';
import 'package:penta_restaurant/models/info_model.dart';
import 'package:penta_restaurant/services/info_service.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  // The Future that will be used by the FutureBuilder
  late Future<List<FaqItem>> _faqFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future in initState to prevent re-fetching on rebuilds
    _faqFuture = InfoService().getFAQ();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      body: FutureBuilder<List<FaqItem>>(
        future: _faqFuture,
        builder: (context, snapshot) {
          // 1. Show a loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Show an error message if something went wrong
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // 3. Show a message if there's no data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No FAQs found.'));
          }
          // 4. If data is available, display it in a list
          final faqs = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              final faq = faqs[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: ExpansionTile(
                  title: Text(faq.question, style: const TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(faq.answer),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}