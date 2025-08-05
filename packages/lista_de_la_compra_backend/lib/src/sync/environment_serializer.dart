
import '../db/database.dart';
import '../db_providers/environment_provider.dart';
import '../db_providers/product_provider.dart';
import '../db_providers/recipe_provider.dart';
import '../db_providers/schedule_provider.dart';

Future<Map<String, dynamic>> serializeEnvironment(
  String enviromentId,
  EnvironmentProvider environmentProvider,
  ProductProvider productProvider,
  RecipeProvider recipeProvider,
  ScheduleProvider scheduleProvider,
) async {
  Environment environment = (await environmentProvider.getEnvironmentById(enviromentId))!;

  return {
    "environment": environment,
    "products": await productProvider.getSyncProductList(enviromentId),
    "recipes": await recipeProvider.getSyncRecipeList(enviromentId),
    "products_recipies": await recipeProvider.getSyncRecipeProductList(enviromentId),
    "schedule": await scheduleProvider.getSyncEntryList(enviromentId),
  };
}

Future<void> syncItems(
  List<dynamic> otherItems,
  List<dynamic> selfItems,
  Function(String, Map<String, dynamic>) syncOverideCallback,
  Function(String, int) syncSetDeletedCallback,
  Function(Map<String, dynamic>) syncAddProductCallback,
) async {
  for (var otherItem in otherItems) {
    var found = false;
    for (var selfItem in selfItems) {
      if (selfItem.id == otherItem["id"]) {
        found = true;

        if (selfItem.deletedAt == null && otherItem["deletedAt"] == null) {
          if (selfItem.updatedAt < otherItem["updatedAt"]) {
            print("Override: ${selfItem.toString()}");
            syncOverideCallback(selfItem.id, otherItem);
          }
        }

        if (otherItem["deletedAt"] != null) {
          if (selfItem.deletedAt == null || selfItem.deletedAt > otherItem["deletedAt"]) {
            print("Deleted: ${selfItem.toString()}");
            syncSetDeletedCallback(selfItem.id, otherItem["deletedAt"]);
          }
        }
      }
    }

    if (!found) {
      print("Added: ${otherItem.toString()}");
      syncAddProductCallback(otherItem);
    }
  }
}

Future<void> recieveState(
  Map<String, dynamic> state,
  EnvironmentProvider environmentProvider,
  ProductProvider productProvider,
  RecipeProvider recipeProvider,
  ScheduleProvider scheduleProvider,
) async {
  Environment remoteEnvironment = Environment.fromJson(state["environment"]);
  Environment? currentEnvironment = await environmentProvider.getEnvironmentById(remoteEnvironment.id);
  if (currentEnvironment == null) {
    return;
  }

  if (currentEnvironment.updatedAt < remoteEnvironment.updatedAt) {
    if (currentEnvironment.name != remoteEnvironment.name) {
      environmentProvider.setName(currentEnvironment.id, remoteEnvironment.name);
    }
  }

  List<dynamic> otherProducts = state["products"]!;
  List<dynamic> otherRecipes = state["recipes"]!;
  List<dynamic> otherProductsRecipies = state["products_recipies"]!;
  List<dynamic> otherSchedule = state["schedule"]!;

  var selfProducts = productProvider.getSyncProductList(remoteEnvironment.id);
  var selfRecipes = recipeProvider.getSyncRecipeList(remoteEnvironment.id);
  var selfProductsRecipes = recipeProvider.getSyncRecipeProductList(remoteEnvironment.id);
  var selfSchedule = scheduleProvider.getSyncEntryList(remoteEnvironment.id);

  await syncItems(
    otherProducts,
    await selfProducts,
    (id, item) => productProvider.syncOveride(id, item),
    (id, deletedAt) => productProvider.syncSetDeleted(id, deletedAt),
    (item) => productProvider.syncAddProduct(item),
  );

  await syncItems(
    otherRecipes,
    await selfRecipes,
    (id, item) => recipeProvider.syncOverideRecipe(id, item),
    (id, deletedAt) => recipeProvider.syncSetDeletedRecipe(id, deletedAt),
    (item) => recipeProvider.syncAddRecipe(item),
  );

  await syncItems(
    otherProductsRecipies,
    await selfProductsRecipes,
    (id, item) => recipeProvider.syncOverideRecipeProduct(id, item),
    (id, deletedAt) => recipeProvider.syncSetDeletedRecipeProduct(id, deletedAt),
    (item) => recipeProvider.syncAddRecipeProduct(item),
  );

  await syncItems(
    otherSchedule,
    await selfSchedule,
    (id, item) => scheduleProvider.syncOveride(id, item),
    (id, deletedAt) => scheduleProvider.syncSetDeleted(id, deletedAt),
    (item) => scheduleProvider.syncAddEntry(item),
  );
}
