import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/my_profile_body.dart';
import '../manager/saved_items_cubit.dart';
import '../../data/repos/saved_items_repository.dart';
import '../../../Profile/presentation/manager/profile_cubit.dart';
import '../../../../core/utils/cubits/favorite_cubit.dart';
import '../../../../core/utils/repositories/favorite_repository.dart';
import '../../../../core/utils/service_locator.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SavedItemsCubit(SavedItemsRepositoryImpl()),
        ),
        BlocProvider(create: (context) => ProfileCubit()..getProfile()),
        BlocProvider(
          create: (context) => FavoriteCubit(sl<FavoriteRepository>()),
        ),
      ],
      child: const MyProfileBody(),
    );
  }
}
