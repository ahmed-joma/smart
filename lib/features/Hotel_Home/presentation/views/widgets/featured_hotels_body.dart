import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../shared/themes/app_colors.dart';
import '../../../../../shared/widgets/interactive_bookmark.dart';
import '../../../data/models/hotel_models.dart';
import '../../../../../core/utils/cubits/favorite_cubit.dart';
import '../../../../../core/utils/cubits/favorite_state.dart';
import '../../manager/hotel_home_cubit.dart';
// hotel_home_state is part of hotel_home_cubit.dart

class FeaturedHotelsBody extends StatefulWidget {
  const FeaturedHotelsBody({super.key});

  @override
  State<FeaturedHotelsBody> createState() => _FeaturedHotelsBodyState();
}

class _FeaturedHotelsBodyState extends State<FeaturedHotelsBody> {
  final Map<int, bool> _savedHotels = {};

  @override
  void initState() {
    super.initState();
    // Initialize saved hotels from HotelHomeCubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hotelHomeState = context.read<HotelHomeCubit>().state;
      if (hotelHomeState is HotelHomeSuccess) {
        for (var hotel in hotelHomeState.hotelData.hotels.popularHotels) {
          _savedHotels[hotel.id] = hotel.isFavorite;
        }
        setState(() {});
      }
    });
  }

  void _toggleFavorite(int hotelId) {
    setState(() {
      _savedHotels[hotelId] = !(_savedHotels[hotelId] ?? false);
    });
    context.read<FavoriteCubit>().toggleHotelFavorite(hotelId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteCubit, FavoriteState>(
      listener: (context, state) {
        if (state is FavoriteSuccess) {
          // Update local state when favorite changes
          setState(() {
            _savedHotels[state.favoriteId] = state.isFavorite;
          });
        }
      },
      child: BlocBuilder<HotelHomeCubit, HotelHomeState>(
        builder: (context, state) {
          if (state is HotelHomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HotelHomeSuccess) {
            final featuredHotels = state.hotelData.hotels.popularHotels;

            if (featuredHotels.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/empty_hotels.svg',
                      height: 120,
                      width: 120,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No featured hotels found.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back later for amazing hotels!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: featuredHotels.length,
              itemBuilder: (context, index) {
                final hotel = featuredHotels[index];
                return _buildHotelCard(hotel);
              },
            );
          }

          if (state is HotelHomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade400,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading hotels:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildHotelCard(Hotel hotel) {
    final isSaved = _savedHotels[hotel.id] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Image
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    const Color(0xFF6B7AED).withOpacity(0.1),
                  ],
                ),
              ),
              child: hotel.coverUrl.isNotEmpty
                  ? Image.network(
                      hotel.coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    )
                  : _buildPlaceholderImage(),
            ),
            // Hotel Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name
                  Text(
                    hotel.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D1E25),
                      fontFamily: 'Inter',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Hotel Location
                  Text(
                    hotel.venue,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                      fontFamily: 'Inter',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Hotel Rating and Price
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber.shade600,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              hotel.rate.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.amber.shade700,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(0 reviews)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Price
                      Text(
                        'SR${hotel.pricePerNight}/night',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D1E25),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Favorite Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: InteractiveBookmark(
                      isSaved: isSaved,
                      onPressed: () => _toggleFavorite(hotel.id),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            const Color(0xFF6B7AED).withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.hotel,
          size: 60,
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
    );
  }
}
