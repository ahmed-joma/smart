class HotelData {
  final HotelsData hotels;

  HotelData({required this.hotels});

  factory HotelData.fromJson(Map<String, dynamic> json) {
    print('🏨 HotelData.fromJson: $json');
    return HotelData(hotels: HotelsData.fromJson(json['hotels'] ?? {}));
  }
}

class HotelsData {
  final List<Hotel> nearLocationHotels;
  final List<Hotel> popularHotels;

  HotelsData({required this.nearLocationHotels, required this.popularHotels});

  factory HotelsData.fromJson(Map<String, dynamic> json) {
    print('🏨 HotelsData.fromJson: $json');
    print('🔍 Available keys: ${json.keys.toList()}');

    final nearLocationList =
        json['near_location_hotels'] as List<dynamic>? ?? [];
    final popularList = json['popular_hotels'] as List<dynamic>? ?? [];

    print('📊 Near location hotels count: ${nearLocationList.length}');
    print('📊 Popular hotels count: ${popularList.length}');

    if (nearLocationList.isNotEmpty) {
      print('📊 First near location hotel: ${nearLocationList.first}');
    }
    if (popularList.isNotEmpty) {
      print('📊 First popular hotel: ${popularList.first}');
    }

    return HotelsData(
      nearLocationHotels: nearLocationList
          .map((hotel) => Hotel.fromJson(hotel as Map<String, dynamic>))
          .toList(),
      popularHotels: popularList
          .map((hotel) => Hotel.fromJson(hotel as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Hotel {
  final int id;
  final String coverUrl;
  final String name;
  final int rate;
  final String city;
  final String venue;
  final String pricePerNight;
  final bool isFavorite;
  final String favoritableType;

  Hotel({
    required this.id,
    required this.coverUrl,
    required this.name,
    required this.rate,
    required this.city,
    required this.venue,
    required this.pricePerNight,
    required this.isFavorite,
    required this.favoritableType,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    print('🏨 Hotel.fromJson: ${json['name']} (ID: ${json['id']})');
    return Hotel(
      id: json['id'] ?? 0,
      coverUrl: json['cover_url']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Hotel',
      rate: json['rate'] ?? 0,
      city: json['city']?.toString() ?? 'Unknown City',
      venue: json['venue']?.toString() ?? 'Unknown Venue',
      pricePerNight: json['price_per_night']?.toString() ?? '0',
      isFavorite: json['is_favorite'] ?? false,
      favoritableType: json['favoritable_type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cover_url': coverUrl,
      'name': name,
      'rate': rate,
      'city': city,
      'venue': venue,
      'price_per_night': pricePerNight,
      'is_favorite': isFavorite,
      'favoritable_type': favoritableType,
    };
  }

  // Helper method to get rating as double
  double get ratingAsDouble => rate.toDouble();

  // Helper method to format price
  String get formattedPrice => 'SR$pricePerNight';

  // Helper method to get short venue (first line only)
  String get shortVenue {
    final lines = venue.split('\n');
    return lines.isNotEmpty ? lines.first : venue;
  }
}
