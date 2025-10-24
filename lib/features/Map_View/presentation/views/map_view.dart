import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:go_router/go_router.dart';
import 'widgets/map_search_bar.dart';
import 'widgets/map_filter_button.dart';
import 'widgets/map_location_button.dart';
import 'widgets/map_style_button.dart';
import 'widgets/map_3d_toggle_button.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  MapboxMap? _mapboxMap;
  geo.Position? _currentPosition;
  bool _is3DEnabled = false;
  String _currentMapStyle = MapboxStyles.OUTDOORS;

  @override
  void initState() {
    super.initState();
    print('🗺️ MapView initState called');
    print('🗺️ Initial map style: $_currentMapStyle');
    print('🗺️ Initial 3D enabled: $_is3DEnabled');
    print('🗺️ MapWidget will be created...');
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        await geo.Geolocator.requestPermission();
      }

      final position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      // Move camera to current location
      if (_mapboxMap != null && mounted) {
        _mapboxMap!.flyTo(
          CameraOptions(
            center: Point(
              coordinates: Position.named(
                lng: _currentPosition!.longitude,
                lat: _currentPosition!.latitude,
              ),
            ),
            zoom: 14.0,
            pitch: 0.0,
            bearing: 0.0,
          ),
          MapAnimationOptions(duration: 2000, startDelay: 0),
        );
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _enable3DBuildings() async {
    try {
      if (_mapboxMap != null) {
        print('🗺️ Starting 3D buildings setup...');

        // Wait for style to be loaded
        await Future.delayed(const Duration(milliseconds: 500));

        // Enable 3D terrain
        await _mapboxMap!.style.setStyleTerrain(
          '{"source": "mapbox-dem", "exaggeration": 1.5}',
        );

        print('✅ 3D Terrain enabled');
        print('✅ 3D Buildings enabled successfully');
      }
    } catch (e) {
      print('❌ Error enabling 3D: $e');
    }
  }

  void _toggle3D() {
    setState(() {
      _is3DEnabled = !_is3DEnabled;
    });

    if (_is3DEnabled) {
      print('🗺️ Enabling 3D mode...');
      _enable3DBuildings();
      _mapboxMap?.flyTo(
        CameraOptions(pitch: 60.0),
        MapAnimationOptions(duration: 1000),
      );
    } else {
      print('🗺️ Disabling 3D mode...');
      _mapboxMap?.flyTo(
        CameraOptions(pitch: 0.0),
        MapAnimationOptions(duration: 1000),
      );
    }
  }

  void _changeMapStyle(String style) {
    setState(() {
      _currentMapStyle = style;
    });

    _mapboxMap?.loadStyleURI(style);
  }

  void _onPlaceSelected(dynamic place) async {
    // Get the place from MapboxPlace
    final double lng = place.longitude;
    final double lat = place.latitude;

    print('📍 Selected place: ${place.placeName}');
    print('📍 Coordinates: $lat, $lng');

    // إضافة تأثير بصري أثناء الانتقال
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Flying to ${place.text ?? place.placeName}...'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF7F2F3A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Fly to the selected location with smooth animation
    await _mapboxMap?.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position.named(lng: lng, lat: lat),
        ),
        zoom: 16.0, // تكبير أكثر للرؤية الواضحة
        pitch: 0.0,
        bearing: 0.0,
      ),
      MapAnimationOptions(
        duration: 2500, // مدة أطول للانتقال السلس
        startDelay: 0,
      ),
    );

    // Add marker at the selected location
    _addSearchMarker(place);

    // إضافة معلومات إضافية عن المكان
    _showPlaceInfo(place);
  }

  void _showPlaceInfo(dynamic place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Place info
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7F2F3A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Color(0xFF7F2F3A),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.text ?? place.placeName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          place.placeName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Coordinates info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Coordinates',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Latitude: ${place.latitude.toStringAsFixed(6)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      'Longitude: ${place.longitude.toStringAsFixed(6)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // يمكن إضافة وظائف إضافية هنا
                      },
                      icon: const Icon(Icons.directions),
                      label: const Text('Get Directions'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7F2F3A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF7F2F3A),
                        side: const BorderSide(color: Color(0xFF7F2F3A)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addSearchMarker(dynamic place) async {
    try {
      final pointAnnotationManager = await _mapboxMap?.annotations
          .createPointAnnotationManager();

      final options = PointAnnotationOptions(
        geometry: Point(
          coordinates: Position.named(
            lng: place.longitude,
            lat: place.latitude,
          ),
        ),
        iconImage: 'search-marker',
        iconSize: 1.5,
        iconAnchor: IconAnchor.BOTTOM,
      );

      pointAnnotationManager?.create(options);
    } catch (e) {
      print('Error adding search marker: $e');
    }
  }

  void _onFilterApplied(List<String> filters) {
    // Implement filter functionality
    print('Applied filters: $filters');
    // TODO: Filter markers based on selected filters
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    print('🗺️ Map created successfully!');
    print('🗺️ Map instance: $mapboxMap');
    print('🗺️ Current style: $_currentMapStyle');
    print('🗺️ 3D enabled: $_is3DEnabled');
    print(
      '🗺️ Current position: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}',
    );
    print('🗺️ MapWidget should be visible now!');
    print('🗺️ Platform View created successfully!');

    _mapboxMap = mapboxMap;

    // Add a test marker to verify map is working
    _addTestMarker();

    // Force a style reload to ensure map is visible
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (_mapboxMap != null) {
        print('🗺️ Forcing style reload...');
        _mapboxMap!.loadStyleURI(_currentMapStyle);
      }
    });
  }

  void _addTestMarker() async {
    try {
      if (_mapboxMap != null) {
        print('🗺️ Adding test marker...');
        final pointAnnotationManager = await _mapboxMap!.annotations
            .createPointAnnotationManager();

        final options = PointAnnotationOptions(
          geometry: Point(
            coordinates: Position.named(
              lng: _currentPosition?.longitude ?? 39.8262,
              lat: _currentPosition?.latitude ?? 21.3891,
            ),
          ),
          iconImage: 'default_marker',
          iconSize: 1.0,
          iconAnchor: IconAnchor.BOTTOM,
        );

        pointAnnotationManager.create(options);
        print('✅ Test marker added successfully');
        print('🗺️ Map should be fully visible now!');
      } else {
        print('❌ MapboxMap is null, cannot add marker');
      }
    } catch (e) {
      print('❌ Error adding test marker: $e');
    }
  }

  Widget _buildMapboxMap() {
    return MapWidget(
      key: const ValueKey('mapWidget'),
      cameraOptions: CameraOptions(
        center: Point(
          coordinates: Position.named(
            lng: _currentPosition?.longitude ?? 39.8262,
            lat: _currentPosition?.latitude ?? 21.3891,
          ),
        ),
        zoom: 14.0,
        pitch: 0.0,
        bearing: 0.0,
      ),
      styleUri: _currentMapStyle,
      onMapCreated: _onMapCreated,
      onTapListener: (MapContentGestureContext context) {
        print('🗺️ Map tapped at: ${context.point}');
      },
      onStyleLoadedListener: (event) {
        print('🗺️ Map style loaded successfully!');
      },
      onMapLoadErrorListener: (event) {
        print('❌ Map load error: $event');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('🗺️ Building MapView widget...');
    print(
      '🗺️ Current position: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}',
    );
    print('🗺️ Map style: $_currentMapStyle');

    return Scaffold(
      body: Stack(
        children: [
          // Map - Full Screen
          Positioned.fill(
            child: Container(
              color: Colors.grey.shade200,
              child: _buildMapboxMap(),
            ),
          ),

          // Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: MapSearchBar(onPlaceSelected: _onPlaceSelected),
          ),

          // Filter Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            right: 16,
            child: MapFilterButton(onFilterApplied: _onFilterApplied),
          ),

          // Map Style Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 140,
            right: 16,
            child: MapStyleButton(
              currentStyle: _currentMapStyle,
              onStyleChanged: _changeMapStyle,
            ),
          ),

          // 3D Toggle Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 200,
            right: 16,
            child: Map3DToggleButton(
              is3DEnabled: _is3DEnabled,
              onToggle: _toggle3D,
            ),
          ),

          // Current Location Button
          Positioned(
            bottom: 100,
            right: 16,
            child: MapLocationButton(onPressed: _getCurrentLocation),
          ),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
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
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF7F2F3A)),
                onPressed: () {
                  print('🔙 Map: Back button pressed');
                  if (context.canPop()) {
                    context.pop();
                    print('✅ Map: Successfully popped');
                  } else {
                    print('❌ Map: Cannot pop, navigating to home');
                    context.go('/homeView');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapboxMap = null;
    super.dispose();
  }
}
