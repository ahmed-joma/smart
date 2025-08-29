import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../../../../../shared/shared.dart';
import 'widgets/Event_Details_body.dart';
import '../manager/event_cubit.dart';
import '../../data/repos/event_repository.dart';

class EventDetailsView extends StatelessWidget {
  final Map<String, dynamic>? eventData;

  const EventDetailsView({super.key, this.eventData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventCubit(EventRepositoryImpl()),
      child: Scaffold(body: EventDetailsBody(eventData: eventData)),
    );
  }
}
