import 'package:fllama/fllama.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

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

---

# Tool Invocation Format

To run a tool, output JSON in exactly this format:

```json
{"tool":"<TOOLNAME>", "args":{...}}
```

The tool response will then be returned to you.

---

# Tools

## GetPlanning

Retrieve the current meal plan for upcoming days.

### Arguments

```json
{"tool":"GetPlanning","args":{"days":4}}
```

### Example Response

```json
[
  {
    "day":"12 May 2026 Tuesday",
    "meals":[
      {"id":"<UUID>","name":"Chocolate con churros"},
      {"id":"<UUID>","name":"Patatas con bacalao"}
    ]
  }
]
```

### Usage Notes

Use this tool to:

- Inspect current meal assignments
- Determine what is planned on a given day
- Verify successful updates after using `SetMeal`

---

## GetIngredientCatalog

Retrieve all available ingredients currently known to the system.

### Arguments

```json
{"tool":"GetIngredientCatalog","args":{}}
```

### Example Response

```json
[
  {"id":"<UUID>","name":"Tomato"},
  {"id":"<UUID>","name":"Olive Oil"},
  {"id":"<UUID>","name":"Egg"}
]
```

### Usage Notes

Use this before creating recipes to check whether ingredients already exist.

---

## AddIngredient

Create a new ingredient in the catalog.

### Arguments

```json
{"tool":"AddIngredient","args":{"name":"Chickpeas"}}
```

### Example Response

```json
{"id":"<UUID>","name":"Chickpeas"}
```

### Usage Notes

Use only when an ingredient needed for a recipe does not already exist.

---

## GetRecipeBook

Retrieve all existing recipes.

### Arguments

```json
{"tool":"GetRecipeBook","args":{}}
```

### Example Response

```json
[
  {
    "id":"<UUID>",
    "name":"Paella"
  },
  {
    "id":"<UUID>",
    "name":"Gazpacho"
  }
]
```

### Usage Notes

Always use this tool to find recipe UUIDs before calling `SetMeal`.

---

## AddRecipe

Create a new recipe.

### Arguments

```json
{
  "tool":"AddRecipe",
  "args":{
    "name":"Lentil Soup",
    "ingredientUUIDs":["<UUID1>","<UUID2>"]
  }
}
```

### Example Response

```json
{
  "id":"<UUID>",
  "name":"Lentil Soup"
}
```

### Usage Notes

Before calling:

1. Check whether the recipe already exists with `GetRecipeBook`
2. Ensure all required ingredients exist using `GetIngredientCatalog`
3. Add missing ingredients using `AddIngredient`

---

## SetMeal

Assign a recipe to a specific future day.

### Arguments

```json
{
  "tool":"SetMeal",
  "args":{
    "day":2,
    "recipeUUID":"<UUID>"
  }
}
```

### Meaning of `day`

- `0` = today
- `1` = tomorrow
- `2` = day after tomorrow
- etc.

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

List<Tool> getTools() {
  return [
    Tool(
      name: "GetPlanning",
      description: "Retrieve the current meal planning for the next N days.",
      jsonSchema: '''
{
  "type": "object",
  "properties": {
    "days": {
      "type": "integer",
      "description": "Number of future days to retrieve"
    }
  },
  "required": ["days"]
}
''',
    ),

    Tool(
      name: "GetIngredientCatalog",
      description: "Retrieve all available ingredients.",
      jsonSchema: '''
{
  "type": "object",
  "properties": {}
}
''',
    ),

    Tool(
      name: "AddIngredient",
      description: "Add a new ingredient to the catalog.",
      jsonSchema: '''
{
  "type": "object",
  "properties": {
    "name": {
      "type": "string",
      "description": "Ingredient name"
    }
  },
  "required": ["name"]
}
''',
    ),

    Tool(
      name: "GetRecipeBook",
      description: "Retrieve all recipes in the recipe book.",
      jsonSchema: '''
{
  "type": "object",
  "properties": {}
}
''',
    ),

    Tool(
      name: "AddRecipe",
      description: "Create a new recipe using existing ingredient UUIDs.",
      jsonSchema: '''
{
  "type": "object",
  "properties": {
    "name": {
      "type": "string",
      "description": "Recipe name"
    },
    "ingredientUUIDs": {
      "type": "array",
      "description": "List of ingredient UUIDs",
      "items": {
        "type": "string"
      }
    }
  },
  "required": ["name", "ingredientUUIDs"]
}
''',
    ),

    Tool(
      name: "SetMeal",
      description: "Assign a recipe to a specific day.",
      jsonSchema: '''
{
  "type": "object",
  "properties": {
    "day": {
      "type": "integer",
      "description": "0=today, 1=tomorrow, etc."
    },
    "recipeUUID": {
      "type": "string",
      "description": "UUID of recipe to assign"
    }
  },
  "required": ["day", "recipeUUID"]
}
''',
    ),
  ];
}

String? extractLastJson(String input) {
    int endObject = input.lastIndexOf('}');
    int endArray = input.lastIndexOf(']');

    int end = endObject > endArray ? endObject : endArray;

    if (end == -1) return null;

    int braceCount = 0;
    int bracketCount = 0;

    for (int i = end; i >= 0; i--) {
      var char = input[i];

      if (char == '}') braceCount++;
      if (char == '{') braceCount--;

      if (char == ']') bracketCount++;
      if (char == '[') bracketCount--;

      // When balanced, we found the start
      if (braceCount == 0 && bracketCount == 0) {
        return input.substring(i, end + 1);
      }
    }

    return null;
  
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
