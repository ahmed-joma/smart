import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../domain/entities/map_location.dart';
import '../../../data/repos/Map_View_repo.dart';

part 'map_view_state.dart';

class MapViewCubit extends Cubit<MapViewState> {
  final MapViewRepository _repository;

  MapViewCubit(this._repository) : super(MapViewInitial());

  // Default location (Cairo, Egypt)
  static const double _defaultLatitude = 30.0444;
  static const double _defaultLongitude = 31.2357;

  Future<void> initializeMap() async {
    emit(MapViewLoading());

    try {
      // Check if location services are enabled
      bool isLocationEnabled = await _repository.isLocationServiceEnabled();

      double latitude = _defaultLatitude;
      double longitude = _defaultLongitude;
      String? currentAddress;

      if (isLocationEnabled) {
        // Try to get current location
        Position? position = await _repository.getCurrentLocation();
        if (position != null) {
          latitude = position.latitude;
          longitude = position.longitude;

          // Get address from coordinates
          var placemarks = await _repository.getAddressFromCoordinates(
            latitude,
            longitude,
          );
          if (placemarks.isNotEmpty) {
            var placemark = placemarks.first;
            currentAddress =
                '${placemark.street}, ${placemark.locality}, ${placemark.country}';
          }
        }
      }

      // Get nearby places
      List<MapLocation> nearbyPlaces = await _repository.getNearbyPlaces(
        latitude,
        longitude,
        'restaurant',
      );

      emit(
        MapViewLoaded(
          latitude: latitude,
          longitude: longitude,
          zoom: AppConstants.defaultZoom,
          nearbyPlaces: nearbyPlaces,
          searchResults: [],
          isLocationEnabled: isLocationEnabled,
          currentAddress: currentAddress,
        ),
      );
    } catch (e) {
      emit(MapViewError(message: 'Failed to initialize map: ${e.toString()}'));
    }
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    final currentState = state;
    if (currentState is MapViewLoaded) {
      try {
        // Get address from new coordinates
        String? currentAddress;
        var placemarks = await _repository.getAddressFromCoordinates(
          latitude,
          longitude,
        );
        if (placemarks.isNotEmpty) {
          var placemark = placemarks.first;
          currentAddress =
              '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        }

        // Get nearby places for new location
        List<MapLocation> nearbyPlaces = await _repository.getNearbyPlaces(
          latitude,
          longitude,
          'restaurant',
        );

        emit(
          MapViewLoaded(
            latitude: latitude,
            longitude: longitude,
            zoom: currentState.zoom,
            nearbyPlaces: nearbyPlaces,
            searchResults: currentState.searchResults,
            isLocationEnabled: currentState.isLocationEnabled,
            currentAddress: currentAddress,
          ),
        );
      } catch (e) {
        emit(
          MapViewError(message: 'Failed to update location: ${e.toString()}'),
        );
      }
    }
  }

  Future<void> searchPlaces(String query) async {
    final currentState = state;
    if (currentState is MapViewLoaded) {
      try {
        List<MapLocation> searchResults = await _repository.searchPlaces(
          query,
          currentState.latitude,
          currentState.longitude,
        );

        emit(
          MapViewLoaded(
            latitude: currentState.latitude,
            longitude: currentState.longitude,
            zoom: currentState.zoom,
            nearbyPlaces: currentState.nearbyPlaces,
            searchResults: searchResults,
            isLocationEnabled: currentState.isLocationEnabled,
            currentAddress: currentState.currentAddress,
          ),
        );
      } catch (e) {
        emit(MapViewError(message: 'Failed to search places: ${e.toString()}'));
      }
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position? position = await _repository.getCurrentLocation();
      if (position != null) {
        await updateLocation(position.latitude, position.longitude);
      } else {
        emit(MapViewError(message: 'Unable to get current location'));
      }
    } catch (e) {
      emit(
        MapViewError(
          message: 'Failed to get current location: ${e.toString()}',
        ),
      );
    }
  }

  void clearSearchResults() {
    final currentState = state;
    if (currentState is MapViewLoaded) {
      emit(
        MapViewLoaded(
          latitude: currentState.latitude,
          longitude: currentState.longitude,
          zoom: currentState.zoom,
          nearbyPlaces: currentState.nearbyPlaces,
          searchResults: [],
          isLocationEnabled: currentState.isLocationEnabled,
          currentAddress: currentState.currentAddress,
        ),
      );
    }
  }
}
