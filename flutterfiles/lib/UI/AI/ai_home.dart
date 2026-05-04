import 'package:flutter/material.dart';
import 'package:dart_llama/dart_llama.dart';

class AiHome extends StatelessWidget {
  const AiHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surfaceContainer, title: Text("AI")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: (() async {
            try {
              // Create configuration
              final config = LlamaConfig(modelPath: '/home/jaime/AI_models/Qwen3-0.6B-Q8_0.gguf', contextSize: 2048, threads: 4);

              // Initialize the model
              final model = LlamaModel(config);
              model.initialize();

              // Create a generation request
              final request = GenerationRequest(prompt: 'Once upon a time in a galaxy far, far away', temperature: 0.7, maxTokens: 256);

              // Generate text
              final response = await model.generate(request);
              model.dispose();

              return response.text;
            } catch (e) {
              print(e);
            }
          })(),
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
