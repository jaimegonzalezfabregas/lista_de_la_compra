import 'dart:async';

import 'package:cactus/cactus.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';

class CactusInferrer extends Inferrer {
  late final CactusLM lm;
  late final String model; // "qwen3-0.6"

  CactusInferrer(super.tools, this.model) {
    lm = CactusLM();
  }

  @override
  void abort() {
    lm.unload();
  }

  @override
  Future<Stream<InferenceEvent>> inferResponse(List<Jmessage> conversation, {int maxTokens = 333}) async {
    List<CactusTool> cactusTools = super.tools
        .map((t) => CactusTool(name: t.name, description: t.description, parameters: t.jsonSchema.intoCactusSchema()))
        .toList();

    // Download model (defaults to "qwen3-0.6" if model parameter is omitted)
    await lm.downloadModel(model: model);
    await lm.initializeModel();

    // Get the streaming response with default parameters
    final streamedResult = await lm.generateCompletionStream(
      messages: conversation.map((e) => e.intoChatMessage()).toList(),
      params: CactusCompletionParams(tools: cactusTools),
    );

    StreamController<InferenceEvent> streamController = StreamController<InferenceEvent>();

    streamedResult.stream.listen((text) {
      streamController.add(InferenceUpdate(text));
    });

    streamedResult.result.then((CactusCompletionResult e) {
      if (e.success) {
        conversation.add(Jmessage(Jrole.assistant, e.response));

        streamController.add(InferenceEnd(conversation));
      } else {
        streamController.add(InferenceAborted());
      }
    });

    return streamController.stream;
  }
}
