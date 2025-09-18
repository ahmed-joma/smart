import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/hotel_body.dart';
import '../manager/hotel_home_cubit.dart';
import '../../../../core/utils/service_locator.dart';

class HotelHomeView extends StatelessWidget {
  const HotelHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HotelHomeCubit(sl()),
      child: const HotelBody(),
    );
  }
}
