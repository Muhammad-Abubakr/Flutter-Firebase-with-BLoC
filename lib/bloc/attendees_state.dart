part of 'attendees_bloc.dart';

abstract class AttendeesState extends Equatable {
  final bool isAttending;
  final int attendees;

  const AttendeesState(this.attendees, this.isAttending);

  @override
  List<Object> get props => [attendees];
}

class AttendeesInitial extends AttendeesState {
  const AttendeesInitial(super.attendees, super.isAttending);
}

class AttendeesUpdate extends AttendeesState {
  const AttendeesUpdate(super.attendees, super.isAttending);
}
