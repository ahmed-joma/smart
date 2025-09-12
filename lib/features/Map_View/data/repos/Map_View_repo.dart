import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../domain/entities/map_location.dart';

abstract class MapViewRepository {
  Future<Position?> getCurrentLocation();
  Future<List<Placemark>> getAddressFromCoordinates(
    double latitude,
    double longitude,
  );
  Future<List<Location>> getCoordinatesFromAddress(String address);
  Future<bool> requestLocationPermission();
  Future<bool> isLocationServiceEnabled();
  Future<List<MapLocation>> getNearbyPlaces(
    double latitude,
    double longitude,
    String category,
  );
  Future<List<MapLocation>> searchPlaces(
    String query,
    double latitude,
    double longitude,
  );
}
