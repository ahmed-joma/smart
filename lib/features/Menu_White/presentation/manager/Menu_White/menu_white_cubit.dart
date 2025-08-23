import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'menu_white_state.dart';

class MenuWhiteCubit extends Cubit<MenuWhiteState> {
  MenuWhiteCubit() : super(MenuWhiteInitial());
}
