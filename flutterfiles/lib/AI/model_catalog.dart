import 'dart:io';

import 'package:cactus/cactus.dart';
import 'package:flutter/widgets.dart';
import 'package:lista_de_la_compra/AI/AI_models/ai_model.dart';
import 'package:lista_de_la_compra/AI/AI_models/cactus_model.dart';
import 'package:lista_de_la_compra/AI/AI_models/fllama_model.dart';

import 'dart:async';

import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';
import 'package:lista_de_la_compra/AI/ai_tools.dart';
import 'package:lista_de_la_compra/UI/AI/ai_chat.dart';

List<JfllamaModel> fLlamaCatalog = [
  JfllamaModel(
    name: "Qwen 3.5 4B IQ2 M",
    id: "Qwen_Qwen3.5-4B-IQ2_M",
    modelDownloadUrl: Uri.parse("https://huggingface.co/bartowski/Qwen_Qwen3.5-4B-GGUF/resolve/main/Qwen_Qwen3.5-4B-IQ2_M.gguf?download=true"),
    modelInfoUrl: Uri.parse("https://huggingface.co/bartowski/Qwen_Qwen3.5-4B-GGUF"),
    sizeGb: 1.7,
    notes: "Relatively low quality, uses SOTA techniques to be surprisingly usable.",
  ),

  // JfllamaModel(
  //   name: "Qwen 3.5 4B bf16",
  //   id: "Qwen_Qwen3.5-4B-bf16",
  //   modelDownloadUrl: Uri.parse("https://huggingface.co/bartowski/Qwen_Qwen3.5-4B-GGUF/resolve/main/Qwen_Qwen3.5-4B-bf16.gguf?download=true"),
  //   modelInfoUrl: Uri.parse("https://huggingface.co/bartowski/Qwen_Qwen3.5-4B-GGUF"),
  //   sizeGb: 3.9,
  //   notes: "Full BF16 weights.",
  // ),

  // JfllamaModel(
  //   name: "Mistral Nemo 12B",
  //   id: "mistral-nemo-12b",
  //   modelDownloadUrl: Uri.parse(
  //     "https://huggingface.co/bartowski/Mistral-Nemo-Instruct-2407-GGUF/resolve/main/Mistral-Nemo-Instruct-2407-Q4_K_M.gguf?download=true",
  //   ),
  //   modelInfoUrl: Uri.parse("https://huggingface.co/bartowski/Mistral-Nemo-Instruct-2407-GGUF"),
  //   sizeGb: 7.5,
  //   notes:
  //       "92.5% in J.D. Hodges eval, 67% NexusRaven (complex API understanding). Best multi-turn sequential model — correctly identifies when to wait for results. Weakness: paraphrases arguments and sometimes over-helps. Low BFCL (49%) is due to Ollama template issues, not model quality. Mistral Nemo format.",
  // ),

  // JfllamaModel(
  //   name: "Qwen3.5 9B",
  //   id: "qwen3.5-9b",
  //   modelDownloadUrl: Uri.parse("https://huggingface.co/bartowski/Qwen_Qwen3.5-9B-GGUF/resolve/main/Qwen_Qwen3.5-9B-Q3_K_L.gguf?download=true"),
  //   modelInfoUrl: Uri.parse("https://huggingface.co/bartowski/Qwen_Qwen3.5-9B-GGUF"),
  //   sizeGb: 5.0,
  //   notes:
  //       "Best composite score across 3 benchmarks: 64% BFCL, 77% NexusRaven (best API understanding of all small models), 45% AgentBench (best multi-step agentic). Strongest at understanding complex API semantics. Hermes/Qwen format. Slightly slower than 4B variant.",
  // ),
  JfllamaModel(
    name: "Tiny Agent a 0.5B K M",
    id: "Tiny-Agent-a-0.5B",
    modelDownloadUrl: Uri.parse("https://huggingface.co/driaforall/Tiny-Agent-a-0.5B/resolve/main/dria-agent-a-0.5b.Q4_K_M.gguf?download=true"),
    modelInfoUrl: Uri.parse("https://huggingface.co/driaforall/Tiny-Agent-a-0.5B"),
    sizeGb: 0.5,
    notes:
        "Tiny-Agent-α is an extension of Dria-Agent-a, trained on top of the Qwen2.5-Coder series to be used in edge devices. These models are carefully fine tuned with quantization aware training to minimize performance degradation after quantization.",
  ),

  JfllamaModel(
    name: "Qwen 3 0.6B Q2 K",
    id: "Qwen3-0.6B-Q2_K",
    modelDownloadUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q2_K.gguf?download=true"),
    modelInfoUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF"),
    sizeGb: 0.347,
    notes: "Very low quality, smallest and fastest option. Suitable for highly constrained devices.",
  ),

  // JfllamaModel(
  //   name: "Qwen 3 0.6B Q3 K S",
  //   id: "Qwen3-0.6B-Q3_K_S",
  //   modelDownloadUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q3_K_S.gguf?download=true"),
  //   modelInfoUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF"),
  //   sizeGb: 0.390,
  //   notes: "Low quality, compact quantization for minimal RAM usage.",
  // ),

  // JfllamaModel(
  //   name: "Qwen 3 0.6B Q3 K M",
  //   id: "Qwen3-0.6B-Q3_K_M",
  //   modelDownloadUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q3_K_M.gguf?download=true"),
  //   modelInfoUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF"),
  //   sizeGb: 0.406,
  //   notes: "Balanced low-memory option with slightly better quality than Q3_K_S.",
  // ),
  JfllamaModel(
    name: "Qwen 3 0.6B Q3 K L",
    id: "Qwen3-0.6B-Q3_K_L",
    modelDownloadUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q3_K_L.gguf?download=true"),
    modelInfoUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF"),
    sizeGb: 0.435,
    notes: "Largest Q3 quantization, better quality while still lightweight.",
  ),

  JfllamaModel(
    name: "Qwen 3 0.6B Q4 0",
    id: "Qwen3-0.6B-Q4_0",
    modelDownloadUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q4_0.gguf?download=true"),
    modelInfoUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF"),
    sizeGb: 0.469,
    notes: "Classic Q4 quantization, good general-purpose option.",
  ),

  // JfllamaModel(
  //   name: "Qwen 3 0.6B Q4 K S",
  //   id: "Qwen3-0.6B-Q4_K_S",
  //   modelDownloadUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q4_K_S.gguf?download=true"),
  //   modelInfoUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF"),
  //   sizeGb: 0.472,
  //   notes: "Good quality, efficient K-quant variant.",
  // ),
  JfllamaModel(
    name: "Qwen 3 0.6B Q4 K M",
    id: "Qwen3-0.6B-Q4_K_M",
    modelDownloadUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q4_K_M.gguf?download=true"),
    modelInfoUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF"),
    sizeGb: 0.484,
    notes: "Recommended default. Best balance of quality, speed, and memory usage.",
  ),

  JfllamaModel(
    name: "Qwen 3 0.6B Q5 0",
    id: "Qwen3-0.6B-Q5_0",
    modelDownloadUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q5_0.gguf?download=true"),
    modelInfoUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF"),
    sizeGb: 0.544,
    notes: "Higher quality than Q4 variants, moderate memory increase.",
  ),

  JfllamaModel(
    name: "Qwen 3 0.6B Q5 K S",
    id: "Qwen3-0.6B-Q5_K_S",
    modelDownloadUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q5_K_S.gguf?download=true"),
    modelInfoUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF"),
    sizeGb: 0.547,
    notes: "Efficient high-quality K-quant.",
  ),

  // JfllamaModel(
  //   name: "Qwen 3 0.6B Q5 K M",
  //   id: "Qwen3-0.6B-Q5_K_M",
  //   modelDownloadUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q5_K_M.gguf?download=true"),
  //   modelInfoUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF"),
  //   sizeGb: 0.551,
  //   notes: "High-quality quantization, recommended if RAM allows.",
  // ),
  JfllamaModel(
    name: "Qwen 3 0.6B Q6 K",
    id: "Qwen3-0.6B-Q6_K",
    modelDownloadUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q6_K.gguf?download=true"),
    modelInfoUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF"),
    sizeGb: 0.623,
    notes: "Very high quality quantized model, close to full precision.",
  ),

  // JfllamaModel(
  //   name: "Qwen 3 0.6B Q8 0",
  //   id: "Qwen3-0.6B-Q8_0",
  //   modelDownloadUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q8_0.gguf?download=true"),
  //   modelInfoUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF"),
  //   sizeGb: 0.805,
  //   notes: "Near-lossless quantization, excellent quality.",
  // ),

  // JfllamaModel(
  //   name: "Qwen 3 0.6B F16",
  //   id: "Qwen3-0.6B-F16",
  //   modelDownloadUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-f16.gguf?download=true"),
  //   modelInfoUrl: Uri.parse("https://huggingface.co/gaianet/Qwen3-0.6B-GGUF"),
  //   sizeGb: 1.51,
  //   notes: "Full FP16 weights. Maximum quality, highest memory usage.",
  // ),
];
List<Jtool> getTestTools() {
  return [
    Jtool(
      name: "GetCity",
      description: "This tool provides information about the city where the user is at",
      jsonSchema: JtoolSchema(requiredProps: [], properties: {}),
      tool: (_) async {
        return "You are in Moscow";
      },
    ),
  ];
}

Future<List<JcactusModel>> getCactusCatalog() async {
  List<CactusModel> catalog = await CactusLM().getModels();
  return catalog.map((e) => JcactusModel.fromCactusModel(e)).whereType<JcactusModel>().toList();
}

List<AIModel>? catalogSingleton;

Future<List<AIModel>> getCatalog() async {
  return await getCactusCatalog();

  catalogSingleton ??= [...fLlamaCatalog, ...(await getCactusCatalog())]; // reactivate after improving the tool call detection
  return catalogSingleton!;
}

Map<String, bool> canUseTools = {
  "cactus_lfm2-350m": false,
  "cactus_lfm2-700m": false,
  "cactus_functiongemma-270m-pro": false, // binary exited with -1
  "cactus_functiongemma-270m": false, // binary exited with -1
  "cactus_qwen3-0.6": false, // but almost
};

Future<void> catalogTest() async {
  WidgetsFlutterBinding.ensureInitialized();

  List<AIModel> catalog = await getCatalog();

  // await Future.wait(
  //   (catalog).map((e) async {
  //     try {
  //       await e.delete();
  //     } catch (e) {}
  //   }),
  // );

  print("CATALOG_TEST_RESULT Starting all downloads");

  StreamIterator<AIModel> catalogDownload = StreamIterator<AIModel>(
    Stream.fromFutures(
      catalog
          .map(
            (model) => (() async {
              while (!await model.syncDownload()) {
                print("retying download for ${model.name}");
              }
              return model;
            })(),
          )
          .toList(),
    ),
  );

  for (int modelI = 0; modelI < catalog.length; modelI++) {
    await catalogDownload.moveNext();
    AIModel model = catalogDownload.current;


    if(canUseTools.containsKey(model.id)){
      continue;
    }
    var startTestTime = DateTime.now().millisecondsSinceEpoch;

    await model.syncDownload();
    print("CATALOG_TEST_RESULT Testing ${model.name}");

    for (int i = 0; i < 4; i++) {
      var tester = await model.getInferencer(getTestTools());
      print("   Inferer created...");
      try {
        var resultStream = await tester.inferResponseToolReady([
          Jmessage(Jrole.system, "You are a helpful guide agent, able to call tools to retrieve information"),
          Jmessage(Jrole.user, "In which city am I?"),
        ]);

        Completer c = Completer();

        resultStream.listen((event) {
          if (event is InferenceEnd) {
            print("CATALOG_TEST_RESULT: ${event.conversation}");
            c.complete(event);
          }
        });
        print("   Waiting for inference...");

        InferenceEnd endState = (await Future.wait([c.future]).timeout(Duration(seconds: 30)))[0];
        print("   Inference done, saving...");

        String lastMessage = endState.conversation.last.text;

        var endTestTime = DateTime.now().millisecondsSinceEpoch;

        print(
          "CATALOG_TEST_RESULT: $i: ${model.id} was able to use tool: ${lastMessage.contains("Moscow")} (test took ${endTestTime - startTestTime} ms)",
        );
      } catch (e) {
        print("CATALOG_TEST_RESULT: $i: ${model.id} thew and exception $e");
      }
      await tester.unload();
    }
  }

  print("exiting");

  exit(0);
}
