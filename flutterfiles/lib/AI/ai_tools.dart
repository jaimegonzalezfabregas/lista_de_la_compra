import 'package:cactus/cactus.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:lista_de_la_compra/AI/AI_Inferers/ai_inferer_interface.dart';

String getContext() {
  return """You are an **agentic personal meal planner**. Your objective is to manipulate the user's meal plan exactly as the user requests.

As an agentic LLM, you are able to call tools to inspect, modify, and organize the meal plan, ingredients, and recipes.

Today is `${DateFormat.yMMMMEEEEd().format(DateTime.now())}`. The date info may be useful during conversation, but is never needed as a input to the tools.

# Core Behavior

Your responsibilities include:

- Viewing current meal plans
- Adding or changing meals on specific days
- Looking up existing recipes
- Creating new recipes
- Looking up ingredients
- Adding missing ingredients
- Verifying that requested changes were successfully applied

You should act autonomously:

- When the user asks to change a meal, first inspect existing planning if needed.
- When the user references a recipe by name, search the recipe book to find its UUID.
- If a requested recipe does not exist, create it using `AddRecipe`.
- If a recipe needs ingredients that are missing from the catalog, add them using `AddIngredient`.
- After modifying the plan, verify the result using `GetPlanning`.
- Never invent UUIDs-always retrieve them from tool outputs.

### Usage Notes

Always obtain the recipe UUID from `GetRecipeBook`.

After setting a meal, verify success with `GetPlanning`.

---

# Agent Workflow Guidelines

### If the user wants to schedule an existing meal

1. Use `GetRecipeBook`
2. Find the recipe UUID
3. Use `SetMeal`
4. Use `GetPlanning` to verify

---

### If the user wants to schedule a new recipe

1. Use `GetRecipeBook` to check if it exists
2. If missing:
   - Use `GetIngredientCatalog`
   - Add any missing ingredients with `AddIngredient`
   - Create recipe with `AddRecipe`
3. Use `SetMeal`
4. Use `GetPlanning` to verify

---

### If the user asks what is planned

Use `GetPlanning`.

---

# Important Rules

- Never fabricate UUIDs.
- Always use tools instead of assumptions.
- Verify all modifications.
- Prefer existing recipes and ingredients over duplicates.
- Be proactive and autonomous in tool use.
- Only output tool JSON when calling a tool; otherwise respond normally to the user.

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
      type: type,
      requiredProps: requiredProps,
      properties: properties.map((String key, Jproperty value) {
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

List<Jtool> getTools() {
  return [
    Jtool(
      name: "GetPlanning",
      description: "Retrieve the current meal planning for the next N days.",
      jsonSchema: JtoolSchema(requiredProps: ["days"], properties: {"days": Jproperty("integer", "Number of future days to retrieve")}),
      tool: (_) {
        return "This is a tool response";
      },
    ),

    Jtool(
      name: "GetIngredientCatalog",
      description: "Retrieve all available ingredients.",
      jsonSchema: JtoolSchema(),
      tool: (_) {
        return "This is a tool response";
      },
    ),

    Jtool(
      name: "AddIngredient",
      description: "Add a new ingredient to the catalog.",
      jsonSchema: JtoolSchema(requiredProps: ["name"], properties: {"name": Jproperty("string", "Ingredient name")}),
      tool: (_) {
        return "This is a tool response";
      },
    ),

    Jtool(
      name: "GetRecipeBook",
      description: "Retrieve all recipes in the recipe book.",
      jsonSchema: JtoolSchema(),
      tool: (_) {
        return "This is a tool response";
      },
    ),

    Jtool(
      name: "AddRecipe",
      description: "Create a new recipe using existing ingredient UUIDs.",
      jsonSchema: JtoolSchema(
        requiredProps: ["name", "ingredientUUIDs"],
        properties: {"name": Jproperty("string", "Recipe name"), "ingredientUUIDs": Jproperty("array", "List of ingredient UUIDs")},
      ),
      tool: (_) {
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
      tool: (_) {
        return "This is a tool response";
      },
    ),
  ];
}

(String, Map<String, dynamic>?) extractLastJson(String input) {
  if (input[input.length - 1] != '}') return (input, null);

  int braceCount = 0;
  int bracketCount = 0;

  for (int i = input.length - 1; i >= 0; i--) {
    var char = input[i];

    if (char == '}') braceCount++;
    if (char == '{') braceCount--;

    if (char == ']') bracketCount++;
    if (char == '[') bracketCount--;

    // When balanced, we found the start
    if (braceCount == 0 && bracketCount == 0) {
      return (input.substring(0, i), jsonDecode(input.substring(i, input.length)));
    }
  }

  return (input, null);
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
    case ("GetIngredientCatalog"):
      return getIngredientCatalog();
  }

  return "The called tool is not enabled";
}

String getPlanning(int days) {
  return "chicken breast all the $days days";
}

String getIngredientCatalog() {
  return "no ingredients";
}
