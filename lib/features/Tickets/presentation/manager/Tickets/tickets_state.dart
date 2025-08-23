part of 'tickets_cubit.dart';

sealed class TicketsState extends Equatable {
  const TicketsState();

  @override
  List<Object> get props => [];
}

final class TicketsInitial extends TicketsState {}
