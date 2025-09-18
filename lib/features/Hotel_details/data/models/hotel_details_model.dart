class HotelDetailsResponse {
  final bool status;
  final int code;
  final String msg;
  final HotelDetailsData data;

  HotelDetailsResponse({
    required this.status,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory HotelDetailsResponse.fromJson(Map<String, dynamic> json) {
    print('🏨 HotelDetailsResponse.fromJson: $json');
    return HotelDetailsResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      data: HotelDetailsData.fromJson(json['data'] ?? {}),
    );
  }
}

class HotelDetailsData {
  final HotelDetails hotel;

  HotelDetailsData({required this.hotel});

  factory HotelDetailsData.fromJson(Map<String, dynamic> json) {
    print('🏨 HotelDetailsData.fromJson: $json');
    return HotelDetailsData(hotel: HotelDetails.fromJson(json['hotel'] ?? {}));
  }
}

class HotelDetails {
  final int id;
  final String coverUrl;
  final List<String> services;
  final int rate;
  final String name;
  final String city;
  final String venue;
  final String pricePerNight;
  final String description;
  final bool isFavorite;
  final String favoritableType;

  HotelDetails({
    required this.id,
    required this.coverUrl,
    required this.services,
    required this.rate,
    required this.name,
    required this.city,
    required this.venue,
    required this.pricePerNight,
    required this.description,
    required this.isFavorite,
    required this.favoritableType,
  });

  factory HotelDetails.fromJson(Map<String, dynamic> json) {
    print('🏨 HotelDetails.fromJson: ${json['name']} (ID: ${json['id']})');

    final servicesList = json['services'] as List<dynamic>? ?? [];

    return HotelDetails(
      id: json['id'] ?? 0,
      coverUrl: json['cover_url']?.toString() ?? '',
      services: servicesList.map((service) => service.toString()).toList(),
      rate: json['rate'] ?? 0,
      name: json['name']?.toString() ?? 'Unknown Hotel',
      city: json['city']?.toString() ?? 'Unknown City',
      venue: json['venue']?.toString() ?? 'Unknown Venue',
      pricePerNight: json['price_per_night']?.toString() ?? '0',
      description:
          json['description']?.toString() ?? 'No description available',
      isFavorite: json['is_favorite'] ?? false,
      favoritableType: json['favoritable_type']?.toString() ?? '',
    );
  }

  // Helper methods
  double get ratingAsDouble => rate.toDouble();
  String get formattedPrice => 'SR$pricePerNight';

  String get shortVenue {
    if (venue.isEmpty) return 'Location not specified';
    final lines = venue.split('\n');
    return lines.isNotEmpty ? lines.first : venue;
  }

  String get fullVenue {
    return venue.replaceAll('\n', ', ');
  }

  // Convert to hotel data format for UI compatibility
  Map<String, dynamic> toHotelData() {
    print('🔄 Converting HotelDetails to HotelData...');
    print('📊 Original data: name=$name, coverUrl=$coverUrl, city=$city');

    final hotelData = {
      'id': id,
      'title': name,
      'date': '14 December, 2025', // Default date for now
      'day': 'Tuesday',
      'time': 'Check-in: 3:00PM',
      'location': fullVenue,
      'country': 'KSA',
      'organizer': 'Hotel Management',
      'organizerCountry': 'KSA',
      'about': description,
      'price': formattedPrice,
      'image': coverUrl,
      'services': services,
      'rating': rate,
      'city': city,
      'is_favorite': isFavorite,
    };

    print('✅ Converted HotelData: ${hotelData.keys.toList()}');
    print('🎯 Final image URL: ${hotelData['image']}');
    print('✅ toHotelData() successful');

    return hotelData;
  }
}
