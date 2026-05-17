import 'package:cactus/cactus.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/cactus_inferrer.dart';
import 'package:lista_de_la_compra/AI/AI_models/ai_model.dart';

class CactusModel extends AIModel {
  String modelDownloadSlug;
  bool currentlyDownloadingFlag = false;

  CactusModel({
    required super.name,
    required super.notes,
    required super.id,
    required super.sizeGb,
    required super.modelInfoUrl,
    required this.modelDownloadSlug,
  });

  @override
  bool isDeleteAviable() {
    return false;
  }

  @override
  Future<void> delete() {
    throw UnimplementedError();
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
  Future<dynamic> syncDownload() async {
    await CactusLM().downloadModel(model: modelDownloadSlug);
  }

  @override
  Future<bool> currentlyDownloading() async {
    return currentlyDownloadingFlag;
  }
}
