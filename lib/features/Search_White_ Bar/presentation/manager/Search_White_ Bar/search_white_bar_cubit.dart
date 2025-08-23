import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_white_bar_state.dart';

class SearchWhiteBarCubit extends Cubit<SearchWhiteBarState> {
  SearchWhiteBarCubit() : super(SearchWhiteBarInitial());
}
