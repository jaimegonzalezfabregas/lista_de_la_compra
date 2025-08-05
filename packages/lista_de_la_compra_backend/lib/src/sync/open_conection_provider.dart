import '../../lista_de_la_compra_backend.dart';
import 'package:uuid/uuid.dart';

class RamOpenConnectionProvider extends OpenConnectionProvider with VoidEventSourceMixin {}

abstract class OpenConnectionProvider  implements VoidEventSource{
  final Map<String, OpenConnection> _openConnections = {};


  Map<String, OpenConnection> get openConnections => _openConnections;

  String addOpenConnection(
    String terminalId,
    String? connectionSourceId,
    String nick,
    Function triggerSyncPull,
    Function triggerSyncPush,
    Function triggerHandshakePush,
    Function abortConnection,
    List<Enviroment> enviromentList,
    String userNote,
  ) {
    String id = Uuid().v7();
    _openConnections[id] = OpenConnection(
      id,
      connectionSourceId,
      terminalId,
      nick,
      triggerSyncPull,
      triggerSyncPush,
      triggerHandshakePush,
      abortConnection,
      enviromentList,
      userNote,
    );

  


    notifyListeners();
    return id;
  }

  void removeOpenConnection(String id) {
    final connection = _openConnections[id];
    connection?.abortConnection();

    if (connection != null) {
      _openConnections.remove(id);
      notifyListeners();
    }
  }

  void setLatency(String id, num latency) {
    _openConnections[id]!.latency = latency;
    notifyListeners();
  }

  void setNick(String id, String nick) {
    _openConnections[id]!.nick = nick;
    notifyListeners();
  }

  void closeByConnectionSource(String srcId) {
    _openConnections.values.where((c) => c.connectionSourceId == srcId).map((c) => c.id).toList().forEach((connId) {
      removeOpenConnection(connId);
    });
  }

  bool anyOpenConnectionOfSource(String srcId) {
    return _openConnections.values.any((c) => c.connectionSourceId == srcId);
  }
}
