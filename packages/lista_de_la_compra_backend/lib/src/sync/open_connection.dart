
import '../db/database.dart';

class OpenConnection {
  final String id;
  final String? connectionSourceId;
  final String terminalId;
  String nick;
  final Function cascadeTriggerSyncPull;
  final Function cascadeTriggerSyncPush;
  final Function cascadeTriggerHandshakePush;
  final Function cascadeAbortConnection;
  final List<Environment> environmentList;
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
    this.environmentList,
    this.userNote,
  );

  void triggerSyncPull() {
    // print("triggering sync pull");
    // print("triggering sync pull with $nick");
    cascadeTriggerSyncPull();
  }

  void triggerSyncPush() {
    // print("triggering sync push");
    // print("triggering sync push with $nick");
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
