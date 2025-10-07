import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/pages/home_page.dart';

class VerificationPage extends StatelessWidget {
  final String name;
  final String email;

  const VerificationPage({
    super.key,
    required this.name,
    required this.email,
  });

  Future<void> _sendWhatsAppVerification() async {
    final phone = '9163707 93232'; 
    final message =
        'Verification Request:\n\nName: $name\nEmail: $email\n\nPlease verify this user.';

    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open WhatsApp.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 200),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Please verify your account!',
                style: TextStyle(
                  color: AppColors.backgroundPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildDisplayField('Name', name),
            const SizedBox(height: 16),
            _buildDisplayField('Email', email),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _sendWhatsAppVerification,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Send WhatsApp Verification',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Get.offAll(() => const HomePage(), arguments: {'verified': false});
              },
              child: const Text(
                'Skip verification',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayField(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: ListTile(
        leading: Icon(
          label == 'Name' ? Icons.person : Icons.email,
          color: Colors.grey,
        ),
        title: Text(value),
      ),
    );
  }
}
