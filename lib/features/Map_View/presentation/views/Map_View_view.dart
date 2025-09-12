import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../shared/themes/app_colors.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../manager/Map_View/map_view_cubit.dart';
import '../../data/repos/Map_View_repo_imple.dart';
import 'widgets/map_search_bar.dart';
import 'widgets/map_controls.dart';
import 'widgets/location_marker.dart';
import 'widgets/nearby_places_list.dart';

class MapViewView extends StatelessWidget {
  const MapViewView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MapViewCubit(MapViewRepositoryImpl())..initializeMap(),
      child: const MapViewBody(),
    );
  }
}

class MapViewBody extends StatefulWidget {
  const MapViewBody({super.key});

  @override
  State<MapViewBody> createState() => _MapViewBodyState();
}

class _MapViewBodyState extends State<MapViewBody> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  bool _showNearbyPlaces = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapViewCubit, MapViewState>(
        listener: (context, state) {
          if (state is MapViewError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MapViewLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is MapViewError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'خطأ في تحميل الخريطة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'إعادة المحاولة',
                    onPressed: () {
                      context.read<MapViewCubit>().initializeMap();
                    },
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                    width: 150,
                    height: 48,
                  ),
                ],
              ),
            );
          }

          if (state is MapViewLoaded) {
            return Stack(
              children: [
                // Map
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(state.latitude, state.longitude),
                    initialZoom: state.zoom,
                    minZoom: 3.0,
                    maxZoom: 20.0,
                    onTap: (tapPosition, point) {
                      context.read<MapViewCubit>().updateLocation(
                        point.latitude,
                        point.longitude,
                      );
                    },
                  ),
                  children: [
                    // Tile Layer
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.smartshop_map',
                      maxZoom: 20,
                    ),

                    // Markers Layer
                    MarkerLayer(
                      markers: [
                        // Current location marker
                        Marker(
                          point: LatLng(state.latitude, state.longitude),
                          width: 40,
                          height: 40,
                          child: const LocationMarker(isCurrentLocation: true),
                        ),

                        // Nearby places markers
                        ...state.nearbyPlaces.map(
                          (place) => Marker(
                            point: LatLng(place.latitude, place.longitude),
                            width: 30,
                            height: 30,
                            child: LocationMarker(
                              isCurrentLocation: false,
                              category: place.category,
                            ),
                          ),
                        ),

                        // Search results markers
                        ...state.searchResults.map(
                          (place) => Marker(
                            point: LatLng(place.latitude, place.longitude),
                            width: 35,
                            height: 35,
                            child: LocationMarker(
                              isCurrentLocation: false,
                              category: 'search',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Top Controls
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      // Search Bar
                      MapSearchBar(
                        controller: _searchController,
                        onSearch: (query) {
                          if (query.isNotEmpty) {
                            context.read<MapViewCubit>().searchPlaces(query);
                          } else {
                            context.read<MapViewCubit>().clearSearchResults();
                          }
                        },
                      ),

                      const SizedBox(height: 12),

                      // Map Controls
                      MapControls(
                        onLocationPressed: () {
                          context.read<MapViewCubit>().getCurrentLocation();
                        },
                        onNearbyPressed: () {
                          setState(() {
                            _showNearbyPlaces = !_showNearbyPlaces;
                          });
                        },
                        showNearbyPlaces: _showNearbyPlaces,
                      ),
                    ],
                  ),
                ),

                // Current Address Display
                if (state.currentAddress != null)
                  Positioned(
                    bottom: _showNearbyPlaces ? 300 : 100,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.currentAddress!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Nearby Places List
                if (_showNearbyPlaces && state.nearbyPlaces.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: NearbyPlacesList(
                      places: state.nearbyPlaces,
                      onPlaceSelected: (place) {
                        if (place != null) {
                          _mapController.move(
                            LatLng(place.latitude, place.longitude),
                            16.0,
                          );
                          context.read<MapViewCubit>().updateLocation(
                            place.latitude,
                            place.longitude,
                          );
                        }
                      },
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
