import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/Hotel_Details_body.dart';
import '../manager/hotel_cubit.dart';
import '../manager/hotel_details_cubit.dart';
import '../../data/repos/hotel_repository.dart' as hotel_repo;
import '../../../../core/utils/service_locator.dart';

class HotelDetailsView extends StatelessWidget {
  final Map<String, dynamic>? hotelData;

  const HotelDetailsView({super.key, this.hotelData});

  @override
  Widget build(BuildContext context) {
    // Extract hotel ID from navigation arguments
    int? hotelId;
    if (hotelData != null) {
      if (hotelData!['id'] is int) {
        hotelId = hotelData!['id'] as int;
      } else if (hotelData!['id'] is String) {
        hotelId = int.tryParse(hotelData!['id']);
      }
    }

    print('🏨 HotelDetailsView: Received hotelId: $hotelId');

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HotelCubit(hotel_repo.HotelRepositoryImpl()),
        ),
        BlocProvider(
          create: (context) =>
              HotelDetailsCubit(sl<hotel_repo.HotelRepository>()),
        ),
      ],
      child: Scaffold(
        body: HotelDetailsBody(hotelData: hotelData, hotelId: hotelId),
      ),
    );
  }
}
