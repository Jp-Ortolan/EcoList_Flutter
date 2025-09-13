import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_item.dart';

class FoodService {
  static const String _foodsKey = 'food_items';
  
  // Salvar alimentos
  static Future<void> saveFoods(List<FoodItem> foods) async {
    final prefs = await SharedPreferences.getInstance();
    final foodsJson = foods.map((food) => food.toJson()).toList();
    await prefs.setString(_foodsKey, jsonEncode(foodsJson));
  }

  // Carregar alimentos
  static Future<List<FoodItem>> loadFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final foodsString = prefs.getString(_foodsKey);
    
    if (foodsString == null) return [];
    
    try {
      final foodsJson = jsonDecode(foodsString) as List;
      return foodsJson
          .map((json) => FoodItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Erro ao carregar alimentos: $e');
      return [];
    }
  }

  // Adicionar novo alimento
  static Future<void> addFood(FoodItem food) async {
    final foods = await loadFoods();
    foods.add(food);
    await saveFoods(foods);
  }

  // Atualizar alimento
  static Future<void> updateFood(FoodItem updatedFood) async {
    final foods = await loadFoods();
    final index = foods.indexWhere((f) => f.id == updatedFood.id);
    
    if (index != -1) {
      foods[index] = updatedFood;
      await saveFoods(foods);
    }
  }

  // Remover alimento
  static Future<void> deleteFood(String foodId) async {
    final foods = await loadFoods();
    foods.removeWhere((f) => f.id == foodId);
    await saveFoods(foods);
  }

  // Obter alimentos próximos do vencimento
  static Future<List<FoodItem>> getNearExpiryFoods() async {
    final foods = await loadFoods();
    return foods.where((food) => food.isNearExpiryCheck).toList();
  }

  // Obter alimentos vencidos
  static Future<List<FoodItem>> getExpiredFoods() async {
    final foods = await loadFoods();
    return foods.where((food) => food.isExpiredCheck).toList();
  }

  // Obter alimentos por categoria
  static Future<List<FoodItem>> getFoodsByCategory(FoodCategory category) async {
    final foods = await loadFoods();
    return foods.where((food) => food.category == category).toList();
  }

  // Buscar alimentos por nome
  static Future<List<FoodItem>> searchFoods(String query) async {
    final foods = await loadFoods();
    return foods.where((food) => 
      food.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Obter estatísticas
  static Future<Map<String, int>> getStatistics() async {
    final foods = await loadFoods();
    final nearExpiry = foods.where((f) => f.isNearExpiryCheck).length;
    final expired = foods.where((f) => f.isExpiredCheck).length;
    final fresh = foods.length - nearExpiry - expired;
    
    return {
      'total': foods.length,
      'fresh': fresh,
      'nearExpiry': nearExpiry,
      'expired': expired,
    };
  }

  // Sugerir receitas baseadas nos ingredientes disponíveis
  static Future<List<String>> suggestRecipesFromIngredients(List<FoodItem> ingredients) async {
    // Esta função será expandida para integrar com a API de receitas
    final ingredientNames = ingredients.map((ingredient) => ingredient.name.toLowerCase()).toList();
    
    // Sugestões básicas baseadas em ingredientes comuns
    final suggestions = <String>[];
    
    if (ingredientNames.any((name) => name.contains('frango') || name.contains('galinha'))) {
      suggestions.add('Frango Grelhado');
    }
    if (ingredientNames.any((name) => name.contains('arroz'))) {
      suggestions.add('Arroz Branco');
    }
    if (ingredientNames.any((name) => name.contains('tomate'))) {
      suggestions.add('Salada de Tomate');
    }
    if (ingredientNames.any((name) => name.contains('batata'))) {
      suggestions.add('Batata Assada');
    }
    if (ingredientNames.any((name) => name.contains('cebola'))) {
      suggestions.add('Cebola Refogada');
    }
    if (ingredientNames.any((name) => name.contains('alho'))) {
      suggestions.add('Alho Refogado');
    }
    if (ingredientNames.any((name) => name.contains('queijo'))) {
      suggestions.add('Sanduíche de Queijo');
    }
    if (ingredientNames.any((name) => name.contains('ovo'))) {
      suggestions.add('Ovo Frito');
    }
    
    return suggestions;
  }
}
