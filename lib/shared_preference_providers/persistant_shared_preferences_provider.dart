import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

class PersistantSharedPreferencesProvider extends SharedPreferencesProvider with ChangeNotifier {
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
  Future<void> setSelectedEnvironment(String enviromentId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedEnvironment", enviromentId);
    notifyListeners();
  }

  @override
  Future<void> clearSelectedEnvironment() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("selectedEnvironment");
    notifyListeners();
  }

  @override
  Future<String?> getSelectedEnvironment() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("selectedEnvironment");
  }

  @override
  Future<void> setSelectedSupermarket(String enviromentId, String supermarketId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedSupermarket_$enviromentId", supermarketId);
    notifyListeners();
  }

  @override
  Future<void> clearSelectedSupermarket(String enviromentId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("selectedSupermarket_$enviromentId");
    notifyListeners();
  }

  @override
  Future<String?> getSelectedSupermarket(String enviromentId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("selectedSupermarket_$enviromentId");
  }
}
