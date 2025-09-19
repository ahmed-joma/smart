import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/Filter_body.dart';
import '../../../../core/utils/cubits/filter_cubit.dart';
import '../../../../core/utils/cubits/favorite_cubit.dart';
import '../../../../core/utils/repositories/filter_repository.dart';
import '../../../../core/utils/service_locator.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FilterCubit(sl<FilterRepository>())),
        BlocProvider(create: (context) => FavoriteCubit(sl())),
      ],
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Drag Handle
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(child: FilterBody(scrollController: scrollController)),
              ],
            ),
          );
        },
      ),
    );
  }
}
