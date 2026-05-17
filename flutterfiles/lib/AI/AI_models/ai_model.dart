import 'dart:async';

import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';

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

  StreamController<DownloadEvent> stateStream = StreamController.broadcast();

  AIModel({required this.name, required this.notes, required this.id, required this.sizeGb, required this.modelInfoUrl}) {
    refreshStatus();
  }

  Future<Inferrer> getInferencer(List<Jtool> tools);

  void startDownload();
  Future syncDownload();

  bool isStopAviable();
  void stopDownload();

  bool isDeleteAviable();
  Future<void> delete();

  Future<bool> currentlyDownloading();
  Future<bool> alreadyDownloaded();

  void refreshStatus() async {
    print("refreshing status of $name");
    if (await currentlyDownloading()) {
      return stateStream.add(JustASecond());
    }

    return stateStream.add(await alreadyDownloaded() ? ReadyToUse() : NotDownloaded());
  }
}
