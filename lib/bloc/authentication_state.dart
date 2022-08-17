/* 

You don't need multiple classes like you have here. You can just have 1 class to represent your bloc state.

I would recommend you to follow this template for your bloc state. 
3 properties: 1 for the status for the bloc, 1 for the relevant property in the bloc, so
in this case the User. 1 for the error. Also have an enum to represent the different possible status.
So for example:

enum AuthStatus { initial, loading, success, failure }

const AuthenticationState({
   this.status = AuthStatus.initial,
   this.User = null,
   this.error = '',
});

It doesn't have to have named parameters, that's just what I prefer.

Also, you will need a copywith method to return an updated copy of the state in the bloc.

Refer to here: https://github.com/Dan-Y-Ko/chingu_bookfinder_flutter/blob/master/lib/book/bloc/book_list/book_list_state.dart for an example.
*/ 

part of 'authentication_bloc.dart';

enum ApplicationLoginState {
  loggedOut,
  emailAddress,
  register,
  password,
  loggedIn,
  forgotPassword,
}

class AuthenticationState extends Equatable {
  // state
  final ApplicationLoginState loginState;

  const AuthenticationState(this.loginState);

  @override
  List<Object?> get props => [loginState];
}

// Initial State
class AuthenticationInitialState extends AuthenticationState {
  const AuthenticationInitialState(super.state);
}

// Updated State
class AuthenticationUpdatedState extends AuthenticationState {
  const AuthenticationUpdatedState(super.state);
}
