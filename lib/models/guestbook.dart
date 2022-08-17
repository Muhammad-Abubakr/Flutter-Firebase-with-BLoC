// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Guestbook with EquatableMixin {
  final String? name;
  final String? message;

  const Guestbook({
    required this.name,
    required this.message,
  });

  @override
  List<Object?> get props => [name, message];

  factory Guestbook.fromMap(Map<String, dynamic> map) {
    return Guestbook(
      name: map['sender'] as String?,
      message: map['text'] as String?,
    );
  }
}
