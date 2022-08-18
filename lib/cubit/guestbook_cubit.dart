import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';
import '../models/guestbook.dart';

part 'guestbook_state.dart';

class GuestbookCubit extends Cubit<GuestbookState> {
  late final UserBloc _userBloc;
  late User? _user;
  late StreamSubscription<QuerySnapshot> _guestbookSubscription;

  GuestbookCubit(this._userBloc) : super(const GuestbookInitial([])) {
    // get the first state (intiialized state of user)
    _user = _userBloc.state.user;

    // then we will subscribe to the userbloc stream and get the latest state
    _userBloc.stream.listen((userState) {
      _user = userState.user;
    });

    // we will only fetch the data if the user is logged in
    if (_user != null) {
      print("guestbook cubit => ${_user}");
      fetchGuestbookData();
    }
  }

  // Fetch guestbook data from the firebase firestore
  void fetchGuestbookData() {
    // access the guestbook collection from the firestore
    _guestbookSubscription = FirebaseFirestore.instance
        .collection('guestbook')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .listen((snapshot) {
      // creating a List of Guestbook to temporarily
      // store the querysnapshot instance
      List<Guestbook> tempStorage = [];

      for (var doc in snapshot.docs) {
        tempStorage.add(Guestbook.fromMap(doc.data()));
      }

      // after adding all the snapshot data emit the state
      emit(GuestbookUpdate(tempStorage));
    });
  }

  // adding methods to add data to the guestbook
  // for which we have created this cubit in order
  // to mantain it's state
  Future<void> addDocumentToGuestbook(String message) async {
    // if the user is not logged in
    if (_user == null) {
      throw Exception('Must be LOGGED IN');
    }
    // if they are
    await FirebaseFirestore.instance.collection('guestbook').add(<String, Object>{
      'text': message,
      'timestamp': DateTime.now().toIso8601String(),
      'sender': _userBloc.state.user!.displayName!,
      'userId': _userBloc.state.user!.uid,
    });
  }

  @override
  Future<void> close() {
    _guestbookSubscription.cancel();

    return super.close();
  }
}
