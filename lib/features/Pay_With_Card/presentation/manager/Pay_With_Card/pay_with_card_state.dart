part of 'pay_with_card_cubit.dart';

sealed class PayWithCardState extends Equatable {
  const PayWithCardState();

  @override
  List<Object> get props => [];
}

final class PayWithCardInitial extends PayWithCardState {}
