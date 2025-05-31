import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  final DateTime timestamp;

  const MessageBubble({
    super.key,
    required this.isMe,
    required this.text,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.red.shade200 : Colors.amber.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, textAlign: TextAlign.right),
      ),
    );
  }
}
