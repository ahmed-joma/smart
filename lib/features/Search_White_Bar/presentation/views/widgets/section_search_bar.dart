import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/shared.dart';
import '../../../../Filters/presentation/views/Filter_page.dart';
import '../../../../../core/utils/service_locator.dart';
import '../../../../../core/utils/cubits/filter_cubit.dart';
import '../../../../../core/utils/cubits/favorite_cubit.dart';

class SectionSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;

  const SectionSearchBar({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (bottomSheetContext) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: sl<FilterCubit>()),
                  BlocProvider.value(value: sl<FavoriteCubit>()),
                ],
                child: const FilterPage(),
              ),
            );
          },
          child: Container(
            height: 56,
            constraints: const BoxConstraints(maxWidth: 180),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.tune, color: AppColors.onPrimary, size: 20),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'Find & Filter',
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
