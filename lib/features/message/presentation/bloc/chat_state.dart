import 'package:chat/features/chat/data/models/contact.dart';
import 'package:equatable/equatable.dart';

class ChatMessage {
  final String text;
  final bool isSentByMe;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isSentByMe,
    required this.time,
  });
}

enum ChatStatus { initial, loading, loaded, error }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<Contact> contacts;
  final Map<String, List<ChatMessage>> messagesPerContact;
  final String? errorMessage;

  const ChatState({
    this.status = ChatStatus.initial,
    this.contacts = const [],
    this.messagesPerContact = const {},
    this.errorMessage,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<Contact>? contacts,
    Map<String, List<ChatMessage>>? messagesPerContact,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      messagesPerContact: messagesPerContact ?? this.messagesPerContact,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<ChatMessage>? messagesForContact(String contactToken) {
    return messagesPerContact[contactToken];
  }

  @override
  List<Object?> get props =>
      [status, contacts, messagesPerContact, errorMessage];
}
