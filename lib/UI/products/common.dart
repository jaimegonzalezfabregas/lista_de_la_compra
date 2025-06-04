import 'package:flutter/material.dart';
import 'package:jhopping_list/db/database.dart';
import 'package:jhopping_list/providers/schedule_provider.dart';

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

      var amounts = recipes.map((recipe) => recipe.amount).join(" + r");

      return Text(amounts);
    },
  );
}
