import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/widgets/add_new_address_page.dart';

class MyAddressPage extends StatefulWidget {
  const MyAddressPage({super.key});

  @override
  State<MyAddressPage> createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  final ProfileController profileController = Get.find<ProfileController>();
  final RxList<Map<String, String>> savedAddresses = <Map<String, String>>[].obs;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    // Load default address from user profile
    if (profileController.userProfile.value != null) {
      final profile = profileController.userProfile.value!;

      // Check if profile has address data
      if (profile.flat.isNotEmpty || profile.locality.isNotEmpty) {
        final defaultAddress = {
          'type': 'Default',
          'address': '${profile.flat}${profile.flat.isNotEmpty && profile.locality.isNotEmpty ? ', ' : ''}${profile.locality}',
          'city': '${profile.city}${profile.city.isNotEmpty && profile.state.isNotEmpty ? ', ' : ''}${profile.state}${profile.pincode.isNotEmpty ? ' - ' : ''}${profile.pincode}',
          'phone': profile.mobile,
          'landmark': profile.landmark,
        };

        savedAddresses.add(defaultAddress);
      }
    }
  }

  void _showAddAddressBottomSheet() {
    Get.bottomSheet(
      AddNewAddressPage(),
      isScrollControlled: true,
      enableDrag: false,
    ).then((result) {
      if (result != null && result is Map<String, String>) {
        savedAddresses.add({
          'type': 'Home', // Default type for new addresses
          'address': result['address']!,
          'city': '',
          'phone': result['phone']!,
          'landmark': '',
        });
        Get.snackbar(
          'Success',
          'Address added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'My Addresses',
          style: TextStyle(
            color: AppColors.darkGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saved Addresses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(height: 16),

              // Address Cards
              if (savedAddresses.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_off_outlined,
                        size: 64,
                        color: AppColors.grey2,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No saved addresses',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add your delivery addresses to make ordering faster',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ...savedAddresses.asMap().entries.map((entry) {
                  final index = entry.key;
                  final address = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Address Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.darkGreen.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      address['type']!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darkGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                address['address']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (address['city']!.isNotEmpty)
                                Text(
                                  address['city']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.grey2,
                                  ),
                                ),
                              if (address['landmark']!.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'Landmark: ${address['landmark']!}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.grey2,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 4),
                              if (address['phone']!.isNotEmpty)
                                Text(
                                  address['phone']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.grey2,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Delete Button (only for non-default addresses)
                        if (address['type'] != 'Default')
                          IconButton(
                            onPressed: () {
                              savedAddresses.removeAt(index);
                              Get.snackbar(
                                'Success',
                                'Address removed',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red[400],
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 16),

              // Add New Address Card
              // InkWell(
              //   onTap: _showAddAddressBottomSheet,
              //   borderRadius: BorderRadius.circular(16),
              //   child: Container(
              //     padding: const EdgeInsets.all(20),
              //     decoration: BoxDecoration(
              //       color: AppColors.white,
              //       borderRadius: BorderRadius.circular(16),
              //       border: Border.all(
              //         color: AppColors.darkGreen,
              //         style: BorderStyle.solid,
              //         width: 2,
              //       ),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(0.05),
              //           blurRadius: 8,
              //           offset: const Offset(0, 2),
              //         ),
              //       ],
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Container(
              //           padding: const EdgeInsets.all(8),
              //           decoration: BoxDecoration(
              //             color: AppColors.darkGreen.withOpacity(0.1),
              //             shape: BoxShape.circle,
              //           ),
              //           child: const Icon(
              //             Icons.add,
              //             color: AppColors.darkGreen,
              //             size: 24,
              //           ),
              //         ),
              //         const SizedBox(width: 12),
              //         const Text(
              //           'Add New Address',
              //           style: TextStyle(
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //             color: AppColors.darkGreen,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      }),
    );
  }
}
