import 'package:chat/features/message/data/remote_data_source/chat_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatApi chatService;

  ChatBloc(this.chatService) : super(const ChatState()) {
    on<ConnectMqtt>(_onConnectMqtt);
    on<DisconnectMqtt>(_onDisconnectMqtt);
    on<NewMessageReceived>(_onNewMessageReceived);
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onConnectMqtt(
      ConnectMqtt event, Emitter<ChatState> emit) async {
    try {
      await chatService.connectMqtt((topic, message) {
        final parts = topic.split('/');
        String contactToken = '';
        if (parts.length >= 4) {
          contactToken = parts[3];
        }

        add(NewMessageReceived(contactToken, message));
      });
    } catch (e) {
      throw Exception('Error connecting to MQTT: $e');
    }
  }

  void _onDisconnectMqtt(DisconnectMqtt event, Emitter<ChatState> emit) {
    chatService.disconnect();
  }

  void _onNewMessageReceived(
      NewMessageReceived event, Emitter<ChatState> emit) {
    final currentMessages =
        Map<String, List<ChatMessage>>.from(state.messagesPerContact);
    final messagesForContact =
        List<ChatMessage>.from(currentMessages[event.contactToken] ?? []);

    messagesForContact.add(ChatMessage(
        text: event.message, isSentByMe: false, time: DateTime.now()));
    currentMessages[event.contactToken] = messagesForContact;

    emit(state.copyWith(messagesPerContact: currentMessages));
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    final currentMessages =
        Map<String, List<ChatMessage>>.from(state.messagesPerContact);
    final messagesForContact =
        List<ChatMessage>.from(currentMessages[event.contactToken] ?? []);

    chatService.publishMessage(event.message);

    messagesForContact.add(ChatMessage(
        text: event.message, isSentByMe: true, time: DateTime.now()));
    currentMessages[event.contactToken] = messagesForContact;

    emit(state.copyWith(messagesPerContact: currentMessages));
  }
}
