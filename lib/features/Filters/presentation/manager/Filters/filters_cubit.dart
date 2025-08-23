import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'filters_state.dart';

class FiltersCubit extends Cubit<FiltersState> {
  FiltersCubit() : super(FiltersInitial());
}
