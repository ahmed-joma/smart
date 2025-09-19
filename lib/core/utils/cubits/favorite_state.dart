abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {
  final int favoriteId;
  final String favoriteType;

  FavoriteLoading({required this.favoriteId, required this.favoriteType});
}

class FavoriteSuccess extends FavoriteState {
  final int favoriteId;
  final String favoriteType;
  final bool isFavorite;
  final String message;

  FavoriteSuccess({
    required this.favoriteId,
    required this.favoriteType,
    required this.isFavorite,
    required this.message,
  });
}

class FavoriteError extends FavoriteState {
  final int favoriteId;
  final String favoriteType;
  final String message;

  FavoriteError({
    required this.favoriteId,
    required this.favoriteType,
    required this.message,
  });
}
