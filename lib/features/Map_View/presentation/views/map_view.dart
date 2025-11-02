import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:go_router/go_router.dart';
import 'widgets/map_search_bar.dart';
import 'widgets/map_filter_button.dart';
import 'widgets/map_location_button.dart';
import 'widgets/map_style_button.dart';
import 'widgets/map_3d_toggle_button.dart';
import '../../data/services/mapbox_geocoding_service.dart';

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
  final MapboxGeocodingService _geocodingService = MapboxGeocodingService();
  CircleAnnotationManager? _userCircleManager;

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

  /// تقريب الخريطة (Zoom In)
  void _zoomIn() async {
    if (_mapboxMap != null) {
      final currentZoom = await _mapboxMap!.getCameraState();
      final newZoom = (currentZoom.zoom + 1).clamp(0.0, 22.0);

      await _mapboxMap!.easeTo(
        CameraOptions(zoom: newZoom),
        MapAnimationOptions(duration: 300),
      );
      print('🔍 Zoomed in to level: $newZoom');
    }
  }

  /// تصغير الخريطة (Zoom Out)
  void _zoomOut() async {
    if (_mapboxMap != null) {
      final currentZoom = await _mapboxMap!.getCameraState();
      final newZoom = (currentZoom.zoom - 1).clamp(0.0, 22.0);

      await _mapboxMap!.easeTo(
        CameraOptions(zoom: newZoom),
        MapAnimationOptions(duration: 300),
      );
      print('🔍 Zoomed out to level: $newZoom');
    }
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

  /// معالجة الضغط على الخريطة
  Future<void> _handleMapTap(MapContentGestureContext context) async {
    print('🗺️ Map tapped at: ${context.point}');

    if (_mapboxMap == null) return;

    try {
      // الحصول على الإحداثيات مباشرة من context.point
      final point = context.point;
      final lat = point.coordinates.lat.toDouble();
      final lng = point.coordinates.lng.toDouble();

      print('📍 Tapped coordinates: $lat, $lng');

      // إضافة marker في المكان المضغوط
      await _addUserMarker(lng, lat);

      // الحصول على معلومات المكان من Reverse Geocoding
      final placeInfo = await _geocodingService.reverseGeocode(lng, lat);

      // عرض معلومات المكان
      if (placeInfo != null) {
        _showLocationInfo(placeInfo);
      } else {
        // عرض الإحداثيات فقط إذا لم نحصل على معلومات
        _showCoordinatesInfo(lat, lng);
      }
    } catch (e) {
      print('❌ Error handling map tap: $e');
    }
  }

  /// إضافة marker (دبوس) في المكان الذي ضغط عليه المستخدم
  Future<void> _addUserMarker(double lng, double lat) async {
    try {
      // حذف الدائرة السابقة إذا كانت موجودة
      if (_userCircleManager != null) {
        await _userCircleManager!.deleteAll();
      } else {
        _userCircleManager = await _mapboxMap?.annotations
            .createCircleAnnotationManager();
      }

      // إضافة دائرة مرئية واضحة (الدبوس)
      final circleOptions = CircleAnnotationOptions(
        geometry: Point(
          coordinates: Position.named(lng: lng, lat: lat),
        ),
        circleRadius: 12.0, // حجم الدائرة
        circleColor: 0xFF7F2F3A, // لون أحمر مميز
        circleStrokeWidth: 3.0, // سمك الحد الخارجي
        circleStrokeColor: 0xFFFFFFFF, // حد أبيض للتباين
        circleOpacity: 1.0, // شفافية كاملة
      );

      await _userCircleManager?.create(circleOptions);
      print('✅ User marker (دبوس) added at: $lat, $lng');

      // إضافة دائرة خارجية شبه شفافة للتأثير البصري
      final outerCircleOptions = CircleAnnotationOptions(
        geometry: Point(
          coordinates: Position.named(lng: lng, lat: lat),
        ),
        circleRadius: 20.0, // أكبر قليلاً
        circleColor: 0xFF7F2F3A, // نفس اللون
        circleOpacity: 0.3, // شبه شفافة
      );

      await _userCircleManager?.create(outerCircleOptions);

      // تحريك الكاميرا قليلاً للتأكد من رؤية الدبوس
      await _mapboxMap?.easeTo(
        CameraOptions(
          center: Point(
            coordinates: Position.named(lng: lng, lat: lat),
          ),
          zoom: 15.0, // تكبير خفيف
        ),
        MapAnimationOptions(duration: 500),
      );
    } catch (e) {
      print('❌ Error adding user marker: $e');
    }
  }

  /// عرض معلومات المكان مع العنوان
  void _showLocationInfo(MapboxPlace place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Icon & Title
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF7F2F3A),
                          const Color(0xFF7F2F3A).withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7F2F3A).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.text ?? 'موقع محدد',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.my_location,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _getPlaceType(place),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Description (إذا كان موجوداً)
              if (place.description != null && place.description!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF7F2F3A).withOpacity(0.05),
                        const Color(0xFF7F2F3A).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF7F2F3A).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: const Color(0xFF7F2F3A),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'About this place',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        place.description!,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

              if (place.description != null && place.description!.isNotEmpty)
                const SizedBox(height: 16),

              // Full Address
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey.shade50, Colors.grey.shade100],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_city,
                          color: const Color(0xFF7F2F3A),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'العنوان الكامل',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      place.placeName,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Coordinates
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF7F2F3A).withOpacity(0.05),
                      const Color(0xFF7F2F3A).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF7F2F3A).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.gps_fixed,
                          color: const Color(0xFF7F2F3A),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'الإحداثيات',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCoordinateItem(
                            'خط العرض',
                            place.latitude.toStringAsFixed(6),
                            Icons.north,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCoordinateItem(
                            'خط الطول',
                            place.longitude.toStringAsFixed(6),
                            Icons.east,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// عرض الإحداثيات فقط (عند عدم توفر معلومات)
  void _showCoordinatesInfo(double lat, double lng) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),

            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7F2F3A),
                    const Color(0xFF7F2F3A).withOpacity(0.7),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7F2F3A).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.push_pin, color: Colors.white, size: 40),
            ),

            const SizedBox(height: 24),

            const Text(
              'موقع محدد',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 24),

            // Coordinates
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7F2F3A).withOpacity(0.05),
                    const Color(0xFF7F2F3A).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildCoordinateRow(
                    'خط العرض (Latitude)',
                    lat.toStringAsFixed(6),
                  ),
                  const Divider(height: 24),
                  _buildCoordinateRow(
                    'خط الطول (Longitude)',
                    lng.toStringAsFixed(6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F2F3A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'إغلاق',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinateItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF7F2F3A), size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinateRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7F2F3A),
          ),
        ),
      ],
    );
  }

  String _getPlaceType(MapboxPlace place) {
    // استخراج نوع المكان من context
    if (place.placeName.contains('Street') ||
        place.placeName.contains('شارع')) {
      return 'شارع';
    } else if (place.placeName.contains('District') ||
        place.placeName.contains('حي')) {
      return 'حي';
    } else if (place.placeName.contains('City') ||
        place.placeName.contains('مدينة')) {
      return 'مدينة';
    } else if (place.placeName.contains('Region') ||
        place.placeName.contains('منطقة')) {
      return 'منطقة';
    }
    return 'موقع';
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
      onTapListener: _handleMapTap,
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

          // Zoom Controls (أزرار التقريب والتصغير)
          Positioned(
            bottom: 180,
            right: 16,
            child: Column(
              children: [
                // Zoom In Button (تقريب)
                Container(
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
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _zoomIn,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add,
                          color: Color(0xFF7F2F3A),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Zoom Out Button (تصغير)
                Container(
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
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _zoomOut,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.remove,
                          color: Color(0xFF7F2F3A),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
