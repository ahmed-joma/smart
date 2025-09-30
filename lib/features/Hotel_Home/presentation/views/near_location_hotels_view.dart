import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'widgets/near_location_hotels_body.dart';
import '../manager/hotel_home_cubit.dart';
import '../../data/repos/Hotel_Home_repo_imple.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/utils/cubits/favorite_cubit.dart';

class NearLocationHotelsView extends StatelessWidget {
  const NearLocationHotelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              HotelHomeCubit(HotelHomeRepoImpl(sl()))..getHotelData(),
        ),
        BlocProvider.value(value: sl<FavoriteCubit>()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Simple Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go('/hotelHomeView');
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Hotels Near You',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              // Body
              const Expanded(child: NearLocationHotelsBody()),
            ],
          ),
        ),
      ),
    );
  }
}
