import 'package:flutter/material.dart';

class EmptyChatView extends StatelessWidget {
  const EmptyChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/welcome.png', height: 170),
          const SizedBox(height: 16),
          const Text(
            'هنوز به این دنیا وارد نشدی.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text('یه پورتال بزن، به گوش رفیقت.')
        ],
      ),
    );
  }
}
