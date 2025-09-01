import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/Hotel_Details_body.dart';
import '../manager/hotel_cubit.dart';
import '../../data/repos/hotel_repository.dart';

class HotelDetailsView extends StatelessWidget {
  final Map<String, dynamic>? hotelData;

  const HotelDetailsView({super.key, this.hotelData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HotelCubit(HotelRepositoryImpl()),
      child: Scaffold(body: HotelDetailsBody(hotelData: hotelData)),
    );
  }
}
