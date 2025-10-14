import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:penta_restaurant/commons/appcolors.dart';

class VerificationErrorPage extends StatelessWidget {
  final String message;
  final String whatsAppPhoneNumber;
  final String? userEmail;
  final bool isAppBar;
  final String appbarTitle;

  const VerificationErrorPage({
    super.key,
    this.message = 'Please verify your email to continue.',
    this.whatsAppPhoneNumber = '916370793232',
    this.userEmail,
    this.isAppBar = false,
    this.appbarTitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: isAppBar
          ? AppBar(
              backgroundColor: AppColors.secondary1,
              title: Text(
                appbarTitle,
                // style: TextStyle(color: AppColors),
              ),
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
            )
          : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 80, color: AppColors.grey3),
              const SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(fontSize: 18, color: AppColors.grey2),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 4,
                ),
                onPressed: () => _launchWhatsApp(),
                child: const Text(
                  'Verify Now',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchWhatsApp() async {
    if (whatsAppPhoneNumber.isEmpty) {
      Get.snackbar('Error', 'WhatsApp number not configured.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final message = 'Verification Request:\n\nEmail: ${userEmail ?? ''}\n\nPlease verify this user.';
    final url = 'https://wa.me/$whatsAppPhoneNumber?text=${Uri.encodeComponent(message)}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open WhatsApp.', snackPosition: SnackPosition.BOTTOM);
    }
  }
}

class UnverifiedUserDialog extends StatelessWidget {
  final String whatsAppPhoneNumber;
  final String? userEmail;
  final String? message;

  const UnverifiedUserDialog({
    Key? key,
    this.whatsAppPhoneNumber = '916370793232',
    this.userEmail,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Account Not Verified'),
      content: Text(
        message ?? 'Please verify your email to continue.',
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 4,
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog first
            _launchWhatsApp(context);
          },
          child: const Text('Verify Now',style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }

  void _launchWhatsApp(BuildContext context) async {
    if (whatsAppPhoneNumber.isEmpty) {
      Get.snackbar('Error', 'WhatsApp number not configured.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final message = 'Verification Request:\n\nEmail: ${userEmail ?? ''}\n\nPlease verify this user.';
    final url = 'https://wa.me/$whatsAppPhoneNumber?text=${Uri.encodeComponent(message)}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open WhatsApp.', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
