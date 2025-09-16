part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileUpdating extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final ProfileData data;

  const ProfileSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
