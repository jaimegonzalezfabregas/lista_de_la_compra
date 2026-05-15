import 'package:fllama/misc/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageBubble extends StatelessWidget {
  final Widget message;
  final Role role;
  final bool pending;
  const MessageBubble({super.key, required this.message, required this.role, this.pending = false});
  @override
  Widget build(BuildContext context) {
    late BoxDecoration decore;

    switch (role) {
      case Role.assistant:
        decore = BoxDecoration(color: const Color.fromARGB(255, 142, 142, 142), borderRadius: BorderRadius.circular(15));
      case Role.system:
        decore = BoxDecoration(color: const Color.fromARGB(255, 255, 80, 80), borderRadius: BorderRadius.circular(15));
      case Role.tool:
        decore = BoxDecoration(color: const Color.fromARGB(255, 65, 241, 85), borderRadius: BorderRadius.circular(15));
      case Role.user:
        if (pending) {
          decore = BoxDecoration(color: const Color.fromARGB(255, 157, 211, 255), borderRadius: BorderRadius.circular(15));
        } else {
          decore = BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15));
        }
    }

    return Align(
      alignment: role == Role.user ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(padding: EdgeInsets.all(10), margin: EdgeInsets.symmetric(vertical: 5), decoration: decore, child: message),
    );
  }
}
