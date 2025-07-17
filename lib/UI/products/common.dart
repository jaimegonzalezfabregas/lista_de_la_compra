import 'package:flutter/material.dart';
import '../../../packages/lista_de_la_compra_backend/lib/src/db/database.dart';
import '../../../packages/lista_de_la_compra_backend/lib/src/db_providers/schedule_provider.dart';

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
