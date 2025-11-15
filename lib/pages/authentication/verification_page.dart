import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/pages/main_layout.dart';

class VerificationPage extends StatelessWidget {
  final String name;
  final String email;

  const VerificationPage({
    super.key,
    required this.name,
    required this.email,
  });

  Future<void> _sendWhatsAppVerification() async {
    final phone = '916370793232';
    final message =
        'Verification Request:\n\nEmail: $email\n\nPlease verify this user.';

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
    final size = MediaQuery.of(context).size;
    final textScale = size.width / 390; // scales text proportionally

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.15),
              Text(
                'Please verify your account!',
                style: TextStyle(
                  color: AppColors.backgroundPrimary,
                  fontSize: 26 * textScale,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.04),

              // _buildDisplayField('Name', name),
              // SizedBox(height: size.height * 0.02),
              _buildDisplayField('Email', email),
              SizedBox(height: size.height * 0.05),

              Center(
                child: ElevatedButton(
                  onPressed: _sendWhatsAppVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary1,
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.12,
                      vertical: size.height * 0.018,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Send WhatsApp Verification',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16 * textScale,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),

              Center(
                child: TextButton(
                  onPressed: () {
                    Get.offAll(() => const MainLayout(), arguments: {'verified': false});
                  },
                  child: Text(
                    'Skip verification',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14 * textScale,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
            ],
          ),
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
        title: Text(
          value,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
