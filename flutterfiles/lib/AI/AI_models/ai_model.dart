import 'dart:async';

import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';
import 'package:path_provider/path_provider.dart';

abstract class DownloadEvent {}

class JustASecond extends DownloadEvent {}

class ReadyToUse extends DownloadEvent {}

class NotDownloaded extends DownloadEvent {}

class DownloadProgress extends DownloadEvent {
  final double progress;

  final Duration timeRemaining;

  DownloadProgress(this.progress, this.timeRemaining);
}

abstract class AIModel {
  final String name;
  final String notes;
  final String id;
  final double sizeGb;
  final Uri modelInfoUrl;

  String? documentPath;

  StreamController<DownloadEvent> stateStream = StreamController.broadcast();

  AIModel({required this.name, required this.notes, required this.id, required this.sizeGb, required this.modelInfoUrl}) {
    refreshStatus();
  }

  Future<String> getBasePath() async {
    return documentPath ?? (await getApplicationDocumentsDirectory()).path;
  }

  Future<Inferrer> getInferencer(List<Jtool> tools);

  void startDownload();
  Future<bool> syncDownload();

  bool isStopAviable();
  void stopDownload();

  bool isDeleteAviable();
  Future<void> delete();

  Future<bool> currentlyDownloading();
  Future<bool> alreadyDownloaded();

  void refreshStatus() async {
    if (await currentlyDownloading()) {
      return stateStream.add(JustASecond());
    }

    return stateStream.add(await alreadyDownloaded() ? ReadyToUse() : NotDownloaded());
  }
}
