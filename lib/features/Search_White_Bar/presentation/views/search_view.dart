import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/search_body.dart';
import '../../../../core/utils/cubits/filter_cubit.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/utils/cubits/favorite_cubit.dart';

class SearchView extends StatelessWidget {
  final Map<String, dynamic>? searchData;

  const SearchView({super.key, this.searchData});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<FilterCubit>()),
        BlocProvider.value(value: sl<FavoriteCubit>()),
      ],
      child: Scaffold(body: SearchBody(searchData: searchData)),
    );
  }
}
