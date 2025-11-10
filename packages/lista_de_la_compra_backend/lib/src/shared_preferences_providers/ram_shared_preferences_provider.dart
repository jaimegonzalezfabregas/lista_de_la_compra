import 'package:uuid/uuid.dart';

import '../../lista_de_la_compra_backend.dart';

class RamSharedPreferencesProvider extends SharedPreferencesProvider with VoidEventSourceMixin {
  String terminalId = Uuid().v7();

  @override
  Future<String> getLocalNick() async {
    return "Server"; // TODO make configurable
  }

  @override
  Future<String> getTerminalId() async {
    return terminalId;
  }

  @override
  Future<void> clearSelectedEnvironment() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getSelectedEnvironment() {
    throw UnimplementedError();
  }

  @override
  Future<void> setLocalNick(String nick) {
    throw UnimplementedError();
  }

  @override
  Future<void> setSelectedEnvironment(String enviromentId) {
    throw UnimplementedError();
  }

  @override
  Future<void> clearSelectedSupermarket(String enviromentId) {
    throw UnimplementedError();
  }

  @override
  Future<String?> getSelectedSupermarket(String enviromentId) {
    throw UnimplementedError();
  }

  @override
  Future<void> setSelectedSupermarket(String enviromentId, String supermarketId) {
    throw UnimplementedError();
  }
}
