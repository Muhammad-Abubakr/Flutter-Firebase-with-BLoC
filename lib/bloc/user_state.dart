// I think this user bloc thing is not really necessary. It's not really actually doing anything. You can just have 1 auth bloc.

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
