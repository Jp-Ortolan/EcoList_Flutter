import '../../models/food_item.dart';

/// Interface do repositório de alimentos (Domain Layer)
/// Define os contratos que devem ser implementados pela camada de dados
abstract class FoodRepository {
  /// Carrega todos os alimentos
  Future<List<FoodItem>> loadFoods();

  /// Adiciona um novo alimento
  Future<void> addFood(FoodItem food);

  /// Atualiza um alimento existente
  Future<void> updateFood(FoodItem food);

  /// Remove um alimento
  Future<void> deleteFood(String foodId);

  /// Obtém alimentos próximos do vencimento
  Future<List<FoodItem>> getNearExpiryFoods();

  /// Obtém alimentos vencidos
  Future<List<FoodItem>> getExpiredFoods();

  /// Obtém alimentos por categoria
  Future<List<FoodItem>> getFoodsByCategory(FoodCategory category);

  /// Busca alimentos por nome
  Future<List<FoodItem>> searchFoods(String query);

  /// Obtém estatísticas dos alimentos
  Future<Map<String, int>> getStatistics();
}

