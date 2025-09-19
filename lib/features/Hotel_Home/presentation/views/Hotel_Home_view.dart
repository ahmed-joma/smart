import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/hotel_body.dart';
import '../manager/hotel_home_cubit.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/utils/cubits/favorite_cubit.dart';
import '../../../../core/utils/repositories/favorite_repository.dart';

class HotelHomeView extends StatelessWidget {
  const HotelHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HotelHomeCubit(sl())),
        BlocProvider(
          create: (context) => FavoriteCubit(sl<FavoriteRepository>()),
        ),
      ],
      child: const HotelBody(),
    );
  }
}
