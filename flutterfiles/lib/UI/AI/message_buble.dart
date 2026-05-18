import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';

class MessageBubble extends StatelessWidget {
  final Widget message;
  final Jrole role;
  const MessageBubble({super.key, required this.message, required this.role});
  @override
  Widget build(BuildContext context) {
    late BoxDecoration decore;

    switch (role) {
      case Jrole.assistant:
        decore = BoxDecoration(color: const Color.fromARGB(255, 142, 142, 142), borderRadius: BorderRadius.circular(15));

      case Jrole.toolCall:
        decore = BoxDecoration(color: const Color.fromARGB(255, 89, 126, 92), borderRadius: BorderRadius.circular(15));
      case Jrole.system:
        decore = BoxDecoration(color: const Color.fromARGB(255, 255, 80, 80), borderRadius: BorderRadius.circular(15));
      case Jrole.tool:
        decore = BoxDecoration(color: const Color.fromARGB(255, 38, 137, 50), borderRadius: BorderRadius.circular(15));
      case Jrole.user:
       
          decore = BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15));
        
    }

    return Align(
      alignment: role == Jrole.user ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(padding: EdgeInsets.all(10), margin: EdgeInsets.symmetric(vertical: 5), decoration: decore, child: message),
    );
  }
}
