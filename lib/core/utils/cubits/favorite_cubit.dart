import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/favorite_repository.dart';
import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository _favoriteRepository;

  FavoriteCubit(this._favoriteRepository) : super(FavoriteInitial());

  /// Toggle favorite status for any item (Hotel or Event)
  Future<void> toggleFavorite({
    required String
    favoriteType, // "App\\Models\\Hotel" or "App\\Models\\Event"
    required int favoriteId,
  }) async {
    try {
      emit(FavoriteLoading(favoriteId: favoriteId, favoriteType: favoriteType));

      print(
        '🔄 FavoriteCubit: Toggling favorite for $favoriteType ID: $favoriteId',
      );

      final response = await _favoriteRepository.toggleFavorite(
        favoriteType: favoriteType,
        favoriteId: favoriteId,
      );

      if (response.status && response.data != null) {
        final isFavorite = response.data!['is_favorite'] as bool;
        final message = response.msg.isNotEmpty
            ? response.msg
            : (isFavorite ? 'Added to favorites' : 'Removed from favorites');

        print(
          '✅ FavoriteCubit: Favorite toggled successfully. Is favorite: $isFavorite',
        );

        emit(
          FavoriteSuccess(
            favoriteId: favoriteId,
            favoriteType: favoriteType,
            isFavorite: isFavorite,
            message: message,
          ),
        );
      } else {
        print('❌ FavoriteCubit: API returned failure status');
        emit(
          FavoriteError(
            favoriteId: favoriteId,
            favoriteType: favoriteType,
            message: response.msg.isNotEmpty
                ? response.msg
                : 'Failed to update favorite',
          ),
        );
      }
    } catch (e) {
      print('❌ FavoriteCubit: Error toggling favorite: $e');
      emit(
        FavoriteError(
          favoriteId: favoriteId,
          favoriteType: favoriteType,
          message: 'Failed to update favorite: ${e.toString()}',
        ),
      );
    }
  }

  /// Helper method to toggle hotel favorite
  Future<void> toggleHotelFavorite(int hotelId) async {
    await toggleFavorite(
      favoriteType: 'App\\Models\\Hotel',
      favoriteId: hotelId,
    );
  }

  /// Helper method to toggle event favorite
  Future<void> toggleEventFavorite(int eventId) async {
    await toggleFavorite(
      favoriteType: 'App\\Models\\Event',
      favoriteId: eventId,
    );
  }

  /// Reset state to initial
  void resetState() {
    emit(FavoriteInitial());
  }
}
