class City {
  final int id;
  final String name;
  final String imageUrl;
  final CityImage image;

  City({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.image,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      image: CityImage.fromJson(json['image'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'image': image.toJson(),
    };
  }
}

class CityImage {
  final int id;
  final String path;
  final String imageableType;
  final int imageableId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CityImage({
    required this.id,
    required this.path,
    required this.imageableType,
    required this.imageableId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CityImage.fromJson(Map<String, dynamic> json) {
    return CityImage(
      id: json['id'] ?? 0,
      path: json['path'] ?? '',
      imageableType: json['imageable_type'] ?? '',
      imageableId: json['imageable_id'] ?? 0,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'imageable_type': imageableType,
      'imageable_id': imageableId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Tag {
  final int id;
  final String name;

  Tag({required this.id, required this.name});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class FilterDetails {
  final List<City> cities;
  final List<Tag> tags;

  FilterDetails({required this.cities, required this.tags});

  factory FilterDetails.fromJson(Map<String, dynamic> json) {
    return FilterDetails(
      cities:
          (json['cites'] as List<dynamic>?)
              ?.map((city) => City.fromJson(city))
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((tag) => Tag.fromJson(tag))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cites': cities.map((city) => city.toJson()).toList(),
      'tags': tags.map((tag) => tag.toJson()).toList(),
    };
  }
}

class Event {
  final int id;
  final String formattedStartAt;
  final String imageUrl;
  final List<String> attendeesImages;
  final String cityName;
  final String venue;
  final bool isFavorite;
  final String favoritableType;

  Event({
    required this.id,
    required this.formattedStartAt,
    required this.imageUrl,
    required this.attendeesImages,
    required this.cityName,
    required this.venue,
    required this.isFavorite,
    required this.favoritableType,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      formattedStartAt: json['formatted_start_at'] ?? '',
      imageUrl: json['image_url'] ?? '',
      attendeesImages:
          (json['attendees_images'] as List<dynamic>?)
              ?.map((image) => image.toString())
              .toList() ??
          [],
      cityName: json['city_name'] ?? '',
      venue: json['venue'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
      favoritableType: json['favoritable_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formatted_start_at': formattedStartAt,
      'image_url': imageUrl,
      'attendees_images': attendeesImages,
      'city_name': cityName,
      'venue': venue,
      'is_favorite': isFavorite,
      'favoritable_type': favoritableType,
    };
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
    return Hotel(
      id: json['id'] ?? 0,
      coverUrl: json['cover_url'] ?? '',
      name: json['name'] ?? '',
      rate: json['rate'] ?? 0,
      city: json['city'] ?? '',
      venue: json['venue'] ?? '',
      pricePerNight: json['price_per_night'] ?? '0',
      isFavorite: json['is_favorite'] ?? false,
      favoritableType: json['favoritable_type'] ?? '',
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
}

class FilterResult {
  final List<Event> events;
  final List<Hotel> hotels;

  FilterResult({required this.events, required this.hotels});

  factory FilterResult.fromJson(Map<String, dynamic> json) {
    return FilterResult(
      events:
          (json['events'] as List<dynamic>?)
              ?.map((event) => Event.fromJson(event))
              .toList() ??
          [],
      hotels:
          (json['hotels'] as List<dynamic>?)
              ?.map((hotel) => Hotel.fromJson(hotel))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'events': events.map((event) => event.toJson()).toList(),
      'hotels': hotels.map((hotel) => hotel.toJson()).toList(),
    };
  }
}

class FilterRequest {
  final String? q;
  final List<int>? tags;
  final String? startAtFrom;
  final String? endAtTo;
  final int? cityId;
  final double? priceMin;
  final double? priceMax;

  FilterRequest({
    this.q,
    this.tags,
    this.startAtFrom,
    this.endAtTo,
    this.cityId,
    this.priceMin,
    this.priceMax,
  });

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {};

    if (q != null && q!.isNotEmpty) params['q'] = q;
    if (tags != null && tags!.isNotEmpty) params['tags[]'] = tags;
    if (startAtFrom != null && startAtFrom!.isNotEmpty)
      params['start_at_from'] = startAtFrom;
    if (endAtTo != null && endAtTo!.isNotEmpty) params['end_at_to'] = endAtTo;
    if (cityId != null) params['city_id'] = cityId;
    if (priceMin != null) params['price_min'] = priceMin;
    if (priceMax != null) params['price_max'] = priceMax;

    return params;
  }
}
