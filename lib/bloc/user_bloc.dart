import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserInitial(null)) {
    on<SetUserEvent>(_userUpdateEventHandler);
  }

  FutureOr<void> _userUpdateEventHandler(SetUserEvent event, Emitter<UserState> emit) {
    emit(UserUpdate(event.user));
  }
}
