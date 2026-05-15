import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as root_bundle;
import 'package:lista_de_la_compra/AI/model_catalog.dart';
import 'dart:convert';

import 'package:lista_de_la_compra/UI/AI/ai_chat.dart';

import 'dart:io' as io;

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class JustASecond {}

class ReadyToUse {}

class NotDownloaded {}

class ModelMetadata {
  late final String name;
  late final String notes;
  late final String id;
  late final String modelDownloadUrl;
  late final double sizeGb;
  late final Uri modelInfoUrl;

  List<Completer> onFinishDownloadCompleters = [];

  late StreamController<dynamic> stateStream;

  ModelMetadata(Map<String, dynamic> seed) {
    name = seed["name"];
    notes = seed["notes"];
    id = seed["id"];
    modelDownloadUrl = seed["model_download_url"];
    sizeGb = seed["size_gb"];
    modelInfoUrl = Uri.parse(seed["model_info_url"]);

    stateStream = StreamController();

    firstStatus();
    attachDownloadTaskToStream();
  }

  void firstStatus() async {
    if (await FileDownloader().taskForId(id) != null) {
      return stateStream.add(JustASecond());
    }

    return stateStream.add(await io.File(await getPath()).exists() ? ReadyToUse() : NotDownloaded());
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
        stateStream.add(progress);
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
      url: modelDownloadUrl,
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

  Future waitUntilDownloaded() async {
    print("a");

    var test = await FileDownloader().taskForId(id);
    print("b");
    if (test != null) {
      Completer c = Completer();

      onFinishDownloadCompleters.add(c);

      await c.future;
    }
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
