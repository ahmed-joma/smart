// Filter Models for API Integration

// Filter Details Response (from getDetails API)
class FilterDetails {
  final List<City> cities;
  final List<Tag> tags;

  FilterDetails({required this.cities, required this.tags});

  factory FilterDetails.fromJson(Map<String, dynamic> json) {
    return FilterDetails(
      cities:
          (json['cites']
                  as List<dynamic>?) // Note: API uses "cites" not "cities"
              ?.map((e) => City.fromJson(e))
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// Filter Result Response (from filter API)
class FilterResult {
  final List<FilterEvent> events;
  final List<FilterHotel> hotels;

  FilterResult({required this.events, required this.hotels});

  factory FilterResult.fromJson(Map<String, dynamic> json) {
    return FilterResult(
      events:
          (json['events'] as List<dynamic>?)
              ?.map((e) => FilterEvent.fromJson(e))
              .toList() ??
          [],
      hotels:
          (json['hotels'] as List<dynamic>?)
              ?.map((e) => FilterHotel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// Filter Request
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
    if (tags != null && tags!.isNotEmpty) {
      for (int i = 0; i < tags!.length; i++) {
        params['tags[$i]'] = tags![i];
      }
    }
    if (startAtFrom != null) params['start_at_from'] = startAtFrom;
    if (endAtTo != null) params['end_at_to'] = endAtTo;
    if (cityId != null) params['city_id'] = cityId;
    if (priceMin != null) params['price_min'] = priceMin;
    if (priceMax != null) params['price_max'] = priceMax;

    return params;
  }

  Map<String, dynamic> toJson() {
    return {
      'q': q,
      'tags': tags,
      'start_at_from': startAtFrom,
      'end_at_to': endAtTo,
      'city_id': cityId,
      'price_min': priceMin,
      'price_max': priceMax,
    };
  }
}

// City Model
class City {
  final int id;
  final String name;
  final String imageUrl;

  City({required this.id, required this.name, required this.imageUrl});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image_url': imageUrl};
  }
}

// Tag Model
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

// Filter Event Model
class FilterEvent {
  final int id;
  final String formattedStartAt;
  final String imageUrl;
  final List<String> attendeesImages;
  final String cityName;
  final String venue;
  final bool isFavorite;
  final String favoritableType;
  final String? title;
  final String? price;
  final String? eventStatus;

  FilterEvent({
    required this.id,
    required this.formattedStartAt,
    required this.imageUrl,
    required this.attendeesImages,
    required this.cityName,
    required this.venue,
    required this.isFavorite,
    required this.favoritableType,
    this.title,
    this.price,
    this.eventStatus,
  });

  factory FilterEvent.fromJson(Map<String, dynamic> json) {
    return FilterEvent(
      id: json['id'] ?? 0,
      formattedStartAt: json['formatted_start_at'] ?? '',
      imageUrl: json['image_url'] ?? '',
      attendeesImages:
          (json['attendees_images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      cityName: json['city_name'] ?? '',
      venue: json['venue'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
      favoritableType: json['favoritable_type'] ?? '',
      title: json['title'],
      price: json['price'],
      eventStatus: json['event_status'],
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
      'title': title,
      'price': price,
      'event_status': eventStatus,
    };
  }
}

// Filter Hotel Model
class FilterHotel {
  final int id;
  final String coverUrl;
  final String name;
  final int rate;
  final String city;
  final String venue;
  final String pricePerNight;
  final bool isFavorite;
  final String favoritableType;

  FilterHotel({
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

  factory FilterHotel.fromJson(Map<String, dynamic> json) {
    return FilterHotel(
      id: json['id'] ?? 0,
      coverUrl: json['cover_url'] ?? '',
      name: json['name'] ?? '',
      rate: json['rate'] ?? 0,
      city: json['city'] ?? '',
      venue: json['venue'] ?? '',
      pricePerNight: json['price_per_night'] ?? '',
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

// Legacy models for backward compatibility
class Event {
  final int id;
  final String title;

  Event({required this.id, required this.title});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(id: json['id'] ?? 0, title: json['title'] ?? '');
  }
}

class Hotel {
  final int id;
  final String name;

  Hotel({required this.id, required this.name});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
