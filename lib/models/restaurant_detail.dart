class RestaurantDetail {
  final String name;
  final String address;
  final String description;
  final String phone;
  final String web;
  final String lat;
  final String lon;
  final String time;
  final String tax;
  final String currency;
  final String minorder;
  final List<String> images;
  final List<String> deliverycity;

  RestaurantDetail({
    required this.name,
    required this.address,
    required this.description,
    required this.phone,
    required this.web,
    required this.lat,
    required this.lon,
    required this.time,
    required this.tax,
    required this.currency,
    required this.minorder,
    required this.images,
    required this.deliverycity,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      phone: json['phone'] ?? '',
      web: json['web'] ?? '',
      lat: json['lat'] ?? '0',
      lon: json['lon'] ?? '0',
      time: json['time'] ?? '',
      tax: json['tax'] ?? '0',
      currency: json['currency'] ?? 'INR',
      minorder: json['minorder'] ?? '0',
      images: List<String>.from(json['images'] ?? []),
      deliverycity: List<String>.from(json['deliverycity'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'description': description,
      'phone': phone,
      'web': web,
      'lat': lat,
      'lon': lon,
      'time': time,
      'tax': tax,
      'currency': currency,
      'minorder': minorder,
      'images': images,
      'deliverycity': deliverycity,
    };
  }
}

class RestaurantDetailResponse {
  final bool success;
  final String message;
  final RestaurantDetail? restaurant;

  RestaurantDetailResponse({
    required this.success,
    required this.message,
    this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      success: json['success'] == true || json['success'] == 'true',
      message: json['message'] ?? '',
      restaurant: json['success'] == true || json['success'] == 'true'
          ? RestaurantDetail.fromJson(json)
          : null,
    );
  }
}
