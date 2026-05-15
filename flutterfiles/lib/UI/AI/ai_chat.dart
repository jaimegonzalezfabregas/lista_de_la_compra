import 'dart:async';
import 'dart:convert';

import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:fllama/fllama.dart';
import 'package:fllama/fllama_universal.dart';
import 'package:fllama/misc/openai.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';
import 'package:lista_de_la_compra/UI/AI/message_buble.dart';
import 'package:lista_de_la_compra/AI/ai_tools.dart';
import 'package:path_provider/path_provider.dart';

class AiChat extends StatefulWidget {
  final Inferencer inferencer;

  AiChat(this.inferencer);

  @override
  State<AiChat> createState() {
    return AiChatState();
  }
}

List<Message> conversationState = [Message(Role.system, "you are an chat agent")];

class AiChatState extends State<AiChat> {
  // List<Message> conversationState = [Message(Role.system, getContext())];
  Widget? liveResponse;

  void aiTurn() async {
    Stream<InferenceEvent> inferenceStream = widget.inferencer.inferResponseToolReady(conversationState);

    inferenceStream.listen((event) {
      if (event is InferenceEnd) {
        setState(() {
          conversationState = event.conversation;
        });
      }

      if (event is InferenceConversationUpdate) {
        setState(() {
          conversationState = event.conversation;
          liveResponse = null;
        });
      }

      if (event is InferenceUpdate) {
        setState(() {
          liveResponse = Text(event.resultSoFar);
        });
      }

      if (event is InferenceAborted) {
        setState(() {
          liveResponse = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> messageBubbles = [];

    for (var msg in conversationState) {
      messageBubbles.add(MessageBubble(message: Text(msg.text), role: msg.role));
    }

    if (liveResponse != null) {
      messageBubbles.add(MessageBubble(role: Role.assistant, message: liveResponse!));
    }

    return PopScope(
      onPopInvokedWithResult: (_, __) {
        setState(() {
          widget.inferencer.abort();
        });
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surfaceContainer, title: Text("AI")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(children: messageBubbles),
              ),
              MessageBar(
                onSend: (msg) {
                  conversationState.add(Message(Role.user, msg));

                  aiTurn();
                },
                actions: [
                  InkWell(
                    child: Icon(Icons.stop, color: Colors.black, size: 24),
                    onTap: () {
                      widget.inferencer.abort();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
