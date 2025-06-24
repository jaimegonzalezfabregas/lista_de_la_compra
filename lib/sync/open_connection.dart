import 'package:lista_de_la_compra/db/database.dart';

class OpenConnection {
  final String id;
  final String? connectionSourceId;
  final String terminalId;
  String nick;
  final Function cascadeTriggerSyncPull;
  final Function cascadeTriggerSyncPush;
  final Function cascadeTriggerHandshakePush;
  final Function cascadeAbortConnection;
  final List<Enviroment> enviromentList;
  final String userNote;

  num? latency;

  OpenConnection(
    this.id,
    this.connectionSourceId,
    this.terminalId,
    this.nick,
    this.cascadeTriggerSyncPull,
    this.cascadeTriggerSyncPush,
    this.cascadeTriggerHandshakePush,
    this.cascadeAbortConnection,
    this.enviromentList,
    this.userNote,
  );

  void triggerSyncPull() {
    // print("triggering sync with $nick");
    cascadeTriggerSyncPull();
  }

  void triggerSyncPush() {
    // print("triggering syncwithme with $nick");
    cascadeTriggerSyncPush();
  }

  void setNick(String nick) {
    this.nick = nick;
  }

  void triggerHandshakePush() {
    cascadeTriggerHandshakePush();
  }

  void abortConnection() {
    cascadeAbortConnection();
  }
}
