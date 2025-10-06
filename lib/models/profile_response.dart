class UserProfile {
  final bool success;
  final String message;
  final String name;
  final String gender;
  final String mobile;
  final String city;
  final String locality;
  final String flat;
  final String pincode;
  final String state;
  final String landmark;
  final String email;

  UserProfile({
    required this.success,
    required this.message,
    required this.name,
    required this.gender,
    required this.mobile,
    required this.city,
    required this.locality,
    required this.flat,
    required this.pincode,
    required this.state,
    required this.landmark,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      success: (json['success']?.toString().toLowerCase() == 'true'),
      message: json['message'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      mobile: json['mobile'] ?? '',
      city: json['city'] ?? '',
      locality: json['locality'] ?? '',
      flat: json['flat'] ?? '',
      pincode: json['pincode'] ?? '',
      state: json['state'] ?? '',
      landmark: json['landmark'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
