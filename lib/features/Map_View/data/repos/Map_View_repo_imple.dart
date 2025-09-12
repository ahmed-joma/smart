import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/entities/map_location.dart';
import 'Map_View_repo.dart';

class MapViewRepositoryImpl implements MapViewRepository {
  @override
  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Placemark>> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      return placemarks;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Location>> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      return locations;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> requestLocationPermission() async {
    try {
      PermissionStatus status = await Permission.location.request();
      return status == PermissionStatus.granted;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<MapLocation>> getNearbyPlaces(
    double latitude,
    double longitude,
    String category,
  ) async {
    try {
      // This would typically call a Places API
      // For now, return some mock data
      List<MapLocation> nearbyPlaces = [
        MapLocation(
          latitude: latitude + 0.001,
          longitude: longitude + 0.001,
          name: 'Nearby Restaurant',
          description: 'Great food here!',
          category: category,
        ),
        MapLocation(
          latitude: latitude - 0.001,
          longitude: longitude + 0.002,
          name: 'Shopping Mall',
          description: 'Big shopping center',
          category: category,
        ),
        MapLocation(
          latitude: latitude + 0.002,
          longitude: longitude - 0.001,
          name: 'Park',
          description: 'Beautiful park for walking',
          category: category,
        ),
      ];
      return nearbyPlaces;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<MapLocation>> searchPlaces(
    String query,
    double latitude,
    double longitude,
  ) async {
    try {
      // This would typically call a search API
      // For now, return some mock data
      List<MapLocation> searchResults = [
        MapLocation(
          latitude: latitude + 0.005,
          longitude: longitude + 0.005,
          name: 'Search Result 1',
          description: 'Found: $query',
          category: 'search',
        ),
        MapLocation(
          latitude: latitude - 0.005,
          longitude: longitude - 0.005,
          name: 'Search Result 2',
          description: 'Found: $query',
          category: 'search',
        ),
      ];
      return searchResults;
    } catch (e) {
      return [];
    }
  }
}
