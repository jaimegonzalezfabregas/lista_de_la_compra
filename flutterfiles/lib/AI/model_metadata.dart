import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/fllama_inferer.dart';

import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

abstract class DownloadEvent {}

class JustASecond extends DownloadEvent {}

class ReadyToUse extends DownloadEvent {}

class NotDownloaded extends DownloadEvent {}

class TaskProgressUpdateWrapper extends DownloadEvent {
  TaskProgressUpdate update;

  TaskProgressUpdateWrapper(this.update);
}

class ModelMetadata {
  late final String name;
  late final String notes;
  late final String id;
  late final double sizeGb;
  late final Uri modelInfoUrl;
  late final Uri modelDownloadUrl;

  List<Completer> onFinishDownloadCompleters = [];

  late StreamController<DownloadEvent> stateStream = StreamController();

  ModelMetadata({
    required this.name,
    required this.notes,
    required this.id,
    required this.modelDownloadUrl,
    required this.sizeGb,
    required this.modelInfoUrl,
  }) {
    firstStatus();
    attachDownloadTaskToStream();
  }

  void firstStatus() async {
    if (await FileDownloader().taskForId(id) != null) {
      return stateStream.add(JustASecond());
    }

    return stateStream.add(await io.File(await getPath()).exists() ? ReadyToUse() : NotDownloaded());
  }

  Future<Inferrer> getInferencer(List<Jtool> tools) async {
    return FllamaInferrer(await getPath(), tools);
  }

  void attachDownloadTaskToStream() async {
    FileDownloader().registerCallbacks(
      group: id,
      taskStatusCallback: (status) async {
        switch (status.status) {
          case TaskStatus.enqueued:
          case TaskStatus.running:
            break;
          case TaskStatus.notFound:
          case TaskStatus.failed:
          case TaskStatus.canceled:
            stateStream.add(NotDownloaded());
            for (var completer in onFinishDownloadCompleters) {
              completer.complete(true);
            }
            onFinishDownloadCompleters = [];

            break;
          case TaskStatus.waitingToRetry:
            stateStream.add(JustASecond());
            break;
          case TaskStatus.paused:
            stateStream.add(NotDownloaded());
            break;
          case TaskStatus.complete:
            io.File(await getTmpPath()).rename(await getPath());
            stateStream.add(ReadyToUse());

            for (var completer in onFinishDownloadCompleters) {
              completer.complete(true);
            }
            onFinishDownloadCompleters = [];
        }
      },
      taskProgressCallback: (progress) {
        stateStream.add(TaskProgressUpdateWrapper(progress));
      },
    );

    FileDownloader().start();
  }

  void stopDownload() async {
    FileDownloader().cancelTaskWithId(id);
    stateStream.add(NotDownloaded());
    for (var completer in onFinishDownloadCompleters) {
      completer.complete(true);
    }
    onFinishDownloadCompleters = [];
  }

  void startDownload() async {
    var test = await FileDownloader().taskForId(id);
    if (test != null) {
      print("download of $id is ongoing already($test)");
      return;
    }

    DownloadTask task = DownloadTask(
      taskId: id,
      group: id,
      url: modelDownloadUrl.toString(),
      filename: '.tmp_$id.gguf',
      directory: "ai_models",
      updates: Updates.statusAndProgress, // request status and progress updates
      retries: 5,
      allowPause: true,
    );

    FileDownloader().enqueue(task);
    stateStream.add(JustASecond());
  }

  Future<String> getPath() async {
    final fileDir = (await getApplicationDocumentsDirectory()).path;

    return '$fileDir/ai_models/$id.gguf';
  }

  Future<String> getTmpPath() async {
    final fileDir = (await getApplicationDocumentsDirectory()).path;

    return '$fileDir/ai_models/.tmp_$id.gguf';
  }

  Future syncDownload() async {
    File file = File(await getPath());

    if (await file.exists()) {
      return;
    }

    final request = await HttpClient().getUrl(modelDownloadUrl);
    final response = await request.close();
    response.pipe(File(await getPath()).openWrite());
  }

  void delete() async {
    final file = io.File(await getPath());

    if (!file.existsSync()) {
      throw "This model is not donwloaded";
    }

    await file.delete();

    stateStream.add(NotDownloaded());
  }
}
