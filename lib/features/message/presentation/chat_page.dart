import 'package:chat/features/chat/data/models/contact.dart';
import 'package:chat/features/message/data/remote_data_source/chat_api.dart';
import 'package:chat/features/message/presentation/bloc/chat_bloc.dart';
import 'package:chat/features/message/presentation/bloc/chat_event.dart';
import 'package:chat/features/message/presentation/bloc/chat_state.dart';
import 'package:chat/utils/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/empty_chat_page.dart';
import 'widgets/message_bubble.dart';

class ChatPage extends StatelessWidget {
  final String userToken;
  final Contact contact;
  const ChatPage({super.key, required this.userToken, required this.contact});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = ChatBloc(
            ChatApi(userToken: userToken, contactToken: contact.contactToken));
        bloc.add(ConnectMqtt());
        return bloc;
      },
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: _ChatPageContent(contact: contact)),
    );
  }
}

class _ChatPageContent extends StatefulWidget {
  final Contact contact;

  const _ChatPageContent({required this.contact});

  @override
  State<_ChatPageContent> createState() => _ChatPageContentState();
}

class _ChatPageContentState extends State<_ChatPageContent> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatBloc>().add(SendMessage(
          text,
          widget.contact.contactToken,
        ));
    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contact.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        leading: const BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Avatar(
              firstLetter: widget.contact.name.substring(0, 1),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final messages =
              state.messagesPerContact[widget.contact.contactToken] ?? [];
          return Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? const EmptyChatView()
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return MessageBubble(
                            isMe: message.isSentByMe,
                            text: message.text,
                            timestamp: message.time,
                          );
                        },
                      ),
              ),
              const Divider(height: 1),
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.red.shade100,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                            hintText: 'نوشتن پیام...',
                            border: InputBorder.none),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
