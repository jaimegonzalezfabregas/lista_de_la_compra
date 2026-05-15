import 'dart:async';
import 'dart:convert';

import 'package:fllama/fllama.dart';
import 'package:lista_de_la_compra/AI/ai_tools.dart';

abstract class InferenceEvent {}

class InferenceEnd extends InferenceEvent {
  List<Message> conversation;

  InferenceEnd(this.conversation);
}

class InferenceConversationUpdate extends InferenceEvent {
  List<Message> conversation;
  InferenceConversationUpdate(this.conversation);
}

class InferenceAborted extends InferenceEvent {}

class InferenceUpdate extends InferenceEvent {
  String resultSoFar;

  InferenceUpdate(this.resultSoFar);
}

abstract class Inferencer {
  List<Jtool> tools;

  Inferencer(this.tools);

  Stream<InferenceEvent> inferResponse(List<Message> conversation);
  void abort();

  Stream<InferenceEvent> inferResponseToolReady(List<Message> conversation) {
    StreamController<InferenceEvent> superStreamController = StreamController<InferenceEvent>();

    void prepareStream(Stream<InferenceEvent> stream) {
      stream.listen((event) {
        if (event is InferenceUpdate) {
          superStreamController.add(event);
        }

        if (event is InferenceAborted) {
          superStreamController.add(InferenceAborted());
          superStreamController.close();
        }

        if (event is InferenceConversationUpdate) {
          superStreamController.add(event);
        }

        if (event is InferenceEnd) {
          conversation = event.conversation;

          String? lastJson = extractLastJson(event.conversation.last.text);
          String? toolResponse;

          if (lastJson != null) {
            dynamic toolCall = jsonDecode(lastJson);

            for (Jtool t in tools) {
              if (t.name == toolCall["name"]) {
                toolResponse = t.tool(toolCall);
              }
            }
          }

          if (toolResponse != null) {
            conversation.add(Message(Role.tool, toolResponse));

            superStreamController.add(InferenceConversationUpdate(conversation));

            prepareStream(inferResponse(conversation));
          } else {
            superStreamController.add(event);
            superStreamController.close();
          }
        }
      });
    }

    prepareStream(inferResponse(conversation));

    return superStreamController.stream;
  }
}

class Jtool {
  String name;
  String description;
  String jsonSchema;
  String Function(String args) tool;

  Jtool({required this.name, required this.description, required this.jsonSchema, required this.tool});
}
