import 'package:flutter/material.dart';
import 'package:lista_de_la_compra_backend/src/db/database.dart';
import 'package:lista_de_la_compra_backend/src/db_providers/schedule_provider.dart';

Widget? getNeededAmount(ScheduleProvider scheduleProvider, String productId) {
  var amountFuture = scheduleProvider.getFutureRecipesWithProduct(productId);
  return FutureBuilder(
    future: amountFuture,
    builder: (context, amountSnapshot) {
      if (!amountSnapshot.hasData) {
        return Text("Cargando...");
      }

      List<RecipeProduct> recipes = amountSnapshot.data!;

      if (recipes.isEmpty) {
        return SizedBox.shrink();
      }

      var amounts = recipes.map((recipe) => recipe.amount).join(" + ");

      return Text(amounts);
    },
  );
}
