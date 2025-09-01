class SavedEventModel {
  final String id;
  final String title;
  final String date;
  final String location;
  final String image;
  final String price;
  final String category;
  final DateTime savedAt;

  SavedEventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.image,
    required this.price,
    required this.category,
    required this.savedAt,
  });

  factory SavedEventModel.fromJson(Map<String, dynamic> json) {
    return SavedEventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? '',
      category: json['category'] ?? '',
      savedAt: DateTime.parse(
        json['saved_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'location': location,
      'image': image,
      'price': price,
      'category': category,
      'saved_at': savedAt.toIso8601String(),
    };
  }

  SavedEventModel copyWith({
    String? id,
    String? title,
    String? date,
    String? location,
    String? image,
    String? price,
    String? category,
    DateTime? savedAt,
  }) {
    return SavedEventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      location: location ?? this.location,
      image: image ?? this.image,
      price: price ?? this.price,
      category: category ?? this.category,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}

class SavedHotelModel {
  final String id;
  final String name;
  final String location;
  final String image;
  final String price;
  final double rating;
  final List<String> amenities;
  final DateTime savedAt;

  SavedHotelModel({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.price,
    required this.rating,
    required this.amenities,
    required this.savedAt,
  });

  factory SavedHotelModel.fromJson(Map<String, dynamic> json) {
    return SavedHotelModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      amenities: List<String>.from(json['amenities'] ?? []),
      savedAt: DateTime.parse(
        json['saved_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'image': image,
      'price': price,
      'rating': rating,
      'amenities': amenities,
      'saved_at': savedAt.toIso8601String(),
    };
  }

  SavedHotelModel copyWith({
    String? id,
    String? name,
    String? location,
    String? image,
    String? price,
    double? rating,
    List<String>? amenities,
    DateTime? savedAt,
  }) {
    return SavedHotelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      image: image ?? this.image,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      amenities: amenities ?? this.amenities,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}
