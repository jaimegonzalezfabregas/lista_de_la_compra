import 'dart:async';

import 'package:cactus/cactus.dart';
import 'package:fllama/fllama.dart';
import 'package:lista_de_la_compra/AI/ai_tools.dart';

class JtoolCall {
  final String name;
  final Map<String, dynamic> arguments;

  JtoolCall(this.name, this.arguments);

  static JtoolCall fromCactus(ToolCall cactusToolCall) {
    return JtoolCall(cactusToolCall.name, cactusToolCall.arguments);
  }
}

abstract class InferenceEvent {}

class InferenceEnd extends InferenceEvent {
  final List<Jmessage> conversation;

  InferenceEnd(this.conversation);

  @override
  String toString() {
    return "InferenceEnd($conversation)";
  }
}

class InferenceConversationUpdate extends InferenceEvent {
  final List<Jmessage> conversation;

  InferenceConversationUpdate(this.conversation);

  @override
  String toString() {
    return "InferenceConversationUpdate($conversation)";
  }
}

class InferenceToolCall extends InferenceEvent {
  final List<JtoolCall> jtoolCall;
  final List<Jmessage> conversation;

  InferenceToolCall(this.jtoolCall, this.conversation);

  @override
  String toString() {
    return "InferenceConversationUpdate(jtoolCall: $jtoolCall, conversation: $conversation)";
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

class StartingInference extends InferenceEvent {}

abstract class Inferrer {
  List<Jtool> tools;

  Inferrer(this.tools);

  Future<Stream<InferenceEvent>> inferResponse(List<Jmessage> conversation, {int maxTokens = 333});
  void abort();
  Future<void> unload();

  Future<Stream<InferenceEvent>> inferResponseToolReady(List<Jmessage> conversation, {int maxTokens = 333}) async {
    StreamController<InferenceEvent> superStreamController = StreamController<InferenceEvent>();

    void prepareStream(Stream<InferenceEvent> stream) {
      stream.listen((event) async {

        if (event is InferenceConversationUpdate) {
          superStreamController.add(event);
        }

        if (event is InferenceToolCall) {
          List<Jmessage> conversation = event.conversation;
          List<JtoolCall> toolCalls = event.jtoolCall;

          for (JtoolCall tc in toolCalls) {
            Jtool jtool = tools.firstWhere(
              (Jtool tool) => tool.name == tc.name,
              orElse: () => Jtool.failure("The tool with name ${tc.name} does not exist!"),
            );

            conversation.add(Jmessage(Jrole.tool, await jtool.tool(tc.arguments)));
          }

          superStreamController.add(InferenceConversationUpdate(conversation));

          prepareStream(await inferResponse(conversation, maxTokens: maxTokens));
        }

        if (event is InferenceEnd || event is InferenceAborted) {
          superStreamController.add(event);
          superStreamController.close();
        }

        if (event is InferenceUpdate || event is StartingInference) {
          superStreamController.add(event);
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
  Future<String> Function(Map<String, dynamic> args) tool;

  Jtool({required this.name, required this.description, required this.jsonSchema, required this.tool});

  Tool intoFllamaTool() {
    return Tool(name: name, description: description, jsonSchema: jsonSchema.intoFllamaJsonSchema());
  }

  CactusTool intoCactusTool() {
    return CactusTool(description: description, name: name, parameters: jsonSchema.intoCactusSchema());
  }

  static Jtool failure(String message) {
    return Jtool(name: "Unknown Tool", description: "", tool: (_) async => message, jsonSchema: JtoolSchema());
  }
}

enum Jrole {
  assistant,
  tool,
  user,
  system,
  toolCall;

  Role intoFllamaRole() {
    switch (this) {
      case Jrole.toolCall:
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

  String intoCactusRole() {
    switch (this) {
      case Jrole.toolCall:
      case Jrole.assistant:
        return "assistant";
      case Jrole.tool:
        return "tool";
      case Jrole.user:
        return "user";
      case Jrole.system:
        return "system";
    }
  }
}

class Jmessage {
  final Jrole role;
  final String text;

  Jmessage(this.role, this.text);

  Message? intoFllamaMessage() {
    return Message(role.intoFllamaRole(), text);
  }

  ChatMessage? intoCactusMessage() {
    return ChatMessage(role: role.intoCactusRole(), content: text);
  }

  @override
  String toString() {
    return "Jmessage($role, $text)";
  }
}
