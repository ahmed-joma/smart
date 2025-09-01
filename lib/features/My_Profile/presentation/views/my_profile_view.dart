import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/my_profile_body.dart';
import '../manager/saved_items_cubit.dart';
import '../../data/repos/saved_items_repository.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedItemsCubit(SavedItemsRepositoryImpl()),
      child: const MyProfileBody(),
    );
  }
}
