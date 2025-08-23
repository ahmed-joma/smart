part of 'empty_events_cubit.dart';

sealed class EmptyEventsState extends Equatable {
  const EmptyEventsState();

  @override
  List<Object> get props => [];
}

final class EmptyEventsInitial extends EmptyEventsState {}
