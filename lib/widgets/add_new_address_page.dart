import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penta_restaurant/commons/appcolors.dart';

class AddNewAddressPage extends StatefulWidget {
  const AddNewAddressPage({super.key});

  @override
  State<AddNewAddressPage> createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _addressLineController = TextEditingController();
  final _localityController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  String _addressType = 'Home';

  @override
  void dispose() {
    _phoneController.dispose();
    _pinCodeController.dispose();
    _houseNumberController.dispose();
    _addressLineController.dispose();
    _localityController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  void _saveAddressAndProceed() {
    if (_formKey.currentState!.validate()) {
      final fullAddress =
          '${_houseNumberController.text}, ${_addressLineController.text}, ${_localityController.text}, ${_cityController.text}, ${_stateController.text} - ${_pinCodeController.text}';

      Get.back(
        result: {'address': fullAddress, 'phone': _phoneController.text},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Address',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Form(
                key: _formKey,
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLocationOption(
                        icon: Icons.my_location,
                        text: 'Use my current Location',
                      ),
                      _buildLocationOption(
                        icon: Icons.map_outlined,
                        text: 'Search on map',
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _phoneController,
                        decoration: _buildInputDecoration('Phone Number*'),
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a phone number' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _pinCodeController,
                        decoration: _buildInputDecoration('Pin Code*'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a pin code' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _houseNumberController,
                        decoration: _buildInputDecoration('House Number/Tower/Block*'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a house number' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressLineController,
                        decoration: _buildInputDecoration(
                          'Address (locality, building, street)*',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter an address' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _localityController,
                        decoration: _buildInputDecoration('Locality / Town*'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a locality' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cityController,
                              decoration: _buildInputDecoration('City / District*'),
                              validator: (value) =>
                                  value!.isEmpty ? 'Please enter a city' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _stateController,
                              decoration: _buildInputDecoration('State*'),
                              validator: (value) =>
                                  value!.isEmpty ? 'Please enter a state' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Address Type',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Home',
                            groupValue: _addressType,
                            onChanged: (value) => setState(() => _addressType = value!),
                          ),
                          const Text('Home'),
                          Radio<String>(
                            value: 'Office',
                            groupValue: _addressType,
                            onChanged: (value) => setState(() => _addressType = value!),
                          ),
                          const Text('Office'),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _saveAddressAndProceed,
            child: const Text(
              'Save Address & Proceed',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationOption({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
