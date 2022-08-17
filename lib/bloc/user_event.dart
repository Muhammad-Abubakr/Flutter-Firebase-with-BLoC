part of 'user_bloc.dart';

abstract class UserEvent {}

class SetUserEvent implements UserEvent {
  final User? user;

  const SetUserEvent(this.user);
}
