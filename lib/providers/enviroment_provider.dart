import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';

class EnviromentProvider extends ChangeNotifier {

  Future<Enviroment?> getProductById(String id) async {
    final database = AppDatabaseSingleton.instance;

    return await (database.select(database.enviroments)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
  }

 
}
