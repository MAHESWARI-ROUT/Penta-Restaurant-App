import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/restaurant_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RestaurantController restaurantController = Get.put(RestaurantController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: Get.back,
        ),
        title: const Text(
          'About Us',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (restaurantController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (restaurantController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load restaurant details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    restaurantController.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.grey2),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: restaurantController.refreshRestaurantDetails,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('Retry', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (restaurantController.restaurantImages.isNotEmpty)
                      Container(
                        height: size.height * 0.25,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.network(
                          restaurantController.restaurantImages.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppColors.grey5,
                            child: const Icon(Icons.restaurant, size: 64, color: AppColors.grey3),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    _buildInfoCard(
                      icon: Icons.restaurant,
                      title: restaurantController.restaurantName,
                      subtitle: restaurantController.cleanDescription,
                      color: AppColors.primary,
                    ),

                    const SizedBox(height: 16),

                    _buildInfoCard(
                      icon: Icons.location_on,
                      title: 'Address',
                      subtitle: restaurantController.restaurantAddress,
                      color: Colors.blue,
                      onTap: () {
                        final lat = restaurantController.restaurantDetail.value?.lat ?? '';
                        final lon = restaurantController.restaurantDetail.value?.lon ?? '';
                        if (lat.isNotEmpty && lon.isNotEmpty) {
                          _openMap(lat, lon);
                        } else {
                          _showErrorSnack('Map coordinates not available');
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    Wrap(
                      runSpacing: 16,
                      spacing: 16,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth < 400 ? double.infinity : (constraints.maxWidth / 2) - 20,
                          child: _buildInfoCard(
                            icon: Icons.phone,
                            title: 'Call Us',
                            subtitle: restaurantController.restaurantPhone,
                            color: Colors.green,
                            onTap: () {
                              final phone = restaurantController.restaurantPhone;
                              if (phone.isNotEmpty) {
                                _makePhoneCall(phone);
                              } else {
                                _showErrorSnack('Phone number not available');
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth < 400 ? double.infinity : (constraints.maxWidth / 2) - 20,
                          child: _buildInfoCard(
                            icon: Icons.web,
                            title: 'Website',
                            subtitle: 'Visit Our Site',
                            color: Colors.purple,
                            onTap: () {
                              final url = restaurantController.restaurantWeb;
                              if (url.startsWith('http')) {
                                _openWebsite(url);
                              } else {
                                _showErrorSnack('Invalid website URL');
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildInfoCard(
                      icon: Icons.access_time,
                      title: 'Operating Hours',
                      subtitle: restaurantController.restaurantTime,
                      color: Colors.orange,
                    ),

                    const SizedBox(height: 16),

                    _buildServiceDetailsCard(restaurantController),

                    const SizedBox(height: 16),

                    if (restaurantController.deliveryCities.isNotEmpty)
                      _buildDeliveryAreasCard(restaurantController),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: AppColors.grey2),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.arrow_forward_ios, color: AppColors.grey3, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDetailsCard(RestaurantController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.secondary1.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.info_outline, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            const Text('Service Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ]),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 400;
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildServiceItem('Currency', controller.restaurantCurrency, Icons.currency_rupee)),
                    if (!isSmallScreen) const SizedBox(width: 16),
                    Expanded(child: _buildServiceItem('Tax', '${controller.restaurantTax}%', Icons.receipt)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildServiceItem('Minimum Order',
                    '${controller.restaurantCurrency} ${controller.restaurantMinOrder}', Icons.shopping_cart),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(color: AppColors.fillSecondary, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.grey2)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildDeliveryAreasCard(RestaurantController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.delivery_dining, color: Colors.green, size: 24),
          ),
          const SizedBox(width: 16),
          const Text('Delivery Areas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ]),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.deliveryCities.map((pincode) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Text(pincode,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary)),
            );
          }).toList(),
        ),
      ]),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _showErrorSnack('Could not launch phone dialer');
    }
  }

  void _openWebsite(String url) async {
    if (url.isEmpty) {
      _showErrorSnack('Website URL is empty');
      return;
    }
    final Uri webUri = Uri.parse(url);
    if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } else {
      _showErrorSnack('Could not open website');
    }
  }

  void _openMap(String lat, String lon) async {
    if (lat.isEmpty || lon.isEmpty) {
      _showErrorSnack('Location coordinates are empty');
      return;
    }
    final Uri mapUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
    if (await canLaunchUrl(mapUri)) {
      await launchUrl(mapUri, mode: LaunchMode.externalApplication);
    } else {
      _showErrorSnack('Could not open maps');
    }
  }

  void _showErrorSnack(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
