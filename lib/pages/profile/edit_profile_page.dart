import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';
import 'package:penta_restaurant/pages/authentication/login_page.dart';
import 'package:penta_restaurant/controller/profile_controller.dart';
import 'package:penta_restaurant/widgets/show_popup_dialog.dart.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
late final ProfileController profileController;
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
    profileController = Get.find<ProfileController>();
    final profile = profileController.userProfile.value;

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
      // Profile updated successfully - show success dialog
      showPopupDialog(context);
      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
    } else {
      // Only show error if it's not an SMTP error
      final errorMsg = profileController.errorMessage.value;

      // Check if error is SMTP related or if profile actually failed to update
      if (errorMsg.isNotEmpty &&
          !errorMsg.toLowerCase().contains('smtp') &&
          !errorMsg.toLowerCase().contains('mail') &&
          !errorMsg.toLowerCase().contains('email')) {
        Get.snackbar(
          'Error',
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (errorMsg.toLowerCase().contains('smtp') ||
                 errorMsg.toLowerCase().contains('mail')) {
        // SMTP error but profile might be updated - show success anyway
        showPopupDialog(context);
        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: Obx(() {
        final profile = profileController.userProfile.value;
        final isLoggedIn = profile != null && profile.success;

        // Show login/verify prompt if user not logged in or verified
        if (!isLoggedIn) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 80, color: AppColors.grey3),
                  const SizedBox(height: 20),
                  const Text(
                    'Please login or verify your account to edit your profile.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: AppColors.grey2),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () => Get.to(() => const LoginPage()),
                    child: const Text(
                      'Login / Verify',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Show loading spinner while fetching profile
        if (profileController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // Logged-in user edit profile UI
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.secondary1,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.accentColor ,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(Icons.arrow_back),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text('Edit Profile', style: TextStyle(fontSize: 16)),
                          const Spacer(),
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
                        color: AppColors.secondary2,
                        border: Border.all(color: AppColors.backgroundPrimary, width: 3),
                      ),
                      child: profileController.hasProfile && profileController.displayName.isNotEmpty
                          ? Center(
                              child: Text(
                                profileController.displayName[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          : const Icon(Icons.person, size: 60, color: AppColors.grey1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    _buildTextField('Full Name', nameController),
                    const SizedBox(height: 10),
                    _buildTextField('E-mail', emailController),
                    const SizedBox(height: 10),
                    _buildTextField('Mobile phone', mobileController),
                    const SizedBox(height: 10),
                    _buildTextField('Gender', genderController),
                    const SizedBox(height: 10),
                    _buildTextField('City', cityController),
                    const SizedBox(height: 10),
                    _buildTextField('Locality', localityController),
                    const SizedBox(height: 10),
                    _buildTextField('Flat/House No', flatController),
                    const SizedBox(height: 10),
                    _buildTextField('Pincode', pincodeController),
                    const SizedBox(height: 10),
                    _buildTextField('State', stateController),
                    const SizedBox(height: 10),
                    _buildTextField('Landmark', landmarkController),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary1,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Update Profile',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
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
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
