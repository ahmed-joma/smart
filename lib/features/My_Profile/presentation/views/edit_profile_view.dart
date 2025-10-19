import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/edit_profile_body.dart';
import '../../../Profile/presentation/manager/profile_cubit.dart';
import '../../../../core/utils/service_locator.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the global ProfileCubit instead of creating a new one
    final globalProfileCubit = sl<ProfileCubit>();

    return BlocProvider.value(
      value: globalProfileCubit,
      child: const EditProfileBody(),
    );
  }
}
