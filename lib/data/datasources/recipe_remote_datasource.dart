import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/recipe.dart';
import '../../config/app_config.dart';

/// Data source remoto para receitas (Data Layer)
/// Responsável pela comunicação com a API TheMealDB
class RecipeRemoteDataSource {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  /// Cache para melhorar performance
  final Map<String, List<Recipe>> _categoryCache = {};
  final Map<String, Recipe> _recipeCache = {};
  final Map<String, List<String>> _categoriesCache = {};
  DateTime? _lastCategoryUpdate;

  /// Busca receitas por categoria
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    // Verificar cache primeiro
    if (_categoryCache.containsKey(category)) {
      return _categoryCache[category]!;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?c=$category'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meals = data['meals'] as List?;

        if (meals != null && meals.isNotEmpty) {
          final limitedMeals = meals.take(AppConfig.maxCategoryRecipes).toList();
          final futures = limitedMeals.map((meal) => getRecipeById(meal['idMeal']));
          final recipes = await Future.wait(futures);
          final validRecipes = recipes.where((recipe) => recipe != null).cast<Recipe>().toList();
          _categoryCache[category] = validRecipes;
          return validRecipes;
        }
      }
      return [];
    } catch (e) {
      throw Exception('Erro ao buscar receitas por categoria: $e');
    }
  }

  /// Busca receita por ID
  Future<Recipe?> getRecipeById(String id) async {
    if (_recipeCache.containsKey(id)) {
      return _recipeCache[id];
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lookup.php?i=$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meals = data['meals'] as List?;

        if (meals != null && meals.isNotEmpty) {
          final recipe = Recipe.fromJson(meals.first);
          _recipeCache[id] = recipe;
          return recipe;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar receita por ID: $e');
    }
  }

  /// Busca receitas aleatórias
  Future<List<Recipe>> getRandomRecipes(int count) async {
    try {
      final limitedCount = count > AppConfig.maxRandomRecipes ? AppConfig.maxRandomRecipes : count;
      final futures = List.generate(limitedCount, (index) => _getSingleRandomRecipe());
      final recipes = await Future.wait(futures);
      return recipes.where((recipe) => recipe != null).cast<Recipe>().toList();
    } catch (e) {
      throw Exception('Erro ao buscar receitas aleatórias: $e');
    }
  }

  /// Busca uma receita aleatória
  Future<Recipe?> _getSingleRandomRecipe() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/random.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meals = data['meals'] as List?;

        if (meals != null && meals.isNotEmpty) {
          return Recipe.fromJson(meals.first);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Busca categorias
  Future<List<String>> getCategories() async {
    if (_categoriesCache.containsKey('categories') &&
        _lastCategoryUpdate != null &&
        DateTime.now().difference(_lastCategoryUpdate!).inHours < AppConfig.categoryCacheHours) {
      return _categoriesCache['categories']!;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final categories = data['categories'] as List?;

        if (categories != null) {
          final categoryList = categories
              .map((category) => category['strCategory'] as String)
              .toList();
          _categoriesCache['categories'] = categoryList;
          _lastCategoryUpdate = DateTime.now();
          return categoryList;
        }
      }
      return [];
    } catch (e) {
      throw Exception('Erro ao buscar categorias: $e');
    }
  }

  /// Busca receitas por nome
  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search.php?s=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meals = data['meals'] as List?;

        if (meals != null && meals.isNotEmpty) {
          final limitedMeals = meals.take(AppConfig.maxSearchResults).toList();
          final futures = limitedMeals.map((meal) => getRecipeById(meal['idMeal']));
          final recipes = await Future.wait(futures);
          return recipes.where((recipe) => recipe != null).cast<Recipe>().toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Erro ao buscar receitas: $e');
    }
  }

  /// Limpa o cache
  void clearCache() {
    _categoryCache.clear();
    _recipeCache.clear();
    _categoriesCache.clear();
    _lastCategoryUpdate = null;
  }
}

