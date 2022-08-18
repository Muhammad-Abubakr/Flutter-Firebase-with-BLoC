import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_bloc.dart';

part 'attendees_event.dart';
part 'attendees_state.dart';

class AttendeesBloc extends Bloc<AttendeesEvent, AttendeesState> {
  // getting userBloc which we will receive as an argument
  final UserBloc _userBloc;
  late User? _user;

  AttendeesBloc(this._userBloc) : super(const AttendeesInitial(0, false)) {
    // abstracting the user from the UserBloc/UserState
    _user = _userBloc.state.user;
    // subscribe to the user stream
    _userBloc.stream.listen((userState) {
      _user = userState.user;

      // check if the user != null fetch attendees
      if (_user != null) {
        _fetchAttendees();
      } else {
        add(ResetAttendees());
      }
    });

    // registering event handlers
    on<_FetchedAttendees>(
        (event, emit) => emit(AttendeesUpdate(event.attendees, event.isAttending)));
    on<AddAttendee>(_onAddAttendee);
    on<RemoveAttendee>(_onRemoveAttendee);
    on<ResetAttendees>((event, emit) => emit(const AttendeesInitial(0, false)));
  }

  FutureOr<void> _onAddAttendee(AddAttendee event, Emitter<AttendeesState> emit) async {
    // The user will definitely not be null if they will be seeing the UI elements
    // to manipulate this BLoC's state but just for safety if there are changes in
    // the code we are relying on not to add a check, we will add a check
    if (_user != null) {
      // update the firebasefirestore
      DocumentReference newDocRef =
          FirebaseFirestore.instance.collection('attendees').doc(_user!.uid);
      await newDocRef.set({'attending': true});
    }
  }

  FutureOr<void> _onRemoveAttendee(RemoveAttendee event, Emitter<AttendeesState> emit) async {
    // The user will definitely not be null if they will be seeing the UI elements
    // to manipulate this BLoC's state but just for safety if there are changes in
    // the code we are relying on not to add a check, we will add a check
    if (_user != null) {
      await FirebaseFirestore.instance.doc('attendees/${_user!.uid}').delete();
    }
  }

  void _fetchAttendees() {
    // fetching the attendees from the firebase

    FirebaseFirestore.instance
        .collection('attendees')
        .snapshots()
        .listen((collectionSnapshot) {
      bool isAttending = false;

      for (var doc in collectionSnapshot.docs) {
        if (doc.id == _user!.uid) {
          isAttending = true;
          break;
        }
      }
      int attendees = collectionSnapshot.size;

      add(_FetchedAttendees(attendees, isAttending));
    });
  }
}
