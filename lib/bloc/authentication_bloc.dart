import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../firebase_options.dart';
import 'user_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  // sinc we will need to update the user state after successful registration
  // we will need the user bloc instance here which we will get as an arg
  final UserBloc _userBloc;

  AuthenticationBloc(this._userBloc)
      : super(const AuthenticationInitialState(ApplicationLoginState.loggedOut)) {
    // registering event handlers
    on<AuthInitEvent>(_intializeAuthenticationState);

    // Initializing the FirebaseApp
    add(AuthInitEvent());

    // ... Continue registering event handlers
    on<StartLoginFlow>(_startLoginFlowHandler);
    on<VerifyEmail>(_emailVerificationHandler);
    on<SignInWithEmailAndPassword>(_signInEmailPasswordHandler);
    on<CancelRegistration>(_cancelRegistrationHandler);
    on<RegisterUser>(_registerUserHandler);
    on<SignOutEvent>(_signOutHandler);
    on<ForgotPassword>(_onForgotPassword);
  }

  // ? Authentication State Initialization Hanlder
  FutureOr<void> _intializeAuthenticationState(
      AuthInitEvent event, Emitter<AuthenticationState> emit) async {
    /// creating a [FirebaseApp] instance for firebase authentication
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// once the instance have been created we can listen to the changes
    /// using [FirebaseAuth] and get access to the [FirebaseApp] instance
    /// that we have just instantiated using the [instance] getter
    await emit.forEach(FirebaseAuth.instance.userChanges(), onData: (state) {
      // updating the UserState
      _userBloc.add(SetUserEvent(FirebaseAuth.instance.currentUser));

      print(state);

      if (state != null) {
        return const AuthenticationUpdatedState(ApplicationLoginState.loggedIn);
      } else {
        return const AuthenticationUpdatedState(ApplicationLoginState.loggedOut);
      }
    });
  }

  // ? Start Login flow handler
  FutureOr<void> _startLoginFlowHandler(
      StartLoginFlow event, Emitter<AuthenticationState> emit) {
    emit(const AuthenticationUpdatedState(ApplicationLoginState.emailAddress));
  }

  // ? Email verification handler
  FutureOr<void> _emailVerificationHandler(
      VerifyEmail event, Emitter<AuthenticationState> emit) async {
    try {
      // Fetch the sign in methods for the email
      // if there a user with the specified email
      // the methods that may be used for signing in the user
      // will be returned incase you have more than one auth
      // opions enabled in the Firebase Authentication
      var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(event.email);

      // If the methods contain [password] method set the AuthenticationState to password
      // since we have only enabled [email/password] authentication method we will only
      // check for it.
      if (methods.contains('password')) {
        emit(const AuthenticationUpdatedState(ApplicationLoginState.password));
        // otherwise if their is an empty list returned it means that the email is not
        // associated with any user, update the Authentication state to register
        // to show appropriate interface to help the user register since we are relying
        // on reactive programming.
      } else {
        emit(const AuthenticationUpdatedState(ApplicationLoginState.register));
      }

      // if the user email address is invalid an exception will be thrown
      // we can handle it and tell the user that their email address is not valid
    } on FirebaseAuthException catch (e) {
      event.errorCallback!(e);
    }
  }

  // ? Sign in with email and password handler
  FutureOr<void> _signInEmailPasswordHandler(
      SignInWithEmailAndPassword event, Emitter<AuthenticationState> emit) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: event.email, password: event.password);
    } on FirebaseAuthException catch (e) {
      event.errorCallback!(e);
    }
  }

  // ? Cancel registration incase if user cancels the registration and
  // wanna go back to the email address state
  FutureOr<void> _cancelRegistrationHandler(
      CancelRegistration event, Emitter<AuthenticationState> emit) {
    emit(const AuthenticationUpdatedState(ApplicationLoginState.emailAddress));
  }

  // Register User handler
  FutureOr<void> _registerUserHandler(
      RegisterUser event, Emitter<AuthenticationState> emit) async {
    // try to register the user
    try {
      // if the creation of the user is successful,
      // it returns the UserCredentials object
      var userCredentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: event.email, password: event.password);

      // todo then update the UserCredentials
      await userCredentials.user!.updateDisplayName(event.displayName);

      // Incase of any exception among the ones thrown by the
      // .createWithEmailAndPassword
    } on FirebaseAuthException catch (e) {
      event.errorCallback!(e);
    }
  }

  // ? Sign Out Event Handler
  FutureOr<void> _signOutHandler(SignOutEvent event, Emitter<AuthenticationState> emit) async {
    await FirebaseAuth.instance.signOut();

    // update the user state to be null after they have logged out
    _userBloc.add(const SetUserEvent(null));
  }

  // ? Forgot Password event handler
  FutureOr<void> _onForgotPassword(
      ForgotPassword event, Emitter<AuthenticationState> emit) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
    } on FirebaseAuthException catch (e) {
      event.errorCallback(e);
    }
  }
}
