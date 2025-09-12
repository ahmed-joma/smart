import 'package:equatable/equatable.dart';

class MapLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String? address;
  final String? name;
  final String? description;
  final String? category;
  final String? iconUrl;

  const MapLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.name,
    this.description,
    this.category,
    this.iconUrl,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    address,
    name,
    description,
    category,
    iconUrl,
  ];

  MapLocation copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? name,
    String? description,
    String? category,
    String? iconUrl,
  }) {
    return MapLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }
}
