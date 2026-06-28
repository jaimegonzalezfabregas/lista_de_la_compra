import 'package:flutter/material.dart';
import 'package:lista_de_la_compra/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../flutter_providers/flutter_providers.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

class HouseManager extends StatelessWidget {
  final String enviromentId;

  const HouseManager(this.enviromentId, {super.key});

  static const _colors = [
    0xFFF44336,
    0xFFE91E63,
    0xFF9C27B0,
    0xFF673AB7,
    0xFF3F51B5,
    0xFF2196F3,
    0xFF03A9F4,
    0xFF00BCD4,
    0xFF009688,
    0xFF4CAF50,
    0xFF8BC34A,
    0xFFCDDC39,
    0xFFFFC107,
    0xFFFF9800,
    0xFFFF5722,
    0xFF795548,
    0xFF607D8B,
  ];

  void showCreateHouseDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    TextEditingController controller = TextEditingController();
    int selectedColor = _colors.first;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(appLoc.createHouse),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: appLoc.name),
                      controller: controller,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return appLoc.theNameCantBeEmpty;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _colors.map((c) {
                        return GestureDetector(
                          onTap: () => setDialogState(() => selectedColor = c),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color(c),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedColor == c
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade400,
                                width: selectedColor == c ? 3 : 1,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(appLoc.cancel),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<FlutterHouseProvider>().addHouse(controller.text.trim(), enviromentId, color: selectedColor);
                      Navigator.of(context).pop();
                    }
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

  void showEditHouseDialog(BuildContext context, HouseProvider houseProvider, House house) {
    final formKey = GlobalKey<FormState>();
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    TextEditingController controller = TextEditingController(text: house.name);
    int selectedColor = house.color;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(appLoc.changeName),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: appLoc.name),
                      controller: controller,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return appLoc.theNameCantBeEmpty;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _colors.map((c) {
                        return GestureDetector(
                          onTap: () => setDialogState(() => selectedColor = c),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color(c),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedColor == c
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade400,
                                width: selectedColor == c ? 3 : 1,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(appLoc.cancel),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      houseProvider.setNameAndColor(house.id, controller.text.trim(), selectedColor);
                      Navigator.of(context).pop();
                    }
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

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLoc = AppLocalizations.of(context)!;
    HouseProvider houseProvider = context.watch<FlutterHouseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.houses),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: FutureBuilder(
        future: houseProvider.getHouseList(enviromentId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text(appLoc.loading));
          }

          var houses = snapshot.data!;

          if (houses.isEmpty) {
            return Center(child: Text(appLoc.thisListHasNoResults));
          }

          return ListView(
            children: houses.map((house) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(house.color),
                  radius: 16,
                  child: Icon(Icons.home, size: 18, color: Colors.white),
                ),
                title: Text(house.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => showEditHouseDialog(context, houseProvider, house),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(appLoc.deleteHouse),
                            content: Text(house.name),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: Text(appLoc.cancel),
                              ),
                              TextButton(
                                onPressed: () {
                                  houseProvider.deleteById(house.id);
                                  Navigator.of(ctx).pop();
                                },
                                child: Text(appLoc.delete),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateHouseDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
