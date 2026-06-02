import 'dart:io';

import 'package:cactus/cactus.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/cactus_inferrer.dart';
import 'package:lista_de_la_compra/AI/AI_models/ai_model.dart';

class JcactusModel extends AIModel {
  String modelDownloadSlug;
  bool currentlyDownloadingFlag = false;

  JcactusModel({
    required super.name,
    required super.notes,
    required super.id,
    required super.sizeGb,
    required super.modelInfoUrl,
    required this.modelDownloadSlug,
  });

  static JcactusModel? fromCactusModel(CactusModel cm) {
    CactusConfig.isTelemetryEnabled = false;
    
    if (cm.supportsToolCalling) {
      return JcactusModel(
        name: cm.name,
        notes: "Cactus powered model",
        id: "cactus_${cm.slug}",
        sizeGb: cm.sizeMb / 1000,
        modelInfoUrl: Uri.parse("https://pub.dev/packages/cactus"),
        modelDownloadSlug: cm.slug,
      );
    }
    return null;
  }

  @override
  bool isDeleteAviable() {
    return true;
  }

  Future<String> getPath() async {
    final fileDir = await getBasePath();

    return '$fileDir/models/$modelDownloadSlug';
  }

  @override
  Future<void> delete() async {
    await Directory(await getPath()).delete(recursive: true);
    super.stateStream.add(NotDownloaded());
  }

  @override
  Future<Inferrer> getInferencer(List<Jtool> tools) async {
    return CactusInferrer(tools, modelDownloadSlug);
  }

  @override
  Future<bool> alreadyDownloaded() async {
    final models = (await CactusLM().getModels());
    for (final model in models) {
      if (model.slug == modelDownloadSlug) {
        return model.isDownloaded;
      }
    }

    return false;
  }

  @override
  void startDownload() {
    currentlyDownloadingFlag = true;
    DateTime startTime = DateTime.timestamp();
    CactusLM().downloadModel(
      model: modelDownloadSlug,
      downloadProcessCallback: (progress, statusMessage, isError) {
        if (isError) {
          currentlyDownloadingFlag = false;
          super.stateStream.add(NotDownloaded());
        }

        if (progress != null) {
          if (progress == 0) {
            super.stateStream.add(JustASecond());
          } else if (progress == 1) {
            currentlyDownloadingFlag = false;
            super.stateStream.add(ReadyToUse());
          } else {
            int msElapsed = (DateTime.timestamp().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch);

            double estimation = (msElapsed.toDouble() / progress) * (1 - progress);

            super.stateStream.add(DownloadProgress(progress, Duration(milliseconds: estimation.floor())));
          }
        } else {
          super.stateStream.add(JustASecond());
        }
      },
    );
  }

  @override
  bool isStopAviable() {
    return false;
  }

  @override
  void stopDownload() {
    throw UnimplementedError();
  }

  @override
  Future<bool> syncDownload() async {
    try {
      await CactusLM().downloadModel(model: modelDownloadSlug);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> currentlyDownloading() async {
    return currentlyDownloadingFlag;
  }
}
