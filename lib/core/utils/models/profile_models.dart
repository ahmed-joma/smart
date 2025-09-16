class ProfileResponse {
  final bool status;
  final int code;
  final String message;
  final ProfileData data;

  ProfileResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['msg'] ?? '',
      data: ProfileData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'msg': message,
      'data': data.toJson(),
    };
  }
}

class ProfileData {
  final UserProfile user;
  final Favorites favorites;

  ProfileData({required this.user, required this.favorites});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: UserProfile.fromJson(json['user'] ?? {}),
      favorites: Favorites.fromJson(json['favorites'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'favorites': favorites.toJson()};
  }
}

class UserProfile {
  final int id;
  final String imageUrl;
  final String fullName;
  final String aboutMe;

  UserProfile({
    required this.id,
    required this.imageUrl,
    required this.fullName,
    required this.aboutMe,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      fullName: json['full_name'] ?? '',
      aboutMe: json['about_me'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'full_name': fullName,
      'about_me': aboutMe,
    };
  }
}

class Favorites {
  final List<FavoriteEvent> events;
  final List<FavoriteHotel> hotels;

  Favorites({required this.events, required this.hotels});

  factory Favorites.fromJson(Map<String, dynamic> json) {
    return Favorites(
      events:
          (json['events'] as List<dynamic>?)
              ?.map((e) => FavoriteEvent.fromJson(e))
              .toList() ??
          [],
      hotels:
          (json['hotel'] as List<dynamic>?)
              ?.map((e) => FavoriteHotel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'events': events.map((e) => e.toJson()).toList(),
      'hotel': hotels.map((e) => e.toJson()).toList(),
    };
  }
}

class FavoriteEvent {
  final int id;
  final String title;
  final String city;
  final String venue;
  final String startAt;
  final String endAt;
  final String price;
  final String eventStatus;
  final String imageUrl;
  final String favoritableType;
  final List<String> attendeesImages;

  FavoriteEvent({
    required this.id,
    required this.title,
    required this.city,
    required this.venue,
    required this.startAt,
    required this.endAt,
    required this.price,
    required this.eventStatus,
    required this.imageUrl,
    required this.favoritableType,
    required this.attendeesImages,
  });

  factory FavoriteEvent.fromJson(Map<String, dynamic> json) {
    return FavoriteEvent(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      city: json['city'] ?? '',
      venue: json['venue'] ?? '',
      startAt: json['start_at'] ?? '',
      endAt: json['end_at'] ?? '',
      price: json['price'] ?? '',
      eventStatus: json['event_status'] ?? '',
      imageUrl: json['image_url'] ?? '',
      favoritableType: json['favoritable_type'] ?? '',
      attendeesImages:
          (json['get_attendees_images_attribute'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'city': city,
      'venue': venue,
      'start_at': startAt,
      'end_at': endAt,
      'price': price,
      'event_status': eventStatus,
      'image_url': imageUrl,
      'favoritable_type': favoritableType,
      'get_attendees_images_attribute': attendeesImages,
    };
  }
}

class FavoriteHotel {
  final int id;
  final String name;
  final String city;
  final String venue;
  final String pricePerNight;
  final int rate;
  final String coverUrl;
  final String favoritableType;
  final List<String> services;

  FavoriteHotel({
    required this.id,
    required this.name,
    required this.city,
    required this.venue,
    required this.pricePerNight,
    required this.rate,
    required this.coverUrl,
    required this.favoritableType,
    required this.services,
  });

  factory FavoriteHotel.fromJson(Map<String, dynamic> json) {
    return FavoriteHotel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      venue: json['venue'] ?? '',
      pricePerNight: json['price_per_night'] ?? '',
      rate: json['rate'] ?? 0,
      coverUrl: json['cover_url'] ?? '',
      favoritableType: json['favoritable_type'] ?? '',
      services:
          (json['services'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'venue': venue,
      'price_per_night': pricePerNight,
      'rate': rate,
      'cover_url': coverUrl,
      'favoritable_type': favoritableType,
      'services': services,
    };
  }
}

// Image Upload Models
class ImageUploadResponse {
  final bool status;
  final int code;
  final String msg;
  final String? imageUrl;

  ImageUploadResponse({
    required this.status,
    required this.code,
    required this.msg,
    this.imageUrl,
  });

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) {
    return ImageUploadResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      imageUrl: json['data']?['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'msg': msg,
      'data': {'image_url': imageUrl},
    };
  }
}
