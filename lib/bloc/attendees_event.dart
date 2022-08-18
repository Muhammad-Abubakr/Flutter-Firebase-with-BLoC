part of 'attendees_bloc.dart';

abstract class AttendeesEvent {}

class AddAttendee implements AttendeesEvent {}

class RemoveAttendee implements AttendeesEvent {}

class ResetAttendees implements AttendeesEvent {}

class _FetchedAttendees implements AttendeesEvent {
  final int attendees;
  final bool isAttending;

  _FetchedAttendees(this.attendees, this.isAttending);
}
