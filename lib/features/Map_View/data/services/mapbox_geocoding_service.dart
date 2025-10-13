import 'package:dio/dio.dart';

class MapboxGeocodingService {
  final String accessToken =
      'pk.eyJ1IjoiZWxhZjYwIiwiYSI6ImNtZ21oOGhwNTE4eWQyaXNnZDBhd2t5MXkifQ.7ckljk2nC8Tdf_l1BvdluA';
  final Dio _dio = Dio();

  /// Search for places using Mapbox Geocoding API
  Future<List<MapboxPlace>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    try {
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json';

      final response = await _dio.get(
        url,
        queryParameters: {
          'access_token': accessToken,
          'limit': 10,
          'language': 'en',
          'types': 'place,locality,neighborhood,address,poi',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> features = response.data['features'];
        return features.map((json) => MapboxPlace.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('❌ Error searching places: $e');
      return [];
    }
  }

  /// Reverse geocoding - Get place name from coordinates
  Future<String?> reverseGeocode(double longitude, double latitude) async {
    try {
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$longitude,$latitude.json';

      final response = await _dio.get(
        url,
        queryParameters: {'access_token': accessToken, 'limit': 1},
      );

      if (response.statusCode == 200) {
        final List<dynamic> features = response.data['features'];
        if (features.isNotEmpty) {
          return features[0]['place_name'];
        }
      }

      return null;
    } catch (e) {
      print('❌ Error reverse geocoding: $e');
      return null;
    }
  }
}

class MapboxPlace {
  final String id;
  final String placeName;
  final String? text;
  final double longitude;
  final double latitude;
  final List<double> bbox;
  final String? placeType;

  MapboxPlace({
    required this.id,
    required this.placeName,
    this.text,
    required this.longitude,
    required this.latitude,
    required this.bbox,
    this.placeType,
  });

  factory MapboxPlace.fromJson(Map<String, dynamic> json) {
    final List<dynamic> coordinates = json['geometry']['coordinates'];
    final List<dynamic>? bboxList = json['bbox'];

    return MapboxPlace(
      id: json['id'] ?? '',
      placeName: json['place_name'] ?? '',
      text: json['text'],
      longitude: coordinates[0].toDouble(),
      latitude: coordinates[1].toDouble(),
      bbox: bboxList != null
          ? bboxList.map((e) => (e as num).toDouble()).toList()
          : [
              coordinates[0].toDouble(),
              coordinates[1].toDouble(),
              coordinates[0].toDouble(),
              coordinates[1].toDouble(),
            ],
      placeType:
          json['place_type'] != null && (json['place_type'] as List).isNotEmpty
          ? json['place_type'][0]
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place_name': placeName,
      'text': text,
      'longitude': longitude,
      'latitude': latitude,
      'bbox': bbox,
      'place_type': placeType,
    };
  }
}
