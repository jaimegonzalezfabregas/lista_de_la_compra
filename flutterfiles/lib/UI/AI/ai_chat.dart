import 'dart:async';

import 'package:fllama/fllama_universal.dart';
import 'package:fllama/misc/openai.dart';
import 'package:flutter/material.dart';

class AiChat extends StatelessWidget {
  const AiChat({super.key});

  @override
  Widget build(BuildContext context) {
    StreamController streamController = StreamController();

    final request = OpenAiRequest(
      maxTokens: 256,
      messages: [Message(Role.system, 'You are a chatbot.'), Message(Role.user, "4+4=?")],
      numGpuLayers: 99,
      /* this seems to have no adverse effects in environments w/o GPU support, ex. Android and web */
      modelPath: "/home/jaime/Desktop/projects/2025/lista_de_la_compra/src/flutterfiles/assets/ai/Qwen3-0.6B-Q8_0.gguf",
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
        print('[llama.cpp] $log');
      },
    );
    fllamaChat(request, (response, r, done) {
      print("response ${response} | ${r} | ${done}");
      streamController.add(response);
    });

    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surfaceContainer, title: Text("AI")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: streamController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading...");
            }
            return Text(snapshot.data!);
          },
        ),
      ),
    );
  }
}
