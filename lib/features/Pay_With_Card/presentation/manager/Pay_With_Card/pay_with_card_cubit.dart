import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pay_with_card_state.dart';

class PayWithCardCubit extends Cubit<PayWithCardState> {
  PayWithCardCubit() : super(PayWithCardInitial());
}
