part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  final User? user;

  const UserState(this.user);

  @override
  List<Object?> get props => [user];
}

class UserInitial extends UserState {
  const UserInitial(super.user);

  @override
  List<Object?> get props => [user];
}

class UserUpdate extends UserState {
  const UserUpdate(super.user);

  @override
  List<Object?> get props => [user];
}
