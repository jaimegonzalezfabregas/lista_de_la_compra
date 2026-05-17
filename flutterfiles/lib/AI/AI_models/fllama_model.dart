import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';
import 'package:lista_de_la_compra/AI/AI_Inferers/fllama_inferrer.dart';
import 'package:lista_de_la_compra/AI/AI_models/ai_model.dart';

import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

class FllamaModel extends AIModel {
  late final Uri modelDownloadUrl;

  String? documentPath;

  Future<String> getBasePath() async {
    return documentPath ?? (await getApplicationDocumentsDirectory()).path;
  }

  List<Completer> onFinishDownloadCompleters = [];

  FllamaModel({
    required super.name,
    required super.notes,
    required super.id,
    required super.sizeGb,
    required this.modelDownloadUrl,
    required super.modelInfoUrl,
  }) {
    attachDownloadTaskToStream();
  }
  @override
  Future<bool> currentlyDownloading() async {
    return await FileDownloader().taskForId(id) != null;
  }

  @override
  Future<bool> alreadyDownloaded() async {
    return await io.File(await getPath()).exists();
  }

  @override
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
        stateStream.add(DownloadProgress(progress.progress, progress.timeRemaining));
      },
    );

    FileDownloader().start();
  }

  @override
  void stopDownload() async {
    FileDownloader().cancelTaskWithId(id);
    stateStream.add(NotDownloaded());
    for (var completer in onFinishDownloadCompleters) {
      completer.complete(true);
    }
    onFinishDownloadCompleters = [];
  }

  @override
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
    final fileDir = await getBasePath();

    return '$fileDir/ai_models/$id.gguf';
  }

  Future<String> getTmpPath() async {
    final fileDir = await getBasePath();

    return '$fileDir/ai_models/.tmp_$id.gguf';
  }

  Future syncDownload() async {
    File file = File(await getPath());

    if (await file.exists()) {
      print("${file.path} was already downloaded");
      return;
    }

    final request = await HttpClient().getUrl(modelDownloadUrl);
    final response = await request.close();

    final totalBytes = response.contentLength;
    int downloadedBytes = 0;
    int nextPrintPercent = 0;

    final sink = file.openWrite();

    await for (final chunk in response) {
      sink.add(chunk);
      downloadedBytes += chunk.length;

      if (totalBytes > 0) {
        final percent = (downloadedBytes / totalBytes * 100).floor();

        if (percent >= nextPrintPercent) {
          print('Download progress for ${file.path}: $nextPrintPercent%');
          nextPrintPercent += 10;
        }
      }
    }

    await sink.close();
    print('Download complete.');
  }


  @override
  Future<void> delete() async {
    final file = io.File(await getPath());

    if (!file.existsSync()) {
      throw "This model is not donwloaded";
    }

    await file.delete();

    stateStream.add(NotDownloaded());
  }

  @override
  bool isStopAviable() {
    return true;
  }

  @override
  bool isDeleteAviable() {
    return true;
  }
}
