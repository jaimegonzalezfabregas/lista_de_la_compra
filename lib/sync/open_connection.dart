
import 'package:lista_de_la_compra/db/database.dart';

class OpenConnection {
  final String terminalId;
  String nick;
  final Function cascadeTriggerSyncPull;
  final Function cascadeTriggerSyncPush;
  final Function cascadeTriggerHandshakePush;
  final Function cascadeAbortConnection;
  final List<Enviroment> enviromentList;

  num? latency;

  OpenConnection(
    this.terminalId,
    this.nick,
    this.cascadeTriggerSyncPull,
    this.cascadeTriggerSyncPush,
    this.cascadeTriggerHandshakePush,
    this.cascadeAbortConnection,
    this.enviromentList,
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
