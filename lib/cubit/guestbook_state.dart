part of 'guestbook_cubit.dart';

abstract class GuestbookState extends Equatable {
  final List<Guestbook> guestbook;

  const GuestbookState(this.guestbook);

  @override
  List<Object?> get props => [guestbook];
}

class GuestbookInitial extends GuestbookState {
  const GuestbookInitial(super.guestbook);
}

class GuestbookUpdate extends GuestbookState {
  const GuestbookUpdate(super.guestbook);
}
