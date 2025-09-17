import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/home_body.dart';
import 'package:smartshop_map/features/Profile/presentation/manager/profile_cubit.dart';
import '../manager/Home/home_cubit.dart';
import '../../data/repos/Home_repo_imple.dart';
import '../../../../core/utils/service_locator.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileCubit()..getProfile()),
        BlocProvider(create: (context) => HomeCubit(HomeRepoImpl(sl()))),
      ],
      child: const HomeBody(),
    );
  }
}
