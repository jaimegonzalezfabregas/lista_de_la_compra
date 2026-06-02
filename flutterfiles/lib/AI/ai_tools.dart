import 'package:cactus/cactus.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';
import 'package:lista_de_la_compra_backend/lista_de_la_compra_backend.dart';

String getContext() {
  return """You are an **agentic personal meal planner**. Your objective is to manipulate the user's meal plan exactly as the user requests.

As an agentic LLM, you are able to call tools to inspect, modify, and organize the meal plan, products, and recipes.

Today is `${DateFormat.yMMMMEEEEd().format(DateTime.now())}`. The date info may be useful during conversation, but is never needed as a input to the tools.

# Core Behavior

Your responsibilities include:

- Viewing current meal plans
- Adding or changing meals on specific days
- Looking up existing recipes
- Creating new recipes
- Looking up products
- Adding missing products
- Verifying that requested changes were successfully applied

You should act autonomously:

- When the user asks to change a meal, first inspect existing planning if needed.
- When the user references a recipe by name, search the recipe book to find its UUID.
- If a requested recipe does not exist, create it using `AddRecipe`.
- If a recipe needs products that are missing from the catalog, add them using `AddProduct`.
- After modifying the plan, verify the result using `GetPlanning`.
- Never invent UUIDs-always retrieve them from tool outputs.

# Important Rules

- Never fabricate UUIDs.
- Always use tools instead of assumptions.
- Verify all modifications.
- Prefer existing recipes and ingredients over duplicates.
- Be proactive and autonomous in tool use.

""";
}

class Jproperty {
  String type = "integer";
  String description;

  Jproperty(this.type, this.description);
}

class JtoolSchema {
  List<String> requiredProps;
  Map<String, Jproperty> properties;
  String type;

  JtoolSchema({this.requiredProps = const [], this.properties = const {}, this.type = "object"});

  String intoFllamaJsonSchema() {
    return jsonEncode({
      "type": type,
      "requiredProps": requiredProps,
      "properties": properties.map((String key, Jproperty value) {
        return MapEntry(key, {"type": value.type, "description": value.description});
      }),
    });
  }

  ToolParametersSchema intoCactusSchema() {
    /*
    CactusTool(
      name: "get_weather",
      description: "Get current weather for a location",
      parameters: ToolParametersSchema(
        properties: {
          'location': ToolParameter(type: 'string', description: 'City name', required: true),
        },
      ),
    ),
    
    */
    return ToolParametersSchema(
      type: type,
      properties: properties.map((key, Jproperty value) {
        return MapEntry(key, ToolParameter(type: value.type, required: requiredProps.contains(key), description: value.description));
      }),
    );
  }
}

String toolError(String errorMsg) {
  return jsonEncode({"responseType": "Error", "errorMessage": errorMsg});
}

List<Jtool> getTools(ScheduleProvider scheduleProvider, ProductProvider productProvider, RecipeProvider recipeProvider, String enviromentId) {
  return [
    Jtool(
      name: "GetPlanning",
      description: "Retrieve the current meal planning for the next N days.",
      jsonSchema: JtoolSchema(requiredProps: ["days"], properties: {"days": Jproperty("integer", "Number of future days to retrieve")}),
      tool: (Map<String, dynamic> args) async {
        if (args["days"] == null) {
          return toolError("the number of days is needed");
        }
        int days = 0;
        try {
          days = int.parse(args["days"]);
        } on FormatException catch (_, _) {
          return toolError("the number of days must be an integer");
        }

        List<Map<String, dynamic>> ret = [];

        int currentWeek = getCurrentWeek();
        DateTime startOfWeek = getStartOfWeek(currentWeek);
        int currentDay = getCurrentDayOfTheWeek();

        int sum = 0;

        for (int i = 0; i < days; i++) {
          int iWeek = currentWeek + (i / 7).floor();
          int iDay = currentDay + i % 7;

          final date = startOfWeek.add(Duration(days: i));

          List<ScheduleEntry> scheduleEntries = await scheduleProvider.getEntries(iWeek, iDay, enviromentId);
          List<Recipe?> recipes = await Future.wait(scheduleEntries.map((e) => recipeProvider.getRecipeById(e.recipeId)));
          sum += recipes.length;
          
          ret.add({
            "day": DateFormat('EEEE d').format(date),
            "planedMeals": recipes.map((Recipe? recipe) {
              return {"recipeUUID": recipe!.id, "name": recipe.name};
            }).toList(),
          });
        }

        return jsonEncode({"responseType": "Success", "totalPlannedMealsInRange": sum, "data": ret});
      },
    ),

    Jtool(
      name: "GetProductCatalog",
      description: "Retrieve all known products in the catalog.",
      jsonSchema: JtoolSchema(),
      tool: (_) async {
        return "This is a tool response";
      },
    ),

    Jtool(
      name: "AddProduct",
      description: "Add a new product to the catalog.",
      jsonSchema: JtoolSchema(requiredProps: ["name"], properties: {"name": Jproperty("string", "Product name")}),
      tool: (Map<String, dynamic> args) async {
        if (args["name"] == null || args["name"].trim().length <= 2) {
          return toolError("the argument 'name' must be present and contain more than 2 characters");
        }

        String productId = await productProvider.addProduct(args["name"], false, enviromentId);

        return jsonEncode({"responseType": "Success", "createdProductId": productId});
      },
    ),

    Jtool(
      name: "GetRecipeBook",
      description: "Retrieve all recipes in the recipe book.",
      jsonSchema: JtoolSchema(),
      tool: (_) async {
        return "This is a tool response";
      },
    ),

    Jtool(
      name: "AddRecipe",
      description: "Create a new recipe using existing ingredient UUIDs.",
      jsonSchema: JtoolSchema(
        requiredProps: ["name", "productUUIDs"],
        properties: {"name": Jproperty("string", "Recipe name"), "productUUIDs": Jproperty("array", "List of product UUIDs")},
      ),
      tool: (_) async {
        return "This is a tool response";
      },
    ),

    Jtool(
      name: "SetMeal",
      description: "Assign a recipe to a specific day.",
      jsonSchema: JtoolSchema(
        requiredProps: ["day", "recipeUUID"],
        properties: {"day": Jproperty("integer", "0=today, 1=tomorrow, etc."), "recipeUUID": Jproperty("string", "UUID of recipe to assign")},
      ),
      tool: (_) async {
        return "This is a tool response";
      },
    ),
  ];
}



String invokeTool(String toolCall) {
  if (toolCall == "") {
    return "";
  }

  print("tool call [$toolCall]");

  dynamic parsedToolCall = jsonDecode(toolCall);

  switch (parsedToolCall["name"]) {
    case ("GetPlanning"):
      return getPlanning(parsedToolCall["arguments"]["days"]);
    case ("GetProductCatalog"):
      return getProductCatalog();
  }

  return "The called tool is not enabled";
}

String getPlanning(int days) {
  return "chicken breast all the $days days";
}

String getProductCatalog() {
  return "no products";
}
