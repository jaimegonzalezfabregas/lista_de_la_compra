import 'dart:async';

import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:fllama/fllama.dart';
import 'package:fllama/fllama_universal.dart';
import 'package:fllama/misc/openai.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/UI/AI/ai_tools.dart';

class AiChat extends StatefulWidget {
  final String chatId;

  AiChat(this.chatId);

  @override
  State<AiChat> createState() {
    return AiChatState();
  }
}

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

class AiChatState extends State<AiChat> {
  List<String> pendingMessages = [];
  List<Message> conversationState = [Message(Role.system, getContext())];
  Widget? currentMessage;

  void aiTurn() {
    if (pendingMessages.isEmpty) {
      return;
    }

    String userMessage = pendingMessages[0];
    pendingMessages = pendingMessages.sublist(1);

    conversationState.add(Message(Role.user, userMessage));

    StreamController<String> streamController = StreamController();

    final request = OpenAiRequest(
      maxTokens: 256,
      messages: conversationState,
      numGpuLayers: 99,
      /* this seems to have no adverse effects in environments w/o GPU support, ex. Android and web */
      modelPath: "./${widget.chatId}.gguf",
      // mmprojPath: _mmprojPath,
      frequencyPenalty: 0.0,
      // Don't use below 1.1, LLMs without a repeat penalty
      // will repeat the same token.
      presencePenalty: 1.1,
      topP: 1.0,
      // Proportional to RAM use.
      // 4096 is a good default.
      // 2048 should be considered on devices with low RAM (<8 GB)
      // 8192 and higher can be considered on device with high RAM (>16 GB)
      // Models are trained on <= a certain context size. Exceeding that # can/will lead to completely incoherent output.
      contextSize: 1024,
      // Don't use 0.0, some models will repeat the same token.
      temperature: 0.1,
      logger: (log) {
        // ignore: avoid_print
        // print('[llama.cpp] $log');
      },
      toolChoice: ToolChoice.auto,
      tools: getTools(),
    );

    String lastResponse = "";

    fllamaChat(request, (response, r, done) {
      if (done) {
        setState(() {
          conversationState.add(Message(Role.assistant, lastResponse));
          currentMessage = null;
        });
      } else {
        lastResponse = response;
        streamController.add(response);
      }
    });
    setState(() {
      currentMessage = StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!);
          }
          return Text("...");
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> messageBubbles = [];

    for (var msg in conversationState) {
      messageBubbles.add(MessageBubble(message: Text(msg.text), role: msg.role));
    }

    if (currentMessage != null) {
      messageBubbles.add(MessageBubble(role: Role.assistant, message: currentMessage!));
    }

    for (var msg in pendingMessages) {
      messageBubbles.add(MessageBubble(message: Text(msg), role: Role.user));
    }

    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surfaceContainer, title: Text("AI")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(children: messageBubbles),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
            ),
            MessageBar(
              onSend: (msg) {
                pendingMessages.add(msg);
                aiTurn();
              },
              actions: [
                InkWell(
                  child: Icon(Icons.stop, color: Colors.black, size: 24),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
