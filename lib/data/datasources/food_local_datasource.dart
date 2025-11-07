import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/food_item.dart';

/// Data source local para alimentos (Data Layer)
/// Responsável pela persistência local usando SharedPreferences
class FoodLocalDataSource {
  static const String _foodsKey = 'food_items';

  /// Salva lista de alimentos
  Future<void> saveFoods(List<FoodItem> foods) async {
    final prefs = await SharedPreferences.getInstance();
    final foodsJson = foods.map((food) => food.toJson()).toList();
    await prefs.setString(_foodsKey, jsonEncode(foodsJson));
  }

  /// Carrega lista de alimentos
  Future<List<FoodItem>> loadFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final foodsString = prefs.getString(_foodsKey);

    if (foodsString == null) return [];

    try {
      final foodsJson = jsonDecode(foodsString) as List;
      return foodsJson
          .map((json) => FoodItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao carregar alimentos: $e');
    }
  }
}

