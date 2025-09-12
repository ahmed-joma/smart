part of 'map_view_cubit.dart';

sealed class MapViewState extends Equatable {
  const MapViewState();

  @override
  List<Object?> get props => [];
}

final class MapViewInitial extends MapViewState {}

final class MapViewLoading extends MapViewState {}

final class MapViewLoaded extends MapViewState {
  final double latitude;
  final double longitude;
  final double zoom;
  final List<MapLocation> nearbyPlaces;
  final List<MapLocation> searchResults;
  final bool isLocationEnabled;
  final String? currentAddress;

  const MapViewLoaded({
    required this.latitude,
    required this.longitude,
    required this.zoom,
    required this.nearbyPlaces,
    required this.searchResults,
    required this.isLocationEnabled,
    this.currentAddress,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    zoom,
    nearbyPlaces,
    searchResults,
    isLocationEnabled,
    currentAddress,
  ];
}

final class MapViewError extends MapViewState {
  final String message;

  const MapViewError({required this.message});

  @override
  List<Object> get props => [message];
}
