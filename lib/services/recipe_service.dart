import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';
import '../config/app_config.dart';

class RecipeService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  
  // Cache para melhorar performance
  static final Map<String, List<Recipe>> _categoryCache = {};
  static final Map<String, Recipe> _recipeCache = {};
  static final Map<String, List<String>> _categoriesCache = {};
  static DateTime? _lastCategoryUpdate;

  // Buscar receitas por categoria (otimizado com cache e requisições paralelas)
  static Future<List<Recipe>> getRecipesByCategory(String category) async {
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
          // Limitar receitas para melhor performance
          final limitedMeals = meals.take(AppConfig.maxCategoryRecipes).toList();
          
          // Buscar detalhes em paralelo (máximo 5 simultâneas)
          final futures = limitedMeals.map((meal) => getRecipeById(meal['idMeal']));
          final recipes = await Future.wait(futures);
          
          // Filtrar receitas válidas e salvar no cache
          final validRecipes = recipes.where((recipe) => recipe != null).cast<Recipe>().toList();
          _categoryCache[category] = validRecipes;
          
          return validRecipes;
        }
      }
      return [];
    } catch (e) {
      print('Erro ao buscar receitas: $e');
      return [];
    }
  }

  // Buscar receita por ID (otimizado com cache)
  static Future<Recipe?> getRecipeById(String id) async {
    // Verificar cache primeiro
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
          _recipeCache[id] = recipe; // Salvar no cache
          return recipe;
        }
      }
      return null;
    } catch (e) {
      print('Erro ao buscar receita: $e');
      return null;
    }
  }

  // Buscar receitas aleatórias (otimizado com requisições paralelas)
  static Future<List<Recipe>> getRandomRecipes(int count) async {
    try {
      // Limitar receitas para melhor performance
      final limitedCount = count > AppConfig.maxRandomRecipes ? AppConfig.maxRandomRecipes : count;
      
      // Criar requisições paralelas
      final futures = List.generate(limitedCount, (index) => _getSingleRandomRecipe());
      final recipes = await Future.wait(futures);
      
      // Filtrar receitas válidas
      return recipes.where((recipe) => recipe != null).cast<Recipe>().toList();
    } catch (e) {
      print('Erro ao buscar receitas aleatórias: $e');
      return [];
    }
  }

  // Método auxiliar para buscar uma receita aleatória
  static Future<Recipe?> _getSingleRandomRecipe() async {
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
      print('Erro ao buscar receita aleatória: $e');
      return null;
    }
  }

  // Buscar categorias (otimizado com cache)
  static Future<List<String>> getCategories() async {
    // Verificar cache (válido por tempo configurado)
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
          
          // Salvar no cache
          _categoriesCache['categories'] = categoryList;
          _lastCategoryUpdate = DateTime.now();
          
          return categoryList;
        }
      }
      return [];
    } catch (e) {
      print('Erro ao buscar categorias: $e');
      return [];
    }
  }

  // Buscar receitas por nome (otimizado com requisições paralelas)
  static Future<List<Recipe>> searchRecipes(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search.php?s=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meals = data['meals'] as List?;
        
        if (meals != null && meals.isNotEmpty) {
          // Limitar receitas para melhor performance
          final limitedMeals = meals.take(AppConfig.maxSearchResults).toList();
          
          // Buscar detalhes em paralelo
          final futures = limitedMeals.map((meal) => getRecipeById(meal['idMeal']));
          final recipes = await Future.wait(futures);
          
          // Filtrar receitas válidas
          return recipes.where((recipe) => recipe != null).cast<Recipe>().toList();
        }
      }
      return [];
    } catch (e) {
      print('Erro ao buscar receitas: $e');
      return [];
    }
  }

  // Método para limpar cache (útil para desenvolvimento)
  static void clearCache() {
    _categoryCache.clear();
    _recipeCache.clear();
    _categoriesCache.clear();
    _lastCategoryUpdate = null;
  }
}
