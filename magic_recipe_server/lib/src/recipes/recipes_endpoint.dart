// magic_recipe_server/lib/src/recipes/recipes_endpoint.dart
//
//
import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:serverpod/serverpod.dart';
import 'package:magic_recipe_server/src/generated/protocol.dart';
import 'package:meta/meta.dart';

@visibleForTesting
var generateContent =
    (String apiKey, String prompt) async => (await GenerativeModel(
          model: 'gemini-2.5-flash',
          apiKey: apiKey,
        ).generateContent([Content.text(prompt)]))
            .text;

/// This is the endpoint that will be used to generate a recipe using the
/// Google Gemini API. It extends the Endpoint class and implements the
/// generateRecipe method.
class RecipesEndpoint extends Endpoint {
  ///Pass in a string contaiing the ingredients and get a recipe back
  Future<Recipe> generateRecipe(Session session, String ingredients) async {
    // Serverpod automatically loads your passwords.yaml file and makes passwords
    // available in the session.passwords map
    final geminiApiKey = session.passwords['gemini'];

    if (geminiApiKey == null) {
      throw Exception('Gemini API key not found');
    }

    // A prompt to generate a recipe, the user will provide a free text input with the ingredients
    final prompt =
        'Generate a recipe using the following ingredients: $ingredients, always put the title '
        'of the recipe in the first line, and then the instructions. The recipe should be easy '
        'to follow and include all necessary steps. Please provide a detailed recipe.';

    final responseText = await generateContent(geminiApiKey, prompt);

    //check if the response is empty or null
    if (responseText == null || responseText.isEmpty) {
      throw Exception('No response from Gemini API');
    }

    final recipe = Recipe(
      author: 'Gemini',
      text: responseText,
      date: DateTime.now(),
      ingredients: ingredients,
    );

    final recipeWithId = await Recipe.db.insertRow(session, recipe);

    return recipeWithId;
  }

  Future<List<Recipe>> getRecipies(Session session) async {
    return Recipe.db.find(
      session,
      orderBy: (t) => t.date,
      orderDescending: true,
    );
  }
}
