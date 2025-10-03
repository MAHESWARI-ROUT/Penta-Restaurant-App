class AuthResponse {
  final bool success;
  final String message;
  final String? userId;

  AuthResponse({
    required this.success,
    required this.message,
    this.userId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] == 'true', // Convert string "true"/"false" to bool
      message: json['message'],
      userId: json['userid'], // userid as String
    );
  }
}


class UserData {
  final String userId;
  final String name;
  final String email;
  final String mobileNum;
  final String profession;
  final String loginType;

  UserData({
    required this.userId,
    required this.name,
    required this.email,
    required this.mobileNum,
    required this.profession,
    required this.loginType,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['user_id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobileNum: json['mobilenum'] ?? '',
      profession: json['profession'] ?? '',
      loginType: json['logintype'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'mobilenum': mobileNum,
      'profession': profession,
      'logintype': loginType,
    };
  }
}
