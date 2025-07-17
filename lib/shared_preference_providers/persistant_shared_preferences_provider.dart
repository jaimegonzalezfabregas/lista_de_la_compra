import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import 'package:lista_de_la_compra_http_server/src/shared_preferences_providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PersistantSharedPreferencesProvider extends SharedPreferencesProvider with ChangeNotifier{
  BuildContext? context;

  PersistantSharedPreferencesProvider(this.context);

  @override
  Future<String> getTerminalId() async {
    final prefs = await SharedPreferences.getInstance();
    var ret = prefs.getString('TerminalId');
    if (ret == null) {
      ret = Uuid().v7();
      await prefs.setString('TerminalId', ret);
    }
    return ret;
  }

  @override
  Future<String> getLocalNick() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceNames = DeviceMarketingNames();

    var storedName = prefs.getString('LocalNick');
    if (storedName != null) {
      return storedName;
    } else {
      try {
        return await deviceNames.getSingleName();
      } catch (e) {
        var nonLocalizedName = "unnamed-device";
        if (context != null && context!.mounted) {
          return AppLocalizations.of(context!)?.fallbackLocalNick ?? nonLocalizedName;
        } else {
          return nonLocalizedName;
        }
      }
    }
  }

  @override
  Future<void> setLocalNick(String nick) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('LocalNick', nick);

    notifyListeners();
  }

  @override
  Future<void> setSelectedEnviroment(String enviromentId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedEnviroment", enviromentId);
    notifyListeners();
  }

  @override
  Future<void> clearSelectedEnviroment() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("selectedEnviroment");
    notifyListeners();
  }

  @override
  Future<String?> getSelectedEnviroment() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("selectedEnviroment");
  }
}
