import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/pages/home_page.dart';
import 'package:penta_restaurant/pages/tabs/profile_page.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/widgets/ctextform_field.dart';
import 'package:penta_restaurant/widgets/show_popup_dialog.dart.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ProfileController profileController = Get.find<ProfileController>();

  // Text editing controllers
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController genderController;
  late TextEditingController cityController;
  late TextEditingController localityController;
  late TextEditingController flatController;
  late TextEditingController pincodeController;
  late TextEditingController stateController;
  late TextEditingController landmarkController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current profile data
    nameController = TextEditingController(text: profileController.displayName);
    emailController = TextEditingController(text: profileController.displayEmail);
    mobileController = TextEditingController(text: profileController.displayMobile);
    genderController = TextEditingController(text: profileController.displayGender);
    cityController = TextEditingController(text: profileController.displayCity);
    localityController = TextEditingController(text: profileController.displayLocality);
    flatController = TextEditingController(text: profileController.displayFlat);
    pincodeController = TextEditingController(text: profileController.displayPincode);
    stateController = TextEditingController(text: profileController.displayState);
    landmarkController = TextEditingController(text: profileController.displayLandmark);
  }

  @override
  void dispose() {
    // Dispose all controllers
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    genderController.dispose();
    cityController.dispose();
    localityController.dispose();
    flatController.dispose();
    pincodeController.dispose();
    stateController.dispose();
    landmarkController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    final profileData = {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'mobile': mobileController.text.trim(),
      'gender': genderController.text.trim(),
      'city': cityController.text.trim(),
      'locality': localityController.text.trim(),
      'flat': flatController.text.trim(),
      'pincode': pincodeController.text.trim(),
      'state': stateController.text.trim(),
      'landmark': landmarkController.text.trim(),
    };

    final success = await profileController.updateProfile(profileData);

    if (success) {
      showPopupDialog(context);
      // Navigate back after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Get.back(); // Go back to profile page
      });
    } else {
      Get.snackbar(
        'Error',
        profileController.errorMessage.value.isNotEmpty
            ? profileController.errorMessage.value
            : 'Failed to update profile',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.darkGreen,
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 40.0,
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 247, 199, 127),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: Icon(Icons.arrow_back),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text('Edit Profile', style: TextStyle(fontSize: 16)),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightYellow,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.shopping_cart),
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 150,
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lightYellow,
                        border: Border.all(
                          color: AppColors.backgroundPrimary,
                          width: 3,
                        ),
                      ),
                      child: profileController.hasProfile && profileController.displayName.isNotEmpty
                          ? Center(
                              child: Text(
                                profileController.displayName[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGreen,
                                ),
                              ),
                            )
                          : const Icon(Icons.person, size: 60, color: AppColors.grey1),
                    ),
                  ),
                  Positioned(
                    top: 209,
                    left: 202,
                    child: Icon(
                      Icons.add_circle,
                      size: 40,
                      color: AppColors.yellow,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    _buildTextField('Full Name', nameController),
                    SizedBox(height: 10),
                    _buildTextField('E-mail', emailController),
                    SizedBox(height: 10),
                    _buildTextField('Mobile phone', mobileController),
                    SizedBox(height: 10),
                    _buildTextField('Gender', genderController),
                    SizedBox(height: 10),
                    _buildTextField('City', cityController),
                    SizedBox(height: 10),
                    _buildTextField('Locality', localityController),
                    SizedBox(height: 10),
                    _buildTextField('Flat/House No', flatController),
                    SizedBox(height: 10),
                    _buildTextField('Pincode', pincodeController),
                    SizedBox(height: 10),
                    _buildTextField('State', stateController),
                    SizedBox(height: 10),
                    _buildTextField('Landmark', landmarkController),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellow,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Update Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.separatorOpaque),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
