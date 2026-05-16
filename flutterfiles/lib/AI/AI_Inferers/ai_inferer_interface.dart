import 'dart:async';
import 'dart:convert';

import 'package:fllama/misc/openai.dart';
import 'package:lista_de_la_compra/AI/ai_tools.dart';

abstract class InferenceEvent {}

class InferenceEnd extends InferenceEvent {
  List<Jmessage> conversation;

  InferenceEnd(this.conversation);

  @override
  String toString() {
    return "InferenceEnd($conversation)";
  }
}

class InferenceConversationUpdate extends InferenceEvent {
  List<Jmessage> conversation;
  InferenceConversationUpdate(this.conversation);

  @override
  String toString() {
    return "InferenceConversationUpdate($conversation)";
  }
}

class InferenceAborted extends InferenceEvent {}

class InferenceUpdate extends InferenceEvent {
  String resultSoFar;

  InferenceUpdate(this.resultSoFar);

  @override
  String toString() {
    return "InferenceConversationUpdate($resultSoFar)";
  }
}

abstract class Inferrer {
  List<Jtool> tools;

  Inferrer(this.tools);

  Stream<InferenceEvent> inferResponse(List<Jmessage> conversation);
  void abort();

  Stream<InferenceEvent> inferResponseToolReady(List<Jmessage> conversation) {
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
              print(toolCall);
              if (t.name == toolCall["name"]) {
                toolResponse = t.tool(toolCall["arguments"]);
              }
            }
          }

          if (toolResponse != null) {
            conversation.add(Jmessage(Jrole.tool, toolResponse));

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
  String Function(Map<String, dynamic> args) tool;

  Jtool({required this.name, required this.description, required this.jsonSchema, required this.tool});
}

enum Jrole {
  assistant,
  tool,
  user,
  system;

  Role intoFllamaRole() {
    switch (this) {
      case Jrole.assistant:
        return Role.assistant;
      case Jrole.tool:
        return Role.tool;
      case Jrole.user:
        return Role.user;
      case Jrole.system:
        return Role.system;
    }
  }
}

class Jmessage {
  final Jrole role;
  final String text;

  Jmessage(this.role, this.text);

  Message intoFllamaMessage() {
    return Message(role.intoFllamaRole(), text);
  }

  @override
  String toString() {
    return "Jmessage($role, $text)";
  }
}
