import 'dart:async';
import 'dart:convert';

import 'package:fllama/fllama.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';
import 'package:lista_de_la_compra/AI/ai_tools.dart';

class FllamaInferrer extends Inferrer {
  final String modelPath;
  bool running = false;
  bool abortFlag = false;

  FllamaInferrer(this.modelPath, super.tools);

  @override
  Future<Stream<InferenceEvent>> inferResponse(List<Jmessage> conversation, {int maxTokens = 333}) async {
    final request = OpenAiRequest(
      maxTokens: maxTokens,
      messages: conversation.map((e) => e.intoFllamaMessage()).whereType<Message>().toList(),
      numGpuLayers: 99,
      /* this seems to have no adverse effects in environments w/o GPU support, ex. Android and web */
      modelPath: modelPath,
      frequencyPenalty: 0.3,
      // Don't use below 1.1, LLMs without a repeat penalty
      // will repeat the same token.
      presencePenalty: 1.1,
      topP: 1.0,
      // Proportional to RAM use.
      // 4096 is a good default.
      // 2048 should be considered on devices with low RAM (<8 GB)
      // 8192 and higher can be considered on device with high RAM (>16 GB)
      // Models are trained on <= a certain context size. Exceeding that # can/will lead to completely incoherent output.
      contextSize: 8192,
      // Don't use 0.0, some models will repeat the same token.
      temperature: 0.1,
      logger: (log) {
        // ignore: avoid_print
        // print('[llama.cpp] $log');
      },
      toolChoice: ToolChoice.auto,
      tools: tools.map((t) => Tool(name: t.name, jsonSchema: t.jsonSchema.intoFllamaJsonSchema(), description: t.description)).toList(),
    );

    StreamController<InferenceEvent> streamController = StreamController<InferenceEvent>();
    streamController.add(StartingInference());

    running = true;
    bool localAbort = false;
    String lastResponse = "";
    fllamaChat(request, (response, _, done) {
      if (localAbort) {
        return;
      }

      if (abortFlag) {
        localAbort = true;
        running = false;
        abortFlag = false;
        streamController.add(InferenceAborted());
        streamController.close();
      }

      if (done) {
        running = false;

        (String, Map<String, dynamic>?) messageAnalisys = extractLastJson(lastResponse);

        if (messageAnalisys.$2 != null && messageAnalisys.$2!["name"] != null) {
          String name = messageAnalisys.$2!["name"];
          Map<String, dynamic>? arguments = messageAnalisys.$2!["arguments"];

          conversation.add(Jmessage(Jrole.assistant, messageAnalisys.$1));
          conversation.add(Jmessage(Jrole.toolCall, jsonEncode(messageAnalisys.$2)));

          streamController.add(InferenceToolCall([JtoolCall(name, arguments ?? {})], conversation));
        } else {
          conversation.add(Jmessage(Jrole.assistant, lastResponse));

          streamController.add(InferenceEnd(conversation));
          streamController.close();
        }
      } else {
        lastResponse = response;
        streamController.add(InferenceUpdate(response));
      }
    });

    return streamController.stream;
  }

  @override
  void abort() {
    if (running) {
      abortFlag = true;
    }
  }

  @override
  Future<void> unload() async {}
}
