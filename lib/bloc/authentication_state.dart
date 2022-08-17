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
