// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

// events implementing AuthenticationEvent interface
class AuthInitEvent implements AuthenticationEvent {}

// start login flow event
class StartLoginFlow implements AuthenticationEvent {}

// verify email event
class VerifyEmail implements AuthenticationEvent {
  final String email;
  final void Function(FirebaseAuthException e)? errorCallback;

  const VerifyEmail({
    required this.email,
    this.errorCallback,
  });
}

// Sign in with email and password
class SignInWithEmailAndPassword implements AuthenticationEvent {
  final String email;
  final String password;
  final void Function(FirebaseAuthException e)? errorCallback;

  const SignInWithEmailAndPassword({
    required this.email,
    required this.password,
    this.errorCallback,
  });
}

// Cancel Registration Event
class CancelRegistration implements AuthenticationEvent {}

// Register User Event
class RegisterUser implements AuthenticationEvent {
  final String email;
  final String password;
  final String displayName;
  final void Function(FirebaseAuthException e)? errorCallback;

  const RegisterUser({
    required this.email,
    required this.password,
    required this.displayName,
    this.errorCallback,
  });
}

// Forgot Password Event
class ForgotPassword implements AuthenticationEvent {
  final String email;
  final void Function(FirebaseAuthException e) errorCallback;

  const ForgotPassword({required this.email, required this.errorCallback});
}

// Sign Out Event
class SignOutEvent implements AuthenticationEvent {}
