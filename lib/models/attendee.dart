import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Attendee extends Equatable {
  final String attendee;
  final DocumentReference ref;

  const Attendee(this.attendee, this.ref);

  @override
  List<Object?> get props => [attendee, ref];
}
