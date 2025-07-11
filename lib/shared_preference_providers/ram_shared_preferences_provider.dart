import 'package:lista_de_la_compra/shared_preference_providers/shared_preferences_provider.dart';

class RamSharedPreferencesProvider extends SharedPreferencesProvider {
  @override
  Future<void> clearSelectedEnviroment() {
    throw UnimplementedError();
  }

  @override
  Future<String> getLocalNick() async {
    return "Server"; // TODO configurable
  }

  @override
  Future<String?> getSelectedEnviroment() {
    throw UnimplementedError();
  }

  @override
  Future<String> getTerminalId() async {
    return "unique_id"; // TODO fix
  }

  @override
  Future<void> setLocalNick(String nick) {
    throw UnimplementedError();
  }

  @override
  Future<void> setSelectedEnviroment(String enviromentId) {
    throw UnimplementedError();
  }
}