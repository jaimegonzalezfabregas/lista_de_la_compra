import 'dart:async';
import 'dart:convert';

import 'package:cactus/cactus.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';

class CactusInferrer extends Inferrer {
  late final CactusLM lm;
  final String model; // "qwen3-0.6"

  late final Future<void> ready;

  bool running = false;
  bool stopFlag = false;

  CactusInferrer(super.tools, this.model) {
    lm = CactusLM();

    ready = lm.downloadModel(model: model).then((value) => lm.initializeModel());
  }

  @override
  void abort() {
    if (running) {
      stopFlag = true;
    }
  }

  @override
  Future<void> unload() async {
    await ready;
    lm.unload();
  }

  @override
  Future<Stream<InferenceEvent>> inferResponse(List<Jmessage> conversation, {int maxTokens = 333}) async {
    StreamController<InferenceEvent> streamController = StreamController<InferenceEvent>();

    List<CactusTool> cactusTools = super.tools
        .map((t) => CactusTool(name: t.name, description: t.description, parameters: t.jsonSchema.intoCactusSchema()))
        .toList();

    // Download model (defaults to "qwen3-0.6" if model parameter is omitted)
    await ready;

    if (running) {
      throw "inference already running";
    }

    running = true;

    streamController.add(StartingInference());

    final streamedResult = await lm.generateCompletionStream(
      messages: conversation.map((e) => e.intoCactusMessage()).whereType<ChatMessage>().toList(),
      params: CactusCompletionParams(tools: cactusTools),
    );

    String messageSoFar = "";

    bool localStopFlag = false;

    streamedResult.stream.listen((text) {
      if (localStopFlag) {
        return;
      }

      if (stopFlag) {
        stopFlag = false;
        localStopFlag = true;
        running = false;
        return;
      }

      messageSoFar += text;
      streamController.add(InferenceUpdate(messageSoFar));
    });

    streamedResult.result.then((CactusCompletionResult e) {
      if (localStopFlag) {
        return;
      }

      if (stopFlag) {
        stopFlag = false;
        localStopFlag = true;
        running = false;

        return;
      }

      if (e.success) {
        running = false;

        if (e.response.trim() != "") {
          conversation.add(Jmessage(Jrole.assistant, e.response));
        }
        if (e.toolCalls.isNotEmpty) {
          for (ToolCall tc in e.toolCalls) {
            conversation.add(Jmessage(Jrole.toolCall, jsonEncode(tc.toJson())));
          }

          streamController.add(InferenceToolCall(e.toolCalls.map((tc) => JtoolCall.fromCactus(tc)).toList(), conversation));
        } else {
          streamController.add(InferenceEnd(conversation));
        }
      } else {
        streamController.add(InferenceAborted());
      }
    });

    return streamController.stream;
  }
}
