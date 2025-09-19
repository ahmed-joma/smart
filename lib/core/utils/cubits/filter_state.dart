import '../models/filter_models.dart';

abstract class FilterState {}

class FilterInitial extends FilterState {}

// Filter Details States (for getDetails API)
class FilterDetailsLoading extends FilterState {}

class FilterDetailsSuccess extends FilterState {
  final FilterDetails data;

  FilterDetailsSuccess(this.data);
}

class FilterDetailsError extends FilterState {
  final String message;

  FilterDetailsError(this.message);
}

// Filter Results States (for filter API)
class FilterResultsLoading extends FilterState {}

class FilterResultsSuccess extends FilterState {
  final FilterResult results;
  final FilterRequest appliedFilters;

  FilterResultsSuccess(this.results, this.appliedFilters);
}

class FilterResultsError extends FilterState {
  final String message;

  FilterResultsError(this.message);
}
