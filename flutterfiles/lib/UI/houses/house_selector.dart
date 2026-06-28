import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:lista_de_la_compra/shared_preference_providers/persistent_selected_houses_provider.dart';
import 'package:provider/provider.dart';
import '../../flutter_providers/flutter_providers.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

class HouseSelector extends StatelessWidget {
  final String enviromentId;

  const HouseSelector({super.key, required this.enviromentId});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    final HouseProvider houseProvider = context.watch<FlutterHouseProvider>();
    final selectedHousesProvider = context.watch<PersistentSelectedHousesProvider>();

    return FutureBuilder<List<House>>(
      future: houseProvider.getHouseList(enviromentId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }

        var allHouses = snapshot.data!;
        if (allHouses.isEmpty) {
          return SizedBox.shrink();
        }

        return FutureBuilder<List<String>>(
          future: selectedHousesProvider.getSelectedHouses(enviromentId),
          builder: (context, housesSnapshot) {
            final selectedHouseIds = housesSnapshot.data ?? [];

            return Tooltip(
              message: appLoc.selectHouses,
              child: ElevatedButton.icon(
                icon: Icon(Icons.home),
                label: Text('${selectedHouseIds.length}'),
                onPressed: () => _showHouseSelectionDialog(context, allHouses, appLoc, selectedHouseIds.toSet()),
              ),
            );
          },
        );
      },
    );
  }

  void _showHouseSelectionDialog(BuildContext context, List<House> allHouses, AppLocalizations appLoc, Set<String> selectedSet) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(appLoc.selectHouses),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: allHouses.map((house) {
                    final houseColor = Color(house.color);
                    return CheckboxListTile(
                      secondary: CircleAvatar(
                        backgroundColor: houseColor,
                        radius: 14,
                        child: Icon(Icons.home, size: 16, color: Colors.white),
                      ),
                      title: Text(house.name),
                      value: selectedSet.contains(house.id),
                      activeColor: houseColor,
                      onChanged: (checked) {
                        setDialogState(() {
                          if (checked == true) {
                            selectedSet.add(house.id);
                          } else {
                            selectedSet.remove(house.id);
                          }
                          context.read<PersistentSelectedHousesProvider>().setSelectedHouses(enviromentId, selectedSet.toList());
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context.read<PersistentSelectedHousesProvider>().setSelectedHouses(enviromentId, selectedSet.toList());
                    Navigator.of(context).pop();
                  },
                  child: Text(appLoc.save),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
