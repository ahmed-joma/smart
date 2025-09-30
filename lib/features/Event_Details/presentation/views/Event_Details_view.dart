import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/shared.dart';
import 'widgets/Event_Details_body.dart';
import '../manager/event_details_cubit.dart';
import '../../data/repos/event_repository.dart' as event_repo;
import '../../../../../core/utils/service_locator.dart';
import '../../../../core/utils/cubits/favorite_cubit.dart';
import '../../../../core/utils/repositories/favorite_repository.dart';

class EventDetailsView extends StatelessWidget {
  final Map<String, dynamic>? eventData;

  const EventDetailsView({super.key, this.eventData});

  @override
  Widget build(BuildContext context) {
    // Extract eventId from eventData
    int? eventId;
    if (eventData != null) {
      if (eventData!['eventId'] != null) {
        eventId = eventData!['eventId'] as int?;
      } else if (eventData!['id'] != null) {
        eventId = eventData!['id'] as int?;
      }
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EventDetailsCubit(
            sl<event_repo.EventRepository>(),
            sl<FavoriteRepository>(),
          ),
        ),
        BlocProvider.value(value: sl<FavoriteCubit>()),
      ],
      child: Scaffold(
        body: EventDetailsBody(eventData: eventData, eventId: eventId),
      ),
    );
  }
}
