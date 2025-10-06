import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/faq_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FAQController faqController = Get.put(FAQController());

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkGreen),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'FAQ',
          style: TextStyle(
            color: AppColors.darkGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (faqController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.darkGreen,
            ),
          );
        }

        if (faqController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load FAQ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  faqController.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.grey2),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => faqController.refreshFAQ(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGreen,
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => faqController.refreshFAQ(),
          color: AppColors.darkGreen,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.darkGreen.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.help_outline,
                          size: 48,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        faqController.faqTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Find answers to frequently asked questions about our app and services.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey2,
                        ),
                      ),
                    ],
                  ),
                ),

                // FAQ Items
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: faqController.faqItems.asMap().entries.map((entry) {
                      int index = entry.key;
                      var faqItem = entry.value;
                      return _buildFAQCard(faqItem, index);
                    }).toList(),
                  ),
                ),

                // Contact Section
                // Container(
                //   width: double.infinity,
                //   margin: const EdgeInsets.all(16),
                //   padding: const EdgeInsets.all(24),
                //   decoration: BoxDecoration(
                //     color: AppColors.darkGreen,
                //     borderRadius: BorderRadius.circular(16),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black.withOpacity(0.1),
                //         blurRadius: 8,
                //         offset: const Offset(0, 4),
                //       ),
                //     ],
                //   ),
                //   child: Column(
                //     children: [
                //       const Icon(
                //         Icons.support_agent,
                //         size: 48,
                //         color: Colors.white,
                //       ),
                //       const SizedBox(height: 16),
                //       const Text(
                //         'Still have questions?',
                //         style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white,
                //         ),
                //       ),
                //       const SizedBox(height: 8),
                //       const Text(
                //         'Contact our support team for immediate assistance',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //           fontSize: 14,
                //           color: Colors.white70,
                //         ),
                //       ),
                //       const SizedBox(height: 20),
                //       Row(
                //         children: [
                //           Expanded(
                //             child: ElevatedButton.icon(
                //               onPressed: () => _makePhoneCall('+916370209011'),
                //               style: ElevatedButton.styleFrom(
                //                 backgroundColor: Colors.white,
                //                 foregroundColor: AppColors.darkGreen,
                //                 padding: const EdgeInsets.symmetric(vertical: 12),
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(8),
                //                 ),
                //               ),
                //               icon: const Icon(Icons.phone, size: 18),
                //               label: const Text(
                //                 'Call Us',
                //                 style: TextStyle(fontWeight: FontWeight.bold),
                //               ),
                //             ),
                //           ),
                //           const SizedBox(width: 12),
                //           Expanded(
                //             child: ElevatedButton.icon(
                //               onPressed: () => _sendEmail('santosh.fusionx@gmail.com'),
                //               style: ElevatedButton.styleFrom(
                //                 backgroundColor: Colors.white,
                //                 foregroundColor: AppColors.darkGreen,
                //                 padding: const EdgeInsets.symmetric(vertical: 12),
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(8),
                //                 ),
                //               ),
                //               icon: const Icon(Icons.email, size: 18),
                //               label: const Text(
                //                 'Email',
                //                 style: TextStyle(fontWeight: FontWeight.bold),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFAQCard(var faqItem, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.darkGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          title: Text(
            faqItem.question,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: AppColors.darkGreen,
            ),
          ),
          iconColor: AppColors.darkGreen,
          collapsedIconColor: AppColors.grey2,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.fillSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _cleanAnswer(faqItem.answer),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.labelSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _cleanAnswer(String answer) {
    // Clean up the answer text
    String cleaned = answer;
    cleaned = cleaned.replaceAll(RegExp(r'\n+'), '\n');
    cleaned = cleaned.trim();

    // Remove any remaining HTML entities
    cleaned = cleaned.replaceAll('&nbsp;', ' ');
    cleaned = cleaned.replaceAll('&ldquo;', '"');
    cleaned = cleaned.replaceAll('&rdquo;', '"');
    cleaned = cleaned.replaceAll('&amp;', '&');

    return cleaned;
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        Get.snackbar('Error', 'Could not launch phone dialer',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print('Error launching phone dialer: $e');
    }
  }

  void _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'App Support Request'},
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar('Error', 'Could not launch email client',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print('Error launching email client: $e');
    }
  }


}
