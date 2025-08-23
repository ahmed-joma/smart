part of 'high_fidelity_cubit.dart';

sealed class HighFidelityState extends Equatable {
  const HighFidelityState();

  @override
  List<Object> get props => [];
}

final class HighFidelityInitial extends HighFidelityState {}
