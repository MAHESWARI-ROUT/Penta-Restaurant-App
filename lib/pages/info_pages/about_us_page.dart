import 'package:flutter/material.dart';
import 'package:penta_restaurant/commons/app_Icon.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'faq_page.dart';
import 'terms_page.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo and Version Card
            Card(
              color: AppColors.grey1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: AppIcon(),
              ),
            ),
            const SizedBox(height: 24),

            // About Us Text Section
            const Text(
              'About Us',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Our restaurant app is designed to make it easy for customers to discover and order from their favorite restaurants. With our user-friendly interface, customers can browse menus, place orders, and track delivery in real-time...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Navigation Tiles
            _buildInfoTile(
              context,
              title: "What's New?",
              onTap: () {},
            ),
            _buildInfoTile(
              context,
              title: 'Terms of Use',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsPage()));
              },
            ),
            _buildInfoTile(
              context,
              title: 'Privacy',
              onTap: () {},
            ),
            _buildInfoTile(
                context,
                title: 'FAQ',
                onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FaqPage()));
                }
            ),
          ],
        ),
      ),
      // REMOVED: The entire bottomNavigationBar which contained the copyright text
      bottomNavigationBar: null,
    );
  }

  Widget _buildInfoTile(BuildContext context, {required String title, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}