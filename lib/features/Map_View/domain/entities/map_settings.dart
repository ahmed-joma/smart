import 'package:equatable/equatable.dart';

enum MapType { normal, satellite, hybrid, terrain }

enum MapStyle { light, dark, custom }

class MapSettings extends Equatable {
  final double zoom;
  final double minZoom;
  final double maxZoom;
  final MapType mapType;
  final MapStyle mapStyle;
  final bool showTraffic;
  final bool showBuildings;
  final bool showCompass;
  final bool showZoomControls;
  final bool showLocationButton;
  final bool showMyLocation;
  final bool enableRotation;
  final bool enableTilt;
  final bool enableScroll;
  final bool enableZoom;

  const MapSettings({
    this.zoom = 15.0,
    this.minZoom = 3.0,
    this.maxZoom = 20.0,
    this.mapType = MapType.normal,
    this.mapStyle = MapStyle.light,
    this.showTraffic = false,
    this.showBuildings = true,
    this.showCompass = true,
    this.showZoomControls = true,
    this.showLocationButton = true,
    this.showMyLocation = true,
    this.enableRotation = true,
    this.enableTilt = true,
    this.enableScroll = true,
    this.enableZoom = true,
  });

  @override
  List<Object> get props => [
    zoom,
    minZoom,
    maxZoom,
    mapType,
    mapStyle,
    showTraffic,
    showBuildings,
    showCompass,
    showZoomControls,
    showLocationButton,
    showMyLocation,
    enableRotation,
    enableTilt,
    enableScroll,
    enableZoom,
  ];

  MapSettings copyWith({
    double? zoom,
    double? minZoom,
    double? maxZoom,
    MapType? mapType,
    MapStyle? mapStyle,
    bool? showTraffic,
    bool? showBuildings,
    bool? showCompass,
    bool? showZoomControls,
    bool? showLocationButton,
    bool? showMyLocation,
    bool? enableRotation,
    bool? enableTilt,
    bool? enableScroll,
    bool? enableZoom,
  }) {
    return MapSettings(
      zoom: zoom ?? this.zoom,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      mapType: mapType ?? this.mapType,
      mapStyle: mapStyle ?? this.mapStyle,
      showTraffic: showTraffic ?? this.showTraffic,
      showBuildings: showBuildings ?? this.showBuildings,
      showCompass: showCompass ?? this.showCompass,
      showZoomControls: showZoomControls ?? this.showZoomControls,
      showLocationButton: showLocationButton ?? this.showLocationButton,
      showMyLocation: showMyLocation ?? this.showMyLocation,
      enableRotation: enableRotation ?? this.enableRotation,
      enableTilt: enableTilt ?? this.enableTilt,
      enableScroll: enableScroll ?? this.enableScroll,
      enableZoom: enableZoom ?? this.enableZoom,
    );
  }
}
