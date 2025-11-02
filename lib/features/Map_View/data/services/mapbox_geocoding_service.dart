import 'package:dio/dio.dart';

class MapboxGeocodingService {
  final String accessToken =
      'pk.eyJ1IjoiZWxhZjYwIiwiYSI6ImNtaDR5YWtmbDAxd3AyanNhbGZmZzQ5cm8ifQ.8B8nfcbAa3pM7d68L6ZIMg';
  final Dio _dio = Dio();

  /// Enhanced search for places using Mapbox Geocoding API with focus on Saudi Arabia
  Future<List<MapboxPlace>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    try {
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json';

      final response = await _dio.get(
        url,
        queryParameters: {
          'access_token': accessToken,
          'limit': 20, // زيادة عدد النتائج للسعودية
          'language': 'ar,en', // العربية أولاً
          'types':
              'country,region,postcode,district,place,locality,neighborhood,address,poi', // أنواع أكثر
          'autocomplete': true, // تفعيل الإكمال التلقائي
          'fuzzyMatch': true, // البحث الضبابي
          'country': 'SA', // تركيز على السعودية
          'proximity': '46.6753,24.7136', // مركز السعودية (الرياض)
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> features = response.data['features'];
        List<MapboxPlace> results = features
            .map((json) => MapboxPlace.fromJson(json))
            .toList();

        // ترتيب النتائج: السعودية أولاً، ثم باقي العالم
        results.sort((a, b) {
          final aIsSaudi =
              a.placeName.contains('Saudi Arabia') ||
              a.placeName.contains('السعودية') ||
              a.placeName.contains('Riyadh') ||
              a.placeName.contains('Jeddah') ||
              a.placeName.contains('Mecca') ||
              a.placeName.contains('Medina') ||
              a.placeName.contains('Dammam') ||
              a.placeName.contains('الرياض') ||
              a.placeName.contains('جدة') ||
              a.placeName.contains('مكة') ||
              a.placeName.contains('المدينة') ||
              a.placeName.contains('الدمام');

          final bIsSaudi =
              b.placeName.contains('Saudi Arabia') ||
              b.placeName.contains('السعودية') ||
              b.placeName.contains('Riyadh') ||
              b.placeName.contains('Jeddah') ||
              b.placeName.contains('Mecca') ||
              b.placeName.contains('Medina') ||
              b.placeName.contains('Dammam') ||
              b.placeName.contains('الرياض') ||
              b.placeName.contains('جدة') ||
              b.placeName.contains('مكة') ||
              b.placeName.contains('المدينة') ||
              b.placeName.contains('الدمام');

          if (aIsSaudi && !bIsSaudi) return -1;
          if (!aIsSaudi && bIsSaudi) return 1;
          return 0;
        });

        return results;
      }

      return [];
    } catch (e) {
      print('❌ Error searching places: $e');
      return [];
    }
  }

  /// Reverse Geocoding: تحويل الإحداثيات إلى عنوان
  Future<MapboxPlace?> reverseGeocode(double longitude, double latitude) async {
    try {
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$longitude,$latitude.json';

      final response = await _dio.get(
        url,
        queryParameters: {
          'access_token': accessToken,
          'language': 'ar,en', // دعم العربية والإنجليزية
          'types':
              'country,region,postcode,district,place,locality,neighborhood,address,poi',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> features = response.data['features'];
        if (features.isNotEmpty) {
          return MapboxPlace.fromJson(features.first);
        }
      }

      return null;
    } catch (e) {
      print('❌ Error in reverse geocoding: $e');
      return null;
    }
  }

  /// Search specifically for Saudi Arabian places
  Future<List<MapboxPlace>> searchSaudiPlaces(String query) async {
    if (query.isEmpty) return [];

    try {
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json';

      final response = await _dio.get(
        url,
        queryParameters: {
          'access_token': accessToken,
          'limit': 15,
          'language': 'ar,en',
          'types': 'place,locality,neighborhood,address,poi',
          'autocomplete': true,
          'fuzzyMatch': true,
          'country': 'SA', // السعودية فقط
          'proximity': '46.6753,24.7136', // مركز السعودية
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> features = response.data['features'];
        return features.map((json) => MapboxPlace.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('❌ Error searching Saudi places: $e');
      return [];
    }
  }

  /// Search for Saudi cities specifically
  Future<List<MapboxPlace>> searchSaudiCities(String query) async {
    if (query.isEmpty) return [];

    try {
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json';

      final response = await _dio.get(
        url,
        queryParameters: {
          'access_token': accessToken,
          'limit': 12,
          'language': 'ar,en',
          'types': 'place',
          'autocomplete': true,
          'country': 'SA',
          'proximity': '46.6753,24.7136',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> features = response.data['features'];
        return features.map((json) => MapboxPlace.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('❌ Error searching Saudi cities: $e');
      return [];
    }
  }

  /// Search for Saudi landmarks and POIs
  Future<List<MapboxPlace>> searchSaudiLandmarks(String query) async {
    if (query.isEmpty) return [];

    try {
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json';

      final response = await _dio.get(
        url,
        queryParameters: {
          'access_token': accessToken,
          'limit': 10,
          'language': 'ar,en',
          'types': 'poi',
          'autocomplete': true,
          'country': 'SA',
          'proximity': '46.6753,24.7136',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> features = response.data['features'];
        return features.map((json) => MapboxPlace.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('❌ Error searching Saudi landmarks: $e');
      return [];
    }
  }

  /// Search for specific types of places (cities, countries, landmarks)
  Future<List<MapboxPlace>> searchByType(String query, String type) async {
    if (query.isEmpty) return [];

    try {
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json';

      final response = await _dio.get(
        url,
        queryParameters: {
          'access_token': accessToken,
          'limit': 10,
          'language': 'en,ar',
          'types': type, // نوع محدد
          'autocomplete': true,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> features = response.data['features'];
        return features.map((json) => MapboxPlace.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('❌ Error searching places by type: $e');
      return [];
    }
  }

  /// Search for cities worldwide
  Future<List<MapboxPlace>> searchCities(String query) async {
    return await searchByType(query, 'place');
  }

  /// Search for countries
  Future<List<MapboxPlace>> searchCountries(String query) async {
    return await searchByType(query, 'country');
  }

  /// Search for landmarks and POIs
  Future<List<MapboxPlace>> searchLandmarks(String query) async {
    return await searchByType(query, 'poi');
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
