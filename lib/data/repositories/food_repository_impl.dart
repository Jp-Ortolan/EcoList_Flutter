import '../../domain/repositories/food_repository.dart';
import '../../models/food_item.dart';
import '../datasources/food_local_datasource.dart';

/// Implementação do repositório de alimentos (Data Layer)
class FoodRepositoryImpl implements FoodRepository {
  final FoodLocalDataSource _dataSource;

  FoodRepositoryImpl(this._dataSource);

  @override
  Future<List<FoodItem>> loadFoods() async {
    return await _dataSource.loadFoods();
  }

  @override
  Future<void> addFood(FoodItem food) async {
    final foods = await _dataSource.loadFoods();
    foods.add(food);
    await _dataSource.saveFoods(foods);
  }

  @override
  Future<void> updateFood(FoodItem updatedFood) async {
    final foods = await _dataSource.loadFoods();
    final index = foods.indexWhere((f) => f.id == updatedFood.id);

    if (index != -1) {
      foods[index] = updatedFood;
      await _dataSource.saveFoods(foods);
    }
  }

  @override
  Future<void> deleteFood(String foodId) async {
    final foods = await _dataSource.loadFoods();
    foods.removeWhere((f) => f.id == foodId);
    await _dataSource.saveFoods(foods);
  }

  @override
  Future<List<FoodItem>> getNearExpiryFoods() async {
    final foods = await _dataSource.loadFoods();
    return foods.where((food) => food.isNearExpiryCheck).toList();
  }

  @override
  Future<List<FoodItem>> getExpiredFoods() async {
    final foods = await _dataSource.loadFoods();
    return foods.where((food) => food.isExpiredCheck).toList();
  }

  @override
  Future<List<FoodItem>> getFoodsByCategory(FoodCategory category) async {
    final foods = await _dataSource.loadFoods();
    return foods.where((food) => food.category == category).toList();
  }

  @override
  Future<List<FoodItem>> searchFoods(String query) async {
    final foods = await _dataSource.loadFoods();
    return foods
        .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<Map<String, int>> getStatistics() async {
    final foods = await _dataSource.loadFoods();
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
}

