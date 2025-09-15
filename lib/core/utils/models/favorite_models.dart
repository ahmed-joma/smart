class FavoriteRequest {
  final String favoritableType; // 'App\\Models\\Event' or 'App\\Models\\Hotel'
  final int favoritableId;

  FavoriteRequest({required this.favoritableType, required this.favoritableId});

  Map<String, dynamic> toJson() {
    return {
      'favoritable_type': favoritableType,
      'favoritable_id': favoritableId,
    };
  }
}

class FavoriteResponse {
  final bool isFavorite;
  final String message;

  FavoriteResponse({required this.isFavorite, required this.message});

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteResponse(
      isFavorite: json['is_favorite'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'is_favorite': isFavorite, 'message': message};
  }
}
