import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ConnectMqtt extends ChatEvent {}

class DisconnectMqtt extends ChatEvent {}

class NewMessageReceived extends ChatEvent {
  final String contactToken;
  final String message;

  const NewMessageReceived(this.contactToken, this.message);

  @override
  List<Object?> get props => [contactToken, message];
}

class SendMessage extends ChatEvent {
  final String message;
  final String contactToken;

  const SendMessage(this.message, this.contactToken);

  @override
  List<Object?> get props => [message, contactToken];
}
