// Home API Models
class HomeResponse {
  final bool status;
  final int code;
  final String msg;
  final HomeData data;

  HomeResponse({
    required this.status,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      data: HomeData.fromJson(json['data'] ?? {}),
    );
  }
}

class HomeData {
  final EventsData events;

  HomeData({required this.events});

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(events: EventsData.fromJson(json['events'] ?? {}));
  }
}

class EventsData {
  final List<HomeEvent> upcoming;
  final List<HomeEvent> ongoing;
  final List<HomeEvent> expired;

  EventsData({
    required this.upcoming,
    required this.ongoing,
    required this.expired,
  });

  factory EventsData.fromJson(Map<String, dynamic> json) {
    return EventsData(
      upcoming:
          (json['upcoming'] as List<dynamic>?)
              ?.map((e) => HomeEvent.fromJson(e))
              .toList() ??
          [],
      ongoing:
          (json['ongoing'] as List<dynamic>?)
              ?.map((e) => HomeEvent.fromJson(e))
              .toList() ??
          [],
      expired:
          (json['expired'] as List<dynamic>?)
              ?.map((e) => HomeEvent.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class HomeEvent {
  final int id;
  final String formattedStartAt;
  final String imageUrl;
  final List<String> attendeesImages;
  final String cityName;
  final String venue;
  final bool isFavorite;
  final String favoritableType;

  HomeEvent({
    required this.id,
    required this.formattedStartAt,
    required this.imageUrl,
    required this.attendeesImages,
    required this.cityName,
    required this.venue,
    required this.isFavorite,
    required this.favoritableType,
  });

  factory HomeEvent.fromJson(Map<String, dynamic> json) {
    return HomeEvent(
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
