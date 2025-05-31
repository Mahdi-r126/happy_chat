import 'package:chat/features/chat/data/models/contact.dart';
import 'package:equatable/equatable.dart';

enum ContactStatus { initial, loading, loaded, error, connected, disconnected }

class ContactState extends Equatable {
  final ContactStatus status;
  final List<Contact> contacts;
  final List<String> messages;
  final String? errorMessage;

  const ContactState({
    required this.status,
    required this.contacts,
    required this.messages,
    this.errorMessage,
  });

  factory ContactState.initial() {
    return const ContactState(
      status: ContactStatus.initial,
      contacts: [],
      messages: [],
      errorMessage: null,
    );
  }

  ContactState copyWith({
    ContactStatus? status,
    List<Contact>? contacts,
    List<String>? messages,
    String? errorMessage,
  }) {
    return ContactState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      messages: messages ?? this.messages,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, contacts, messages, errorMessage];
}
