import 'dart:async';
import 'dart:convert';

import 'package:cactus/cactus.dart';
import 'package:fllama/fllama.dart';
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

  Future<Stream<InferenceEvent>> inferResponse(List<Jmessage> conversation, {int maxTokens = 333});
  void abort();

  Future<Stream<InferenceEvent>> inferResponseToolReady(List<Jmessage> conversation, {int maxTokens = 333}) async {
    StreamController<InferenceEvent> superStreamController = StreamController<InferenceEvent>();

    void prepareStream(Stream<InferenceEvent> stream) {
      stream.listen((event) async {
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

            prepareStream(await inferResponse(conversation, maxTokens: maxTokens));
          } else {
            superStreamController.add(event);
            superStreamController.close();
          }
        }
      });
    }

    prepareStream(await inferResponse(conversation));

    return superStreamController.stream;
  }
}

class Jtool {
  String name;
  String description;
  JtoolSchema jsonSchema;
  String Function(Map<String, dynamic> args) tool;

  Jtool({required this.name, required this.description, required this.jsonSchema, required this.tool});

  Tool intoFllamaTool() {
    return Tool(name: name, description: description, jsonSchema: jsonSchema.intoFllamaJsonSchema());
  }

  CactusTool intoCactusTool() {
    return CactusTool(description: description, name: name, parameters: jsonSchema.intoCactusSchema());
  }
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

  ChatMessage intoChatMessage() {
    return ChatMessage(content: text, role: role.name);
  }

  @override
  String toString() {
    return "Jmessage($role, $text)";
  }
}
