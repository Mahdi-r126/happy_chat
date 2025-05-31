import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String firstLetter;
  const Avatar({super.key, required this.firstLetter});

  Color getColorForLetter(String letter) {
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.cyan,
    ];

    int index = letter.toUpperCase().codeUnitAt(0) % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: getColorForLetter(firstLetter.toString()),
      child: Text(
        firstLetter.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }
}
