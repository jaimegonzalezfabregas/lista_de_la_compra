import 'package:flutter/material.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';

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
            Llama.libraryPath = "/home/jaime/Desktop/projects/2025/lista_de_la_compra/src/llamafiles/dist/x86_linux.so";
            
            try {

             final loadCommand = LlamaLoad(
                path: "/home/jaime/AI_models/Qwen3-0.6B-Q8_0.gguf",
                modelParams: ModelParams(),
                contextParams: ContextParams(),
                samplingParams: SamplerParams(),
              );

              final llamaParent = LlamaParent(loadCommand);
              await llamaParent.init();

              return await llamaParent.sendPrompt("2 * 2 = ?");

            } catch (e) {
              print(e);
            }
          })(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading...");
            }
            print("X");

            return Text(snapshot.data!);
          },
        ),
      ),
    );
  }
}
