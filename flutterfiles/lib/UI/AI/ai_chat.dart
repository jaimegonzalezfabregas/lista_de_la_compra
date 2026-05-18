import 'dart:async';

import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';
import 'package:lista_de_la_compra/UI/AI/message_buble.dart';

class AiChat extends StatefulWidget {
  final Future<Inferrer> inferrer;
  final String aiName;

  const AiChat(this.inferrer, this.aiName, {super.key});

  @override
  State<AiChat> createState() {
    return AiChatState();
  }
}

final List<Jmessage> startingConversationState = [Jmessage(Jrole.system, "you are an chat agent")];

List<Jmessage> conversationState = startingConversationState;

class AiChatState extends State<AiChat> {
  // List<Message> conversationState = [Message(Role.system, getContext())];
  Widget? liveResponse;

  void aiTurn() async {
    Stream<InferenceEvent> inferenceStream = await (await widget.inferrer).inferResponseToolReady(conversationState);

    setState(() {
      liveResponse = Text("⏳");
    });

    inferenceStream.listen((event) {
      print("\n\n InferenceStream event $event \n\n");

      if (event is InferenceEnd) {
        setState(() {
          conversationState = event.conversation;
          liveResponse = null;
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

      if (event is StartingInference) {
        setState(() {
          liveResponse = CircularProgressIndicator(value: null);
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
      messageBubbles.add(MessageBubble(role: Jrole.assistant, message: liveResponse!));
    }

    return PopScope(
      onPopInvokedWithResult: (_, _) async {
        Inferrer inferrer = await widget.inferrer;
        setState(() {
          inferrer.unload();
        });
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surfaceContainer, title: Text(widget.aiName)),
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
                  setState(() {
                    conversationState.add(Jmessage(Jrole.user, msg));
                    aiTurn();
                  });
                },
                actions: [
                  InkWell(
                    child: Icon(Icons.stop, color: Colors.black, size: 24),
                    onTap: () async {
                      (await widget.inferrer).abort();
                    },
                  ),
                  InkWell(
                    child: Icon(Icons.refresh, color: Colors.black, size: 24),
                    onTap: () async {
                      setState(() {
                        conversationState = startingConversationState;
                      });
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
